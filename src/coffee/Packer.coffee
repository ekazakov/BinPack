"use strict"

Rect  = require "./Rect.coffee"
Point = require "./Point.coffee"
_     = require "lodash"

class Packer
    constructor: (@unpositioned, @width, @callback) ->
        @rectCount = @unpositioned.length
        @positioned = []

    doo: () ->
        Packer.sortRects @unpositioned
        anchor = new Point 0, 0
        counter = 0

        while @unpositioned.length
            anchor = @step anchor

            counter++
            if counter > 1000 then throw Error("Loop")

    step: (anchor) ->
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

        stripe.bottomLeft

    createStripe: (anchor, rect) ->
        @positionRect anchor, rect

        new Rect anchor: anchor, w: @width, h: rect.height

    getFreeSpace: (target, rect) ->
        return target.split rect

    createFillOptions: (targets) ->
        if _(targets).isEmpty()
            return

        if targets.length == 1
            return [targets]

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

    positionRect: (anchor, rect) ->
        index = @unpositioned.indexOf rect

        if index != -1
            @positioned.push rect.moveTo(anchor)
            @callback _.invoke(@positioned, "toJSON")
            @unpositioned.splice index, 1

Packer.sortRects = (blocks) ->
    blocks.sort (b, a) ->
        if a.height < b.height
            -1
        else if a.height > b.height
            1
        else  0

totalArea = (rects) ->
    if _(rects).isEmpty() then 0 else _(rects).pluck("area").reduce(sum)

sum = (a, b) ->
    a + b

module.exports = Packer
