"use strict"

Rect = require "./Rect.coffee"
_    = require "lodash"

class Block extends Rect
    constructor: (params) ->
        {@id, @color} = params
        super(params)

    moveTo: (anchor) ->
        new Block anchor: anchor, w: @width, h: @height, id: @id, color: @color

    toJSON: ->
        _({}).extend(super, {id: @id, color: @color}).value()

module.exports = Block
