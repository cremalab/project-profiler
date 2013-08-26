template = require './templates/form'
View = require 'views/base/form_view'
DateInputView = require 'views/form_elements/date_input_view'

module.exports = class RegistrationView extends View
  autoRender: true
  className: 'registreationNew'
  tagName: 'form'
  template: template
  events:
    "submit": 'save'

  save: (e) ->
    e.preventDefault()
    @model.save()