SessionsController = require 'controllers/sessions_controller'
User = require 'models/user'
Notifier = require 'models/notifier'

# The application object.
module.exports = class Application extends Chaplin.Application
  initMediator: ->
    # Create a user property
    Chaplin.mediator.user = new User()
    Chaplin.mediator.apiURL = (path) ->
      if window.location.host.indexOf('localhost') == -1
        "http://cremalab-ideas-api.herokuapp.com#{path}"
      else
        "http://localhost:3000#{path}"
    Chaplin.mediator.sessions_controller = new SessionsController()
    Chaplin.mediator.notifier = new Notifier()
    super
