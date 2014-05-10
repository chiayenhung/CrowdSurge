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
        user: req.user

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
  password = req.body.password
  userId = req.user
  query = "SELECT * from users WHERE ID = #{userId}"
  db.get query, (err, row) ->
    if err
      return res.send 500, err
    if password != row.password
      return res.send 500, 'wrong password'
    query = "DELETE FROM posts WHERE ID = #{id}"
    db.run query, (err, row) ->
      if err
        res.send 500, err
      else
        res.send 'success'


module.exports = postController

dateTransform = (dateStr) ->
  d = new Date(dateStr)
  hour = d.getHours()
  minute = d.getMinutes()
  if hour < 10
    hour = "0" + hour
  if minute < 10
    minute = "0" + minute
  return "#{d.getFullYear()}/#{d.getMonth() + 1}/#{d.getDate()} #{hour}:#{minute}"
