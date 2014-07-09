"use strict"

Packer = require "./../../coffee/Packer.coffee"
Rect   = require "./../../coffee/Rect.coffee"
Point  = require "./../../coffee/Point.coffee"

describe "Packer", ->
    p  = new Point 0, 0
    r1 = new Rect anchor: p, w: 4, h:5
    r2 = new Rect anchor: p, w: 3, h:1
    r3 = new Rect anchor: p, w: 1, h:3
    r4 = new Rect anchor: p, w: 2, h:2
    r5 = new Rect anchor: p, w: 6, h:4

    describe "Constructor", ->

    describe "sortRects", ->
        it "Should to sort rects by height", ->
            rects = [r1, r2, r3, r4, r5]
            Packer.sortRects(rects).should.to.be.eql [r1, r5, r3, r4, r2]

    describe "createSection", ->
        it "Should create new section rect", ->
            packer = new Packer [], 6
            packer.createSection(p, r1).should.to.be.eql new Rect anchor: p, h:5, w:6
