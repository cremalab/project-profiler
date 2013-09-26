CollectionView = require 'views/base/collection-view'
VotingRight = require 'models/voting_right'
VotingRightView = require 'views/voting_rights/voting_right_view'
template = require './templates/collection'

module.exports = class VotingRightsCollectionView extends CollectionView
  animationDuration: 0
  useCssAnimation: true
  animationStartClass: 'collection-animation'
  animationEndClass: 'collection-animation-end'
  itemView: VotingRightView
  template: template
  listSelector: '.voting-rights'
  listen:
    'add collection': 'setThreadID'
    'add collection': 'updateGroupUI'
    'remove collection': 'updateGroupUI'
  events:
    'click .save-group': 'promptForGroupName'
    'submit .group-form': 'saveGroup'

  initialize: (options) ->
    super
    @idea_thread = options.idea_thread
    @subscribeEvent 'saved_group', @handleGroupSave

  render: ->
    super
    @$group_form = @$el.find('.group-form')
    @$group_form.hide()
    @updateGroupUI()

  initItemView: (model) ->
    new VotingRightView model: model, collection_view: @, idea_thread: @idea_thread

  setThreadID: (voting_right,b,c) ->
    unless @idea_thread.isNew()
      voting_right.set 'idea_thread_id', @idea_thread.get('id')
      voting_right.save()

  promptForGroupName: (e) ->
    e.preventDefault()
    @$group_form.show()

  saveGroup: (e) ->
    e.preventDefault()
    e.stopPropagation()
    name = @$group_form.find('.group-name').val()
    @collection.saveAsGroup(name)

  handleGroupSave: (model) ->
    @$group_form.find('input').val()
    @$group_form.hide()

  updateGroupUI: ->
    $save_link = @$el.find('.save-group')
    if @collection.length > 1
      $save_link.show()
    else
      $save_link.hide()
