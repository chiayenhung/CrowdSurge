fs = require 'fs'
jade = require 'jade'
sqlite3 = require('sqlite3').verbose()

module.exports = (grunt) ->

  # load external grunt tasks
  grunt.loadNpmTasks 'grunt-express'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-env'

  DEV_PATH = "app"
  PRODUCTION_PATH = "dist"


  grunt.initConfig

    express:
      test:
        options:
          server: './server/server'
          port: 5000
      development:
        options:
          server: './server/server'
          port: 3000    

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

    # development:
    #   options:
    #     pretty: false

    #   files: [
    #     {
    #       src: "#{DEV_PATH}/index.jade"
    #       dest: "#{PRODUCTION_PATH}/index.html"
    #     }
    #   ]

    watch:
      express: 
        files:  [ '**/*.coffee' ]
        tasks:  [ 'express:development' ]


  grunt.registerTask 'sqlite3', ->
    db = new sqlite3.Database "#{__dirname}/crowdSurge.db"
    db.serialize ->
      db.run "CREATE TABLE posts (id integer primary key autoincrement, content TEXT, date TEXT)"
      # console.log db
    db.close()

  grunt.registerTask 'default', [
    # 'sqlite3'
    'express:development'
    'watch'
  ]
