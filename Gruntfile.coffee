fs = require 'fs'
jade = require 'jade'
sqlite3 = require('sqlite3').verbose()

module.exports = (grunt) ->

  # load external grunt tasks
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-env'
  grunt.loadNpmTasks 'grunt-mocha-test'

  DEV_PATH = "app"
  PRODUCTION_PATH = "public"


  grunt.initConfig

    mochaTest:
      controllers:
        options:
          reporter: 'spec'
        src: ['test/*']

    express:
      test:
        options:
          server: './server/server'
          port: 5000
      development:
        options:
          server: './server/server'
          port: 3000  

    clean:
      development: "#{PRODUCTION_PATH}"

    sass:
      development:
        files: [
          expand: true
          cwd: "#{DEV_PATH}/sass"
          src: ['*.sass']
          dest: "#{PRODUCTION_PATH}/"
          ext: ".css"
        ]  

    coffee:
      development:
        options:
          sourceMap: false
        files: [
          expand: true
          cwd: "#{DEV_PATH}/coffee"
          dest: "#{PRODUCTION_PATH}/js"
          src: ["*.coffee", "**/*.coffee"]
          ext: ".js"
        ]

    watch:
      express: 
        files:  [ 'server/**/*.coffee' ]
        tasks:  ['express:development' ]
      sass:
        files: ['**/*.sass']
        tasks: [ 'clean', 'sass', 'coffee']
      coffee:
        files: ['**/*.coffee']
        tasks: [ 'clean', 'sass', 'coffee']

    env:
      development:
        DB_NAME: 'crowdSurge.db'
      test:
        DB_NAME: 'crowdSurge_test.db'


  grunt.registerTask 'sqlite3', ->
    db = new sqlite3.Database "#{__dirname}/crowdSurge.db"
    db.serialize ->
      db.run "CREATE TABLE if not exists posts (id integer primary key autoincrement, content TEXT, date TEXT)"
      db.run "CREATE TABLE if not exists users (id integer primary key autoincrement, username TEXT, password TEXT)"
    db.close()
    db = new sqlite3.Database "#{__dirname}/crowdSurge_test.db"
    db.serialize ->
      db.run "CREATE TABLE if not exists posts (id integer primary key autoincrement, content TEXT, date TEXT)"
      db.run "CREATE TABLE if not exists users (id integer primary key autoincrement, username TEXT, password TEXT)"
    db.close()

  grunt.registerTask 'test', [
    'env:test'
    'express:test'
    'mochaTest'
  ]


  grunt.registerTask 'default', [
    'sqlite3'
    'clean'
    'env:development'
    'express:development'
    'sass'
    'coffee'
    'watch'
  ]
