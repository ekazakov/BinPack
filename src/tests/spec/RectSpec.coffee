"use strict"

Rect = require "./../../coffee/Rect.coffee"
Point = require "./../../coffee/Point.coffee"

describe "Rect", ->
    describe "Constructor", ->
        it "Should create instance with top left and bottom right points", ->
            p1 = new Point 2, 2
            r  = new Rect {anchor: p1, w: 2, h: 5}

            r.topLeft.should.to.be.eql p1
            r.height.should.to.be.equal 5
            r.width.should.to.be.equal 2

        it "Should create instace with top left coordinates and width and height", ->
            r  = new Rect x: 2, y: 2, w: 3, h: 3
            r.topLeft.toJSON().should.to.be.eql x: 2, y: 2
            r.bottomRight.toJSON().should.to.be.eql x: 5, y: 5
            r.height.should.to.be.equal 3
            r.width.should.to.be.equal 3

    describe "canAccommodate", ->
        it "Should return true if react A can accommodate B", ->
            r1 = new Rect x: 2, y: 2, w: 3, h: 3
            r2 = new Rect x: 8, y: 2, w: 2, h: 2
            r3 = new Rect x: 13, y: 2, w: 4, h: 1

            r1.canAccommodate(r2).should.to.be.true
            r1.canAccommodate(r3).should.to.be.false
            r1.canAccommodate(r1).should.to.be.true

    describe "split", ->
        r = new Rect x:2, y:2, w:3, h:3

        it "Should split by equal rect", ->
            r.split(r).should.to.be.eql []

        it "Should split by rect with same height or width", ->
            r1 = new Rect x:0, y:0, w:2, h:3
            r2 = new Rect x:0, y:0, w:3, h:2

            r.split(r1).should.to.be.eql [new Rect x:4, y:2, w:1, h:3]
            r.split(r2).should.to.be.eql [new Rect x:2, y:4, w:3, h:1]

        it "Should split by smaller rect", ->
            r1 = new Rect x:0, y:0, w:2, h:2

            r.split(r1).should.to.be.eql [
                new Rect x:4, y:2, w:1, h:2
                new Rect x:4, y:4, w:1, h:1
                new Rect x:2, y:4, w:2, h:1
            ]

        it "Should throw Error is splitter more then target", ->
            r1 = new Rect x:0, y:0, w:5, h:3

            expect(-> r.split r1).to.throw Error, "splitter more then target"

    describe "adjacent", ->
        r          = new Rect x:2, y:2, w:2, h:2
        leftRect   = new Rect x:1, y:2, w:1, h:2
        rightRect  = new Rect x:4, y:2, w:1, h:2
        topRect    = new Rect x:2, y:1, w:2, h:1
        bottomRect = new Rect x:2, y:4, w:2, h:1

        describe "isLeftAdjacent", ->
            it "Should return true if rects adjacent by left side", ->
                r.isLeftAdjacent(leftRect).should.to.be.true

        describe "isRightAdjacent", ->
            it "Should return true if rects adjacent by right side", ->
                r.isRightAdjacent(rightRect).should.to.be.true

        describe "isTopAdjacent", ->
            it "Should return true if rects adjacent by top side", ->
                r.isTopAdjacent(topRect).should.to.be.true

        describe "isBottomAdjacent", ->
            it "Should return true if rects adjacent by bottom side", ->
                r.isBottomAdjacent(bottomRect).should.to.be.true


    describe "join", ->
        r1         = new Rect x:2, y:2, w:2, h:2
        leftRect   = new Rect x:1, y:2, w:1, h:2
        rightRect  = new Rect x:4, y:2, w:1, h:2
        topRect    = new Rect x:2, y:1, w:2, h:1
        bottomRect = new Rect x:2, y:4, w:2, h:1

        it "Should join adjacent rects", ->
            r1.join(leftRect).should.to.be.eql new Rect x:1, y:2, w:3, h:2
            r1.join(rightRect).should.to.be.eql new Rect x:2, y:2, w:3, h:2
            r1.join(topRect).should.to.be.eql new Rect x:2, y:1, w:2, h:3
            r1.join(bottomRect).should.to.be.eql new Rect x:2, y:2, w:2, h:3

        it "Should to throw error if rects isn't adjacent", ->
            expect(-> r1.join(new Rect x:3, y:3, w:2, h:5)).to.throw Error, "Rect isn't adjacent"
