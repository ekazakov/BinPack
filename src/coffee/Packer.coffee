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

        @positioned.push(rect)

        if subSection?
            _(@unpositioned).each (rect, index) =>
                if subSection.canAccommodate rect
                    @positioned.push(new Rect anchor: subSection.topLeft, w: rect.width, h: rect.height)
                    @unpositioned.splice index, 1
                    false

        section.bottomLeft

    createSection: (anchor, rect) ->
        new Rect anchor: anchor, w: @width, h: rect.height

Packer.sortRects = (blocks) ->
    blocks.sort (b, a) ->
        if a.height < b.height
            -1
        else if a.height > b.height
            1
        else  0

module.exports = Packer
