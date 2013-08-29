CollectionView = require 'views/base/collection-view'
Idea = require 'models/idea'
IdeaView = require 'views/ideas/idea_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
template = require './templates/collection'

module.exports = class IdeasCollectionView extends CollectionView

  template: template
  listSelector: '.collection-items'
  animationDuration: 0
  events:
    'click .add': 'newIdea'
  key_bindings:
    'n': 'newIdea'
    'esc': 'escapeForm'

  initialize: ->
    super
    @subscribeEvent 'saved_idea', @updateModel

  newIdea: (e) ->
    if @new_idea
      new_idea_view = @viewForModel(@new_idea)
      new_idea_view.$el.find('input:visible:first').focus()
    else
      @new_idea = new Idea()
      @collection.add @new_idea

  escapeForm: (idea) ->
    if idea and idea.isNew()
      @collection.remove(idea)
      @new_idea = null

  initItemView: (model) ->
    if model.isNew()
      view = new IdeaEditView model: model, collection_view: @
    else
      view = new IdeaView model: model, collection_view: @, autoRender: true
    view

  updateModel: (model) ->
    model_in_collection = @collection.find(model)
    @removeViewForItem(model_in_collection)
    view = @insertView(model, @initItemView(model))
    @new_idea = null
    @setupKeyBindings()