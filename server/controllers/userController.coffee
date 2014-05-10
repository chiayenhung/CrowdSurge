passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
sqlite = require('sqlite3').verbose()

db = new sqlite.Database "#{__dirname}/../../#{process.env.DB_NAME}"

userController = {}

userController.login = (req, res) ->
  res.render 'login'

userController.signup = (req, res) ->
  res.render 'signup'

userController.createUser = (req, res) ->
  user =
    username: req.body.username
    password: req.body.password    
  query = "SELECT * from users WHERE username = '#{user.username}'"
  db.get query, (err, row) ->
    if err
      res.send 500, err
    else if row
      res.send 409, 'username exists'
    else
      query = "INSERT INTO users (username, password) VALUES('#{user.username}', '#{user.password}')"
      db.run query, (err, row) ->
        if err
          res.send 500, err
        else
          res.redirect '/'

userController.logout = (req, res) ->
  res.redirect '/login'

module.exports = userController