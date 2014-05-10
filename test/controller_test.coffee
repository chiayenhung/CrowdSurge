expect = require('chai').expect
should = require('chai').should()
request = require 'request'
sqlite = require('sqlite3').verbose()

APP_ROOT = 'http://localhost:5000'

describe 'test', ->
  db = null

  before (done) ->
    db = new sqlite.Database "#{__dirname}/../#{process.env.DB_NAME}"
    db.serialize ->
      db.run "CREATE TABLE if not exists posts (id integer primary key autoincrement, content TEXT, date TEXT)"
      done()

  after (done) ->
    db.serialize ->
      db.run "DROP TABLE if exists posts"
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
      request.del "#{APP_ROOT}", {form: formData}, (err, response, body) ->
        query = "SELECT * from posts WHERE id = #{oldRow.id}"
        db.get query,(err, row) ->
          expect(row).to.equal undefined
          done()
