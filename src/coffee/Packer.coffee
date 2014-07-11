"use strict"

Rect  = require "./Rect.coffee"
Point = require "./Point.coffee"
_     = require "lodash"

class Packer
    constructor: (@unpositioned, @width, @callback) ->
        @rectCount = @unpositioned.length
        @positioned = []

    pack: () ->
        Packer.sortRects @unpositioned
        anchor = new Point 0, 0

        while @unpositioned.length
            anchor = @step anchor

    step: (anchor) ->
        rect   = @unpositioned[0]
        stripe = @createStripe anchor, rect

        @subStep stripe, rect

        stripe.bottomLeft

    subStep: (target, rect) ->
        variant = @findBestFillVariant(@createFillOptions target, rect)

        variant?.rects.forEach (rect, index) =>
            @positionRect variant.targets[index].topLeft, rect

        variant?.rects.forEach (rect, index) =>
            @subStep variant.targets[index], rect

    createStripe: (anchor, rect) ->
        @positionRect anchor, rect
        new Rect anchor: anchor, w: @width, h: rect.height

    createFillOptions: (target, rect) ->
        targets = target.split rect

        if _(targets).isEmpty()
            return []

        if targets.length == 1
            return [targets]

        if targets.length == 3
            return [
                [targets[0].join(targets[1]), targets[2]]
                [targets[1].join(targets[2]), targets[0]]
            ]

    findBestFillVariant: (variants) ->
        return if not variants?

        unposRects = @unpositioned.slice()

        results = _(variants)
            .map (variant) =>
                @composeVariant variant, unposRects
            .compact()
            .value()

        return if _(results).isEmpty()
        return results[0] if results.length == 1

        if totalArea(results[0].rects) > totalArea(results[1].rects)
            return results[0]
        else
            return results[1]

    composeVariant: (variant, unposRects) ->
        rects = @findRects variant, unposRects

        if not _(rects).isEmpty()
            rects:   rects
            targets: variant

    findRects: (variant, rects) ->
        _(variant)
            .map (target) =>
                rect = @findSuitableRect rects, target
                rects.splice(rects.indexOf(rect), 1) if rect?
                return rect
            .compact()
            .value()

    findSuitableRect: (rects, target) ->
        return _.find rects, (rect) ->
            return target?.canAccommodate rect

    positionRect: (anchor, rect) ->
        index = @unpositioned.indexOf rect

        if index != -1
            @positioned.push rect.moveTo(anchor)
            @callback _.invoke(@positioned, "toJSON")
            @unpositioned.splice index, 1

Packer.sortRects = (blocks) ->
    blocks.sort (b, a) ->
        if a.area < b.area
            -1
        else if a.area > b.area
            1
        else  0

totalArea = (rects) ->
    if _(rects).isEmpty() then 0 else _(rects).pluck("area").reduce(sum)

sum = (a, b) ->
    a + b

module.exports = Packer
