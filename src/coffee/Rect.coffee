"use strict"

Point = require "./Point.coffee"

class Rect
    constructor: (@topLeft, @bottomRight) ->
        if arguments.length == 1
            {x, y, w, h} = arguments[0]
            @topLeft  = new Point x, y
            @bottomRight = new Point x + w, y + h

        @height = @bottomRight.y - @topLeft.y
        @width  = @bottomRight.x - @topLeft.x
        Object.freeze this

    canAccommodate: (rect) ->
        rect.width <= @width and rect.height <= @height

#    vSplit: (xPos) ->
#        throw Error "Split xPos is out of rect side" if xPos >= @bottomRight.x or xPos <= @topLeft.x
#        [
#            new Rect x: @topLeft.x, y: @topLeft.y, h: @height, w: xPos - @topLeft.x
#            new Rect x: xPos, y: @topLeft.y, h: @height, w: @bottomRight.x - xPos
#        ]

    split: (rect) ->
        throw Error "splitter more then target" if not @canAccommodate rect

        if rect.width == @width and rect.height == @height
            return []

        if rect.height == @height
            return [new Rect x: @topLeft.x + rect.width, y: @topLeft.y, w: @width - rect.width, h: @height]

        if rect.width == @width
            return [new Rect x: @topLeft.x, y: @topLeft.y + rect.height, w: @width, h: @height - rect.height]

        [
            new Rect
                 x: @topLeft.x + rect.width
                 y: @topLeft.y
                 w: @width - rect.width
                 h: rect.width

            new Rect
                x: @topLeft.x + rect.width
                y: @topLeft.y + rect.height
                w: @width - rect.width
                h: @height - rect.height

            new Rect
                x: @topLeft.x
                y: @topLeft.y + rect.height
                w: rect.width
                h: @height - rect.height
        ]


    join: (rect) ->
        if @topLeft.y == rect.topLeft.y and @height == rect.height
            @_joinRight rect
        else if @topLeft.x == rect.topLeft.x and @width == rect.width
            @_joinBottom rect

    _joinRight: (rect) ->
        new Rect x: @topLeft.x, y: @topLeft.y, w: @width + rect.width, h: @height

    _joinBottom: (rect) ->
        new Rect x: @topLeft.x, y: @topLeft.y, w: @width, h: @height + rect.height
module.exports = Rect
