"use strict"

Packer = require "./../../coffee/Packer.coffee"
Rect   = require "./../../coffee/Rect.coffee"
Point  = require "./../../coffee/Point.coffee"
_      = require "lodash"

describe "Packer", ->
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

        it.skip "Should pack rects to bin", ->
            packer = new Packer [r1, r2, r3, r4, r5], 6

            _.invoke(packer.pack(), "toJSON").should.to.eql [r1_, r2_, r3_, r4_, r5_]

    describe "sub step", ->
        it.skip "should", ->



    describe "createStripe", ->
        it "Should create new stripe", ->

    describe "getFreeSpace", ->
        it "Should return unfilled rects stripe", ->

    describe "createFillOptions", ->
        rects = [r1, r2, r3, r4, r5] = [
            new Rect x:0, y:0, w:3, h:3
            new Rect x:0, y:0, w:3, h:1
            new Rect x:0, y:0, w:2, h:1
            new Rect x:0, y:0, w:2, h:2
            new Rect x:0, y:0, w:1, h:2
        ]

        packer = new Packer rects, 6

        it "Should return variants how to fill empty space in no options available", ->
            expect(packer.createFillOptions([])).to.be.undefined

        it "Should return variants how to fill empty space in one options available", ->
            rect = new Rect x:5, y:0, w:1, h:3
            packer.createFillOptions([rect]).should.to.be.eql [[rect]]

        it "Should return variants how to fill empty space in three options available", ->
            targets = [
                new Rect x:5, y:0, w:1, h:2
                new Rect x:5, y:2, w:1, h:1
                new Rect x:3, y:2, w:2, h:1
            ]

            packer.createFillOptions(targets).should.to.be.eql [
                [new Rect(x:5, y:0, w:1, h:3), new Rect(x:3, y:2, w:2, h:1)],
                [new Rect(x:3, y:2, w:3, h:1), new Rect(x:5, y:0, w:1, h:2)]
            ]

    describe "postionRect", ->
        rects = [r1, r2, r3, r4, r5] = [
            new Rect x:0, y:0, w:3, h:3
            new Rect x:0, y:0, w:3, h:1
            new Rect x:0, y:0, w:2, h:1
            new Rect x:0, y:0, w:2, h:2
            new Rect x:0, y:0, w:1, h:2
        ]

        it "Should create new positioned rect and remove unpositioned one", ->
            packer = new Packer rects, 6
            anchor = new Point 3, 2
            packer.positionRect anchor, r2

            packer.positioned.length.should.to.be.equal 1
            packer.unpositioned.length.should.to.be.equal 4

            packer.positioned[0].should.to.be.eql r2.moveTo(anchor)


    describe "findBestFillVariant", ->
        rects = [r1, r2, r3, r4, r5] = [
            new Rect x:0, y:0, w:3, h:3
            new Rect x:0, y:0, w:3, h:1
            new Rect x:0, y:0, w:2, h:1
            new Rect x:0, y:0, w:2, h:2
            new Rect x:0, y:0, w:1, h:2
        ]

        it "Should return targets and rects to position", ->
            packer = new Packer rects, 6
            variants = [
                [new Rect(x:5, y:0, w:1, h:3), new Rect(x:3, y:2, w:2, h:1)],
                [new Rect(x:3, y:2, w:3, h:1), new Rect(x:5, y:0, w:1, h:2)]
            ]

            {targets, rects} = packer.findBestFillVariant(variants)

            targets.should.to.be.eql variants[1]
            rects.should.to.be.eql [r2, r5]

        it "Should work if only one variant passed", ->
            packer = new Packer rects, 6

            variants = [
                [new Rect(x:5, y:0, w:1, h:3)]
            ]

            {targets, rects} = packer.findBestFillVariant(variants)

            targets.should.to.be.eql variants[0]
            rects.should.to.be.eql [r5]


    describe "doo", ->
        rects = [r1, r2, r3, r4, r5] = [
            new Rect x:0, y:0, w:3, h:3
            new Rect x:0, y:0, w:3, h:1
            new Rect x:0, y:0, w:2, h:1
            new Rect x:0, y:0, w:2, h:2
            new Rect x:0, y:0, w:1, h:2
        ]

        it "Should pack!", ->
            packer = new Packer rects, 6
#            packer.doo()

            console.log packer.unpositioned
            console.log packer.positioned
