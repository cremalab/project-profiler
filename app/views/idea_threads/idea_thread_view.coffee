View = require 'views/base/view'
VotesCollection = require 'collections/votes_collection'
IdeasCollection = require 'collections/ideas_collection'
IdeasCollectionView = require 'views/ideas/ideas_collection_view'
VotingRight = require 'models/voting_right'
VotingRights = require 'collections/voting_rights_collection'
VotingRightsView = require 'views/voting_rights/voting_rights_collection_view'
TagListInput = require 'views/form_elements/tag_list_input'
UserSearchCollection = require 'collections/user_search_collection'
DateInputView = require 'views/form_elements/date_input_view'

module.exports = class IdeaThreadView extends View
  template: require './templates/show'
  className: 'ideaThread'
  regions:
    ideas: '.ideas'
    voters: '.voters'
  # listen:
  #   'change:voting_rights model': 'setupVotingRights'
  events:
    'click .archive': 'archive'
    'click .destroy': 'destroyThread'
    'click .submit' : 'save'
    'click .cancel' : 'cancel'
  textBindings: true


  initialize: (options) ->
    super
    @collection_view = options.collection_view
    @ideas           = @model.get('ideas')
    @ideas.thread_id = @model.get('id')
    @listenTo @model, 'change:expiration', @displayExpiration
    @listenTo @model, 'change:id', @dispose

  handleUpdate: (model) ->
    @displayExpiration() if model.changed.expiration
    @render() if model.changed.id
    @render() if model.changed.title

  setOriginal: ->
    @original_idea = @ideas.findWhere
      id: @model.get('original_idea_id')
    @original_idea.set 'original', true

  cancel: (e) ->
    e.preventDefault()
    @model.dispose()

  render: ->
    super
    @$el.find("input[name='title'], input.text-expiration").on 'keydown', (e) =>
      @handleKeyInput(e)

    @modelBinder = new Backbone.ModelBinder()
    @modelBinder.bind @model, @$el
    @setupVotingRights()
    @renderIdeasView()

    @natural_input = new DateInputView
      model: @model
      attr: 'expiration'
      el: @$el.find('.text-expiration')

    @subview 'expiration_input', @natural_input
    @displayExpiration(@model)

  renderIdeasView: ->
    @ideas_view.dispose() if @ideas_view
    @ideas_view = new IdeasCollectionView
      collection: @ideas
      region: 'ideas'
      thread_view: @

  displayExpiration: (model) ->
    if model.get('expiration') is undefined or model.get('expiration') is null
      @$el.find('.date-helper').text('')
    else
      @$el.find('.date-helper').text moment(@model.get('expiration')).format("dddd MMM D, h:mma")

  handleKeyInput: (e) ->
    if e.keyCode is 13
      @model.set('title', @$el.find("input[name='title']").val())
      @model.set('description', @$el.find("textarea[name='description']").val())
      @save()

  setupVotingRights: ->
    @voting_rights = @model.get('voting_rights')
    @all_users = new UserSearchCollection()
    @all_users.fetch()

    @voters_view = new VotingRightsView
      collection: @voting_rights
      region: 'voters'
      idea_thread: @model
    @subview('voters', @voters_view)

    profile_input = new TagListInput
      destination_model: @model
      source_collection: @all_users
      collection: @voting_rights
      label: "Voters"
      attr: "id"
      tag_model: VotingRight
      tag_template: require('./templates/voter')
      existing_only: true
      region: 'voters'
      containerMethod: 'prepend'
    @subview('profile_input', profile_input)


  save: (e) ->
    e.preventDefault() if e
    model = @model
    @model.save @model.attributes,
      success: =>
        title = model.get('title')
        @collection_view.cleanup()
        if model.get('status') is 'archived'
          @publishEvent 'flash_message', "#{title} was archived"
        else
          @publishEvent 'flash_message', "#{title} was saved"

  archive: (e) ->
    e.preventDefault()
    @model.set 'status', 'archived'
    @save()

  destroyThread: (e) ->
    e.preventDefault()
    @model.destroy()