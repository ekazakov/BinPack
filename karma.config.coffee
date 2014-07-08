module.exports = (config) ->
    config.set
        basePath:       ".",
        frameworks:     ["mocha-debug", "mocha", "chai", "sinon-chai"],
        files:          ["dist/js/spec.js"],
        reporters:      ["mocha"],
        port:           9876,
        colors:         true,
        logLevel:       config.LOG_ERROR or "INFO",
        autoWatch:      true,
        browsers:       ["PhantomJS"],
        captureTimeout: 60000,
        singleRun:      false
