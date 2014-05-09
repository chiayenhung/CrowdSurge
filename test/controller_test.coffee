expect = require('chai').expect
should = require('chai').should()
request = require 'request'
sqlite = require('sqlite3').verbose()

APP_ROOT = 'http://localhost:5000'

describe 'test', ->
  # console.log "#{APP_ROOT}"
  # console.log "#{process.env.DB_NAME}"
  db = null

  before (done) ->
    db = new sqlite.Database "#{__dirname}/../#{process.env.DB_NAME}"
    db.serialize ->
      db.run "CREATE TABLE posts (id integer primary key autoincrement, content TEXT, date TEXT)"
      done()

  after (done) ->
    db.serialize ->
      db.run "DROP TABLE posts"
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
      request.post "#{APP_ROOT}", {formData: formData}, (error, response, body) ->
        expect(error).to.equal null
        db.all query, (err, row) ->
          expect(row.length - 1).to.equal rowNum
          done()





