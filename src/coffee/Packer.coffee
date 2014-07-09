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
