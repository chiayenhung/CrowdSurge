sqlite = require('sqlite3').verbose()

db = new sqlite.Database "#{__dirname}/../../#{process.env.DB_NAME}"

postController = {}

postController.getPosts = (req, res) ->
  query = "SELECT * from posts"
  db.all query, (err, row) ->
    if err 
      res.send 500, err
    else
      res.render 'home', 
        posts: row
        dateTransform: dateTransform

postController.createPost = (req, res) ->
  content = req.body.content
  date = new Date()
  query = "INSERT INTO posts (content, date ) VALUES('#{content}', '#{date}')"
  db.run query, (err, row) ->
    if err
      res.send 500, err
    else
      query = "SELECT * from posts"
      db.all query, (err, row) ->
        if err
          res.send 500, err
        else
          res.render 'home', 
            posts: row
            dateTransform: dateTransform

postController.updatePost = (req, res) ->
  id = req.body.id
  content = req.body.content
  date = new Date()
  query = "UPDATE posts SET content = '#{content}', date = '#{date}' WHERE ID = #{id}"
  db.run query, (err, row) ->
    if err
      res.send 500, err
    else
      res.send 'success'

postController.deletePost = (req, res) ->
  id = req.body.id
  query = "DELETE FROM posts WHERE ID = #{id}"
  db.run query, (err, row) ->
    if err
      res.send 500, err
    else
      res.send 'success'


module.exports = postController

dateTransform = (dateStr) ->
  d = new Date(dateStr)
  return "#{d.getFullYear()}/#{d.getMonth() + 1}/#{d.getDate()} #{d.getHours()}:#{d.getMinutes()}"