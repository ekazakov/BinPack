"use strict"

class Point
    constructor: (@x, @y) ->
        if arguments.length == 1
            {@x, @y} = arguments[0]

        Object.freeze this

module.exports = Point
