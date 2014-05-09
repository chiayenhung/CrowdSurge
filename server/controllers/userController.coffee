userController = {}

userController.login = (req, res) ->
  res.render 'login'

userController.signup = (req, res) ->
  res.render 'signup'

module.exports = userController