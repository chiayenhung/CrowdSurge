expect = require('chai').expect
should = require('chai').should()
request = require 'request'
sqlite = require('sqlite3').verbose()

APP_ROOT = 'http://localhost:5000'

db = new sqlite.Database "#{__dirname}/../#{process.env.DB_NAME}"

describe 'test', ->

  before (done) ->
    db.serialize ->
      db.run "CREATE TABLE if not exists posts (id integer primary key autoincrement, content TEXT, date TEXT)"
      db.run "CREATE TABLE if not exists users (id integer primary key autoincrement, username TEXT, password TEXT)"
      done()
  
  after (done) ->
    db.serialize ->
      db.run "DROP TABLE if exists posts"
      db.run "DROP TABLE if exists users"
      done()

  it 'signup a user', (done) ->
    formData =
      username: 'testuser'
      password: '123456'
    request.post "#{APP_ROOT}/signup", {form: formData}, (error, response, body) ->
      expect(error).to.equal null
      done()

  it 'login', (done) ->
    formData =
      username: 'testuser'
      password: '123456'
    request.post "#{APP_ROOT}/login", {form: formData}, (error, response, body) ->
      expect(error).to.equal null
      done()

  it 'can go to the root', (done) ->
    request.get "#{APP_ROOT}", (error, response, body) ->
      expect(error).to.equal null
      done()

  it 'can create post', (done) ->
    query = "SELECT * from posts"
    db.all query, (err, row) ->
      rowNum = row.length
      formData = 
        content: "test 1"
      request.post "#{APP_ROOT}", {form: formData}, (error, response, body) ->
        expect(error).to.equal null
        db.all query, (err, row) ->
          expect(row.length - 1).to.equal rowNum
          done()

  it 'can update post', (done) ->
    query = "SELECT * from posts"
    db.all query, (err, row) ->
      oldRow = row[0]
      formData = 
        id: oldRow.id
        content: "test 2"
      request.put "#{APP_ROOT}", {form: formData}, (error, response, body) ->
        query = "SELECT * from posts WHERE id = #{oldRow.id}"
        db.get query,(err, row) ->
          expect(row.content).to.equal "test 2"
          done()

  it 'can delete post', (done) ->
    query = "SELECT * from posts"
    db.all query, (err, row) ->
      oldRow = row[0]
      formData = 
        id: oldRow.id
        password: '123456'
      request.del "#{APP_ROOT}", {form: formData}, (err, response, body) ->
        query = "SELECT * from posts WHERE id = #{oldRow.id}"
        db.get query,(err, row) ->
          expect(row).to.equal undefined
          done()
