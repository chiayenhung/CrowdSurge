passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
sqlite = require('sqlite3').verbose()

db = new sqlite.Database "#{__dirname}/../../#{process.env.DB_NAME}"

passport.use new LocalStrategy { passReqToCallback: true }, (req, username, password, done) ->
  query = "SELECT * from users where username = '#{username}'"
  db.get query, (err, row) ->
    if err
      return done(err, false, { message: 'An error occurred.' })
    user = row
    if !user
      return done(err, false, { message: 'Username not found.' })
    done null, user

passport.serializeUser (user, done) ->
  done null, user

passport.deserializeUser (user, done) ->
  done null, user

userController = {}

userController.login = (req, res) ->
  res.render 'login'

userController.createSession = passport.authenticate 'local',
  successRedirect: '/'
  failureRedirect: '/login'

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
          req.login user ,(err) ->
            res.redirect '/'

userController.logout = (req, res) ->
  req.logOut()
  res.redirect '/login'

module.exports = userController