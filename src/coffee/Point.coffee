"use strict"

class Point
    constructor: (@x, @y) ->
        if arguments.length == 1
            {@x, @y} = arguments[0]

        Object.freeze this

    isEqual: (point) ->
        this == point or (@x == point.x and @y == point.y)

    toJSON: ->
        x: @x
        y: @y

module.exports = Point
