"use strict"

React  = require "react"
Point  = require "./Point.coffee"
Rect   = require "./Rect.coffee"
Packer = require "./Packer.coffee"
_      = require "lodash"

{div} = React.DOM

App = React.createClass
    displayName: "App"

    update: (rects) ->
        @setState rects: rects

    getInitialState: ->
        rects: []

    componentDidMount: ->
        packer = new Packer(@props.rects, 8, @update)
        packer.pack()

    renderRects: ->
        @state.rects.map (rect) ->
            (div {
                    className: "block abs-block",
                    style: {
                        height: rect.h * 50
                        width:  rect.w * 50
                        top:    rect.y * 50
                        left:   rect.x * 50
                        backgroundColor: rect.color
                    },
                    key: rect.id
                }
            , rect.id)

    render: ->
        div {}, @renderRects()

module.exports = App


