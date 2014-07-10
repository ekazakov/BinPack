"use strict"

Rect  = require "./Rect.coffee"
Point = require "./Point.coffee"
_     = require "lodash"

class Packer
    constructor: (@unpositioned, @width) ->
        @rectCount = @unpositioned.length
        @positioned = []

    pack: ->
        Packer.sortRects @unpositioned
        anchor = new Point 0, 0

        while @unpositioned.length != 0
            anchor = @step anchor

        @positioned


    step: (anchor) ->
        rect       = @unpositioned.shift()
        section    = @createSection anchor, rect
        subSection = section.split(rect)[0]

        @positioned.push(new Rect anchor: anchor, w: rect.width, h: rect.height)

        if subSection?
            _(@unpositioned).each (rect, index) =>
                if subSection.canAccommodate rect
                    @positioned.push(new Rect anchor: subSection.topLeft, w: rect.width, h: rect.height)
                    @unpositioned.splice index, 1
                    false

        section.bottomLeft

    createSection: (anchor, rect) ->
        new Rect anchor: anchor, w: @width, h: rect.height


    subStep: (sectionVariants, rects) ->
        if _(sectionVariants).isEmpty()
            []
        else if sectionVariants.length == 2
            [sv1, sv2] = sectionVariants

            res1 = fit sv1, rects
            res2 = fit sv2, rects

            if totalArea(res1) > totalArea(res2) then res1 else res2

        else if sectionVariants.length == 1
            tmp = _.find rects, (rect) -> sectionVariants[0].canAccommodate rect

            if tmp? then [tmp] else []
        else
            throw Error

    doo: () ->
        Packer.sortRects @unpositioned
        anchor = new Point 0, 0

        rect   = @unpositioned[0]
        stripe = @createStripe anchor, rect

        unfilled = @getFreeSpace(stripe, rect)
        # if unfilled.length != 1 then throw Error
        rect2 = @findSuitableRect unfilled[0]

        if rect2?
            @positionRect unfilled[0].topLeft, rect2
            unfilled2 = @getFreeSpace unfilled[0], _.last(@positioned)

            options = @createFillOptions unfilled2
            variant = @findBestFillVariant options

            if variant?
                variant.rects.forEach (rect, index) =>
                    @positionRect variant.targets[index].topLeft, rect

                # проверить каждый target на наличие пустого места


    createStripe: (anchor, rect) ->
        @positionRect anchor, rect

        new Rect anchor: anchor, w: @width, h: rect.height

    getFreeSpace: (target, rect) ->
        return target.split rect

    createFillOptions: (targets) ->
        if _(targets).isEmpty()
            return

        if targets.length == 1
            return targets

        if targets.length == 3
            return [
                [targets[0].join(targets[1]), targets[2]]
                [targets[1].join(targets[2]), targets[0]]
            ]

    findBestFillVariant: (variants) ->
        return if not variants?

        rects = _(variants).map (variant) =>
            res = _(variant)
                .map( _.bind(@findSuitableRect, this) )
                .compact()

            if not res.isEmpty()
                return res.value()
        .compact()
        .value()

        return if _(rects).isEmpty()

        if totalArea(rects[0]) > totalArea(rects[1])
            targets: variants[0], rects: rects[0]
        else
            targets: variants[1], rects: rects[1]

    findSuitableRect: (target) ->
        return _.find @unpositioned, (rect) ->
            return target.canAccommodate rect

    fillWithRect: (target) ->
        rect = @findSuitableRect target
        if rect?
            @positionRect target.topLeft, rect

    positionRect: (anchor, rect) ->
        @positioned.push rect.moveTo(anchor)
        index = @unpositioned.indexOf rect
        @unpositioned.splice index, 1


Packer.sortRects = (blocks) ->
    blocks.sort (b, a) ->
        if a.height < b.height
            -1
        else if a.height > b.height
            1
        else  0


fit = (subSection, rects) ->
    _(subSection)
        .map((section) ->
            _.find rects, (rect) -> section.canAccommodate rect)
        .compact()
        .value()
#    subSection.reduce (result, section) ->
#        rect = _.find rects, (rect) -> section.canAccommodate rect
#        result.push rect if rect?
#
#        result
#    , []

totalArea = (rects) ->
    if _(rects).isEmpty() then 0 else _(rects).pluck("area").reduce(sum)

sum = (a, b) ->
    a + b

module.exports = Packer
