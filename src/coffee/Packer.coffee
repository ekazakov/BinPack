"use strict"

class Packer
    constructor: (@unpositionedRects, @width) ->
        @positonedRects = []

    pack: ->

Packer.sortRects = (blocks) ->
    blocks.sort (a, b) ->
        if a.height < b.height
            -1
        else if a.height > b.height
            1
        else  0

module.exports = Packer
