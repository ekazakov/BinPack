gulp       = require "gulp"
gutil      = require "gulp-util"
sloc       = require "gulp-sloc"
browserify = require "browserify"
watchify   = require "watchify"
source     = require "vinyl-source-stream"

karma      = require "karma"
                .server

handleError = (err) ->
    gutil.log ">>>", err
    @emit "end";

gulp.task "build", ->
    browserify(["react", "lodash"])
        .require("react")
        .require("lodash")
        .bundle({debug: true})
            .pipe source "libs.js"
            .pipe gulp.dest "dist/js/"

    rebundle = () ->
        bundler.bundle({debug: true})
            .on "error", handleError
            .pipe source "index.js"
            .pipe gulp.dest "dist/js/"

    bundler = watchify("./src/coffee/index.coffee", {extensions: [".coffee"] })

    bundler.transform("coffeeify")
    bundler.external "react"
    bundler.external "lodash"

    bundler.on "update", (ids) ->
        gutil.log "changed files: #{ids}"
        rebundle()

    bundler.on "log", gutil.log

    rebundle()

generateSpec = ->
    rebundle = () ->
        bundler.bundle({debug: true})
        .on "error", handleError
        .pipe source "spec.js"
        .pipe gulp.dest "dist/js/"

    bundler = watchify("./src/tests/index.coffee", {extensions: [".coffee"] })

    bundler.transform "coffeeify"

    bundler.on "update", (ids) ->
        gutil.log "changed files: #{ids}"
        rebundle()

    bundler.on "log", gutil.log

    rebundle()



gulp.task "spec", generateSpec

gulp.task "tdd", (done) ->
    generateSpec()
    config = (require "./karma.config.coffee")
        set: (json) ->
            json

    karma.start(config, done)

gulp.task "sloc", ->
    gulp.src(["src/coffee/**/*.coffee"])
        .pipe sloc()

gulp.task "default", ["tdd"]
