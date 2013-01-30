
should = require('chai').should()
rack = require '../.'
express = require 'express.io'
easyrequest = require 'request'
fs = require 'fs'

describe 'a browserify asset', ->
    app = null

    it 'should work with no hash', (done) ->
        compiled = fs.readFileSync './fixtures/browserify/app.js', 'utf8'
        app = express().http()
        app.use new rack.BrowserifyAsset
            filename: "#{__dirname}/fixtures/browserify/app.coffee"
            url: '/app.js'
        app.listen 7076, ->
            easyrequest 'http://localhost:7076/app.js', (error, response, body) ->
                response.headers['content-type'].should.equal 'text/javascript'
                body.should.equal compiled
                done()

    it 'should work compressed', (done) ->
        compiled = fs.readFileSync './fixtures/browserify/app.min.js', 'utf8'
        app = express().http()
        app.use asset = new rack.BrowserifyAsset
            filename: "#{__dirname}/fixtures/browserify/app.coffee"
            url: '/app.js'
            compress: true
        app.listen 7076, ->
            easyrequest 'http://localhost:7076/app.js', (error, response, body) ->
                response.headers['content-type'].should.equal 'text/javascript'
                body.should.equal compiled
                done()
                    
    afterEach (done) -> process.nextTick ->
        app.server.close done
