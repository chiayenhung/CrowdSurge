sqlite = require('sqlite3').verbose()

db = new sqlite .Database "#{__dirname}/../../crowdSurge.db"

postController = {}

postController.getPosts = (req, res) ->
  query = "SELECT * from posts"
  db.all query, (err, row) ->
    if err 
      res.send 500, err
    else
      console.log row
      res.render 'home', posts: row

postController.createPost = (req, res) ->
  content = req.body.content
  date = new Date()
  query = "INSERT INTO posts (content, date ) VALUES('#{content}', '#{date}')"
  console.log query
  db.run query, (err, row) ->
    if err
      res.send 500, err
    else
      query = "SELECT * from posts"
      db.all query, (err, row) ->
        if err
          res.send 500, err
        else
          console.log row
          res.render 'home', posts: row

module.exports = postController