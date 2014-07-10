"use strict"

Point = require "./Point.coffee"
_     = require "lodash"

class Rect
    constructor: (params) ->
        if params.anchor?
            {anchor: {x, y}, w, h} = params
        else
            {x, y, w, h} = params

        @topLeft     = new Point x, y
        @topRight    = new Point x + w, y
        @bottomLeft  = new Point x, y + h
        @bottomRight = new Point x + w, y + h
        @height      = h
        @width       = w
        @area        = h * w

        Object.freeze this

    canAccommodate: (rect) ->
        rect.width <= @width and rect.height <= @height

    moveTo: (anchor) ->
        new Rect anchor: anchor, w: @width, h: @height

    split: (rect) ->
        throw Error "splitter more then target" if not @canAccommodate rect

        if rect.width == @width and rect.height == @height
            return []

        if rect.height == @height
            return [new Rect x: @topLeft.x + rect.width, y: @topLeft.y, w: @width - rect.width, h: @height]

        if rect.width == @width
            return [new Rect x: @topLeft.x, y: @topLeft.y + rect.height, w: @width, h: @height - rect.height]

        return [
            new Rect
                 x: @topLeft.x + rect.width
                 y: @topLeft.y
                 w: @width - rect.width
                 h: rect.height

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

    isLeftAdjacent: (rect) ->
        @topLeft.isEqual(rect.topRight) and @bottomLeft.isEqual(rect.bottomRight)

    isRightAdjacent: (rect) ->
        @topRight.isEqual(rect.topLeft) and @bottomRight.isEqual(rect.bottomLeft)

    isTopAdjacent: (rect) ->
        @topLeft.isEqual(rect.bottomLeft) and @topRight.isEqual(rect.bottomRight)

    isBottomAdjacent: (rect) ->
        @bottomLeft.isEqual(rect.topLeft) and @bottomRight.isEqual(rect.topRight)

    isAjacent: (rect) ->
        @isLeftAdjacent(rect) or @isRightAdjacent(rect) or @isTopAdjacent(rect) or @isBottomAdjacent(rect)

    join: (rect) ->
        if @isLeftAdjacent(rect)
            joinLeft this, rect
        else if @isRightAdjacent(rect)
            joinRight this, rect
        else if @isTopAdjacent(rect)
            joinTop this, rect
        else if @isBottomAdjacent(rect)
            joinBottom this, rect
        else
            throw Error "Rect isn't adjacent"

    toJSON: ->
        _({}).extend(@topLeft.toJSON(), {w: @width, h: @height}).value()

joinLeft = (rect1, rect2) ->
    new Rect anchor: rect2.topLeft, w: rect1.width + rect2.width, h: rect1.height

joinRight = (rect1, rect2) ->
    new Rect anchor: rect1.topLeft, w: rect1.width + rect2.width, h: rect1.height

joinTop = (rect1, rect2) ->
    new Rect anchor: rect2.topLeft, w: rect1.width, h: rect1.height + rect2.height

joinBottom = (rect1, rect2) ->
    new Rect anchor: rect1.topLeft, w: rect1.width, h: rect1.height + rect2.height

module.exports = Rect
