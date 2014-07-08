Point = require "../../coffee/Point.coffee"

describe "Point", ->
    describe "Constructor", ->
        it "Should create point with 2 arguments", ->
            p = new Point 2, 2
            p.x.should.to.be.equal 2
            p.y.should.to.be.equal 2

        it "Should recive object as arg;ument", ->
            p = new Point x: 3, y: 4
            p.x.should.to.be.equal 3
            p.y.should.to.be.equal 4

        it "Should recive Point as argument", ->
            p = new Point 2, 3
            p1 = new Point p

            p1.x.should.to.be.equal p.x
            p1.y.should.to.be.equal p.y

    describe "isEqual", ->
        it "Should return true if points are equal otherwise return false", ->
            p = new Point 0, 0

            p.isEqual(p).should.to.be.true
            p.isEqual(new Point 0, 0).should.to.be.true
            p.isEqual(new Point 1, 0).should.to.be.false
