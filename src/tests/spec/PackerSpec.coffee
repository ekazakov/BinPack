"use strict"

Packer = require "./../../coffee/Packer.coffee"
Rect   = require "./../../coffee/Rect.coffee"
Point  = require "./../../coffee/Point.coffee"
_      = require "lodash"

describe "Packer", ->

    sum = (a, b) ->
        a + b

    describe "Constructor", ->

    describe "sortRects", ->
        p  = new Point 0, 0
        r1 = new Rect anchor: p, w: 4, h:5
        r2 = new Rect anchor: p, w: 3, h:1
        r3 = new Rect anchor: p, w: 1, h:3
        r4 = new Rect anchor: p, w: 2, h:2
        r5 = new Rect anchor: p, w: 6, h:4

        it "Should to sort rects by height", ->
            rects = [r1, r2, r3, r4, r5]
            Packer.sortRects(rects).should.to.be.eql [r1, r5, r3, r4, r2]

    describe "createSection", ->
        p  = new Point 0, 0
        r1 = new Rect anchor: p, w: 4, h:5

        it "Should create new section rect", ->
            packer = new Packer [], 6
            packer.createSection(p, r1).should.to.be.eql new Rect anchor: p, h:5, w:6
#            section = packer.createSection(p, r1)

    describe "pack", ->
        p  = new Point 0, 0
        r1 = new Rect anchor: p, w: 4, h:5
        r2 = new Rect anchor: p, w: 3, h:1
        r3 = new Rect anchor: p, w: 1, h:3
        r4 = new Rect anchor: p, w: 2, h:2
        r5 = new Rect anchor: p, w: 6, h:4

        r1_ = {x: 0, y: 0, w: 4, h: 5}
        r2_ = {x: 4, y: 0, w: 1, h: 3}
        r3_ = {x: 0, y: 5, w: 6, h: 4}
        r4_ = {x: 0, y: 9, w: 2, h: 2}
        r5_ = {x: 2, y: 9, w: 3, h: 1}

        it "Should pack rects to bin", ->
            packer = new Packer [r1, r2, r3, r4, r5], 6

            _.invoke(packer.pack(), "toJSON").should.to.eql [r1_, r2_, r3_, r4_, r5_]
#            packer.pack().forEach (rect) ->
#                console.log rect.toJSON()
#            console.log packer.pack()

    describe "sub step", ->
        it "should", ->
            r1 = new Rect x:3, y:0, w:4, h:3
            r2 = new Rect x:3, y:0, w:2, h:2
            r3 = new Rect x:0, y:0, w:2, h:3
            r4 = new Rect x:0, y:0, w:2, h:2
            r5 = new Rect x:0, y:0, w:3, h:1

            rects = [r3, r4, r5]
            r1.split(r2).length.should.to.be.equal 3

            [s0, s1, s2] = r1.split(r2)

            subSections = [
                [s0.join(s1), s2]
                [s1.join(s2), s0]
            ]

            Packer::subStep(subSections, rects).should.to.be.eql [r5, r4]
            Packer::subStep([], rects).should.to.be.eql []

            Packer::subStep([ new Rect(x: 0, y: 0, w:2, h:3) ], rects).should.to.be.eql [r3]
            Packer::subStep([ new Rect(x: 0, y: 0, w:1, h:3) ], rects).should.to.be.eql []







