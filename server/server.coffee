express = require 'express'
sqlite = require 'sqlite3'
jade = require 'jade'

userController = require './controllers/userController'
postController = require './controllers/postController'

# db = new sqlite.Database "#{__dirname}/../crowdSurge.db"

app = express()

app.configure ->
  app.use express.compress()
  app.set 'title', "CrowdSurge"
  app.set 'views', "#{__dirname}/pages"
  app.set 'view engine', 'jade'
  app.use express.cookieParser()
  app.use express.session(secret: '1234567890QWERTY')
  app.use express.bodyParser()
  app.use express.static("#{__dirname}/../public/")

  app.get '/login', userController.login
  # app.post '/signin', userControler.singin
  app.get '/signup', userController.signup
  # app.post '/signup', userControler.createUser
  app.get '/home', postController.getPosts
  app.post '/home', postController.createPost

module.exports = app
