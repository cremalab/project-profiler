CollectionView = require 'views/base/collection-view'
Idea = require 'models/idea'
IdeaView = require 'views/ideas/idea_view'
IdeaEditView = require 'views/ideas/idea_edit_view'
template = require './templates/collection'

module.exports = class IdeasCollectionView extends CollectionView

  template: template
  listSelector: '.collectionItems'
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  events:
    'click .add': 'newIdea'
  key_bindings:
    'esc': 'escapeForm'
  listen:
    'change collection': 'resort'

  initialize: (options) ->
    super
    @thread_view = options.thread_view
    @subscribeEvent 'saved_idea', @updateModel
    @subscribeEvent 'edit_idea', @editIdea

  newIdea: (e) ->
    if @new_idea
      new_idea_view = @viewForModel(@new_idea)
      new_idea_view.$el.find('input:visible:first').focus()
    else
      @new_idea = new Idea
        user_id: Chaplin.mediator.user.get('id')
      votes = @new_idea.get('votes')
      votes.add
        user_id: Chaplin.mediator.user.get('id')
      @collection.add @new_idea, at: 0

  editIdea: (model) ->
    @removeViewForItem(model)
    view = new IdeaEditView model: model, collection_view: @
    @insertView(model, view)
    @new_idea = model

  escapeForm: (idea) ->
    if idea
      if idea.isNew()
        @collection.remove(idea)
        @new_idea = null
      else
        @updateModel(idea)

  initItemView: (model) ->
    if model.isNew()
      view = new IdeaEditView model: model, collection_view: @
    else
      view = new IdeaView model: model, collection_view: @, autoRender: true
    view

  save: (model) ->
    if @thread_view.model.isNew()
      @thread_view.save()
    else
      @publishEvent 'save_idea', @model

  updateModel: (model) ->
    model_in_collection = @collection.find(model)
    @removeViewForItem(model_in_collection)
    view = @insertView(model, @initItemView(model))
    @new_idea = null
    @setupKeyBindings()

  resort: ->
    @collection.sort()
