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
        @setState rects: _.invoke(rects, "toJSON")

    getInitialState: ->
        rects: []

    componentDidMount: ->
        packer = new Packer(@props.rects, 6)

        Packer.sortRects packer.unpositioned
        anchor = new Point 0, 0
        widget = this

        console.log "!"
        tick = ->
            setTimeout ->
                console.log anchor.toJSON()
                anchor = packer.step anchor
                widget.update packer.positioned

                tick() if packer.unpositioned.length

            , 1000

        tick()

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


