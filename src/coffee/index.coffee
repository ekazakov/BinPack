"use strict"

React = require "react"
App   = require "./App.coffee"
Block = require "./Block.coffee"

{div} = React.DOM


rects =  [
#    new Block x:0, y:0, w:4, h:3, id: "r1", color: "#E57E7E"
#    new Block x:0, y:0, w:3, h:1, id: "r2", color: "#9C6565"
#    new Block x:0, y:0, w:2, h:1, id: "r3", color: "#34972F"
#    new Block x:0, y:0, w:2, h:2, id: "r4", color: "#228CCF"
#    new Block x:0, y:0, w:1, h:2, id: "r5", color: "#5C72FF"
#    new Block x:0, y:0, w:2, h:6, id: "r6", color: "#3C02FF"
#    new Block x:0, y:0, w:4, h:4, id: "r7", color: "#8C028F"
#    new Block x:0, y:0, w:2, h:2, id: "r8", color: "#4BE3C2"
#    new Block x:0, y:0, w:1, h:1, id: "r9", color: "#7B63C2"
#    new Block x:0, y:0, w:1, h:1, id: "r10", color: "#7B63C2"

    new Block x:0, y:0, w:2, h:6, id: "r1", color: "#E57E7E"
    new Block x:0, y:0, w:4, h:4, id: "r2", color: "#9C6565"
    new Block x:0, y:0, w:2, h:2, id: "r3", color: "#34972F"
    new Block x:0, y:0, w:2, h:4, id: "r4", color: "#228CCF"
    new Block x:0, y:0, w:4, h:2, id: "r5", color: "#5C72FF"
    new Block x:0, y:0, w:4, h:4, id: "r6", color: "#3C02FF"
    new Block x:0, y:0, w:2, h:2, id: "r7", color: "#8C028F"
    new Block x:0, y:0, w:2, h:2, id: "r8", color: "#4BE3C2"
#    new Block x:0, y:0, w:2, h:4, id: "r9", color: "#7B63C2"
#    new Block x:0, y:0, w:4, h:2, id: "r10", color: "#7B63C2"
#    new Block x:0, y:0, w:2, h:2, id: "r11", color: "#4BE3C2"
#    new Block x:0, y:0, w:4, h:2, id: "r12", color: "#4BE3C2"
#    new Block x:0, y:0, w:2, h:2, id: "r13", color: "#4BE3C2"
#    new Block x:0, y:0, w:4, h:2, id: "r14", color: "#3C02FF"
#    new Block x:0, y:0, w:6, h:2, id: "r15", color: "#3C02FF"
    new Block x:0, y:0, w:2, h:2, id: "r16", color: "#4BE3C2"
]

BlocksList = React.createClass
    displayName: "BlocksList"

    renderUnpositionedRects: ->
        @props.rects.map (rect) =>
            (div {
                    className: "block",
                    style: {
                        height: rect.height * 50,
                        width: rect.width * 50
                        backgroundColor: rect.color
                    },
                    key: rect.id
                }
            , rect.id)

    render: ->
        div {}, @renderUnpositionedRects()



React.renderComponent BlocksList({rects: rects}), document.getElementById("blocks")
React.renderComponent App({rects: rects}), document.getElementById("root")
