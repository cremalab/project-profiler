Controller = require 'controllers/base/controller'
Group      = require 'models/group'
Groups     = require 'collections/groups_collection'
GroupsView = require 'views/groups/groups_collection_view'

module.exports = class GroupsController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_group', @update

  update: (model) ->
    model.save model.attributes,
      success: (model, response) =>
        @publishEvent 'saved_group', model
      error: (model, response) =>
        @publishEvent 'renderError', response

  index: (params) ->
    @collection = new Groups()
    @view       = new GroupsView region: 'main', collection: @collection
    @collection.fetch()