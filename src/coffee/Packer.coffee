"use strict"

Rect  = require "./Rect.coffee"
Point = require "./Point.coffee"

class Packer
    constructor: (@unpositionedRects, @width) ->
        @rectCount      = @unpositionedRects.length
        @positonedRects = []

    pack: ->
        Packer.sortRects @unpositionedRects

        rect = @unpositionedRects[0]
        section = @createSection

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
