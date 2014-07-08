"use strict"

Rect = require "./../../coffee/Rect.coffee"
Point = require "./../../coffee/Point.coffee"

describe "Rect", ->
    describe "Constructor", ->
        it "Should create instance with top left and bottom right points", ->
            p1 = new Point 2, 2
            p2 = new Point 4, 7
            r  = new Rect p1, p2

            r.topLeft.toJSON().should.to.be.eql p1.toJSON()
            r.bottomRight.toJSON().should.to.be.eql p2.toJSON()
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


#    describe "vSplit", ->
#        it "Should to split rect by vertical", ->
#            r = new Rect x:2, y:2, w:3, h:3
#            r.vSplit(4).should.to.be.eql [new Rect(x:2, y:2, w:2, h:3), new Rect(x:4, y:2, w:1, h:3)]
#
#        it "Should throw error if xPos not in rect or rect corner", ->
#            r = new Rect x:2, y:2, w:3, h:3
#            expect(-> r.vSplit 6).to.throw Error, "Split xPos is out of rect side"
#            expect(-> r.vSplit 2).to.throw Error, "Split xPos is out of rect side"
#            expect(-> r.vSplit 0).to.throw Error, "Split xPos is out of rect side"

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

    describe "join", ->
        it "Should join adjacent rects", ->
            r1 = new Rect x:2, y:2, w:2, h:2
            r2 = new Rect x:4, y:2, w:1, h:2
            r3 = new Rect x:2, y:4, w:2, h:1

            r1.join(r2).should.to.be.eql new Rect x:2, y:2, w:3, h:2
            r1.join(r3).should.to.be.eql new Rect x:2, y:2, w:2, h:3


