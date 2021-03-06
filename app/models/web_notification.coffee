Model = require 'models/base/model'

module.exports = class WebNotification extends Model

  mediator = Chaplin.mediator
  initialize: ->
    super
    @createWebNotification()

  createWebNotification: (title, content) ->
    @notification = window.webkitNotifications.createNotification "/icon.png", @get('title'), @get('content')
    if @notification
      @notification.show()
      return @notification

  dispose: ->
    @notification.cancel()
    super
