Controller = require 'controllers/base/controller'
Idea = require 'models/idea'
IdeaThread = require 'models/idea_thread'
IdeaThreads = require 'collections/idea_threads_collection'
IdeaThreadsCollectionView = require 'views/idea_threads/idea_threads_collection_view'
IdeaEditView = require 'views/ideas/idea_edit_view'

module.exports = class IdeaThreadsController extends Controller

  initialize: ->
    super
    @subscribeEvent 'save_idea', @update
    @subscribeEvent 'save_idea_thread', @update

  edit: (params) ->
    @model = new Idea
      id: params.id
    @model.fetch()

    @view = new IdeaEditView
      model: @model
      region: 'main'

  index: ->
    @collection = new IdeaThreads()
    @collection.fetch()
    @view = new IdeaThreadsCollectionView collection: @collection, region: 'main'

  update: (model, ideas_collection, ideas_collection_view, attrs) ->
    console.log 'save'
    model.save attrs,
      success: (model) =>
        # console.log "SAVED"
        # if model.get('ideas')
        #   ideas_collection.set(model.get('ideas').models)
        #   ideas_collection_view.updateModel(model)
        # else
        #   ideas_collection_view.updateModel(model)

      error: (model, response) =>
        console.log 'NNNNNOOOOO'
        console.log $.parseJSON(response.responseText)
        @publishEvent 'renderError', response