class EntitiesListForm
  constructor: ->
    $('body').on 'modal:load', (event) =>
      @setup() if $("#modal_container .js-entities_list-form").length == 1

  setup: ->
    if $('.field_with_errors input').length == 0
      App.FocusInput.atEnd('#entities_list_listname')
    else
      App.FocusInput.atEnd('.field_with_errors input')

Setup = ->
  if $('body').data('controller-name') == "entities_lists"
    new EntitiesListForm()

$(document).on('turbolinks:load', Setup)
