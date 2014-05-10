express = require 'express'
sqlite = require 'sqlite3'
jade = require 'jade'

userController = require './controllers/userController'
postController = require './controllers/postController'

app = express()

ensureAuth = (req, res, next) ->
  if req.cookies.user || req.url in ['/login', '/signup', '/main.css']
    next()
  else
    res.redirect '/login'


app.configure ->
  app.use express.compress()
  app.set 'title', "CrowdSurge"
  app.set 'views', "#{__dirname}/pages"
  app.set 'view engine', 'jade'
  app.use express.cookieParser()
  app.use express.session(secret: '1234567890QWERTY')
  app.use express.bodyParser()
  app.use express.static("#{__dirname}/../public/")

  # app.use ensureAuth

  app.get '/login', userController.login
  app.get '/signup', userController.signup
  app.post '/signup', userController.createUser
  app.get '/logout', userController.logout

  app.get '/', postController.getPosts
  app.post '/', postController.createPost
  app.put '/', postController.updatePost
  app.delete '/', postController.deletePost


module.exports = app

