"use strict"

React  = require "react"
Rect   = require "./Rect.coffee"
Packer = require "./Packer.coffee"

{div} = React.DOM

App = React.createClass
    displayName: "App"

    render: ->
        div {}, "Hello"

module.exports = App


