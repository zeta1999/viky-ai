import Vue from 'vue/dist/vue.esm'
moment = require('moment');

class ConsoleTestSuite
  constructor: ->
    if $('.console-container').length == 1
      unless App.ConsoleTestSuite

        App.ConsoleTestSuite = new Vue({
          el: '#console-ts',
          data: test_suite_data,
          components: {
            testDetail: {
              props:{
                expected: Object,
                got: Object
              },
              template:'<code class="language-javascript" v-html="testData"></code>',
              computed: {
                testData: () ->
                  expected = Prism.highlight(JSON.stringify(this.expected, null, 2), Prism.languages.javascript, 'javascript')
                  got = Prism.highlight(JSON.stringify(this.got, null, 2), Prism.languages.javascript, 'javascript')
                  return expected + '<br>' + got
              }
            }
          }
          methods: {
            showDetails: (testId) ->
              $("#cts-item-details-#{testId}").show()
              $("#cts-item-summary-#{testId}").hide()

            hideDetails: (testId) ->
              $("#cts-item-details-#{testId}").hide()
              $("#cts-item-summary-#{testId}").show()

            showRemoveConfirm: (event) ->
              itemDetail = $(event.target).parents('.cts-item')
              itemDetail.addClass('cts-item--behind')
              itemDetail.next('.cts-item-delete').show()

            removeTest: (index, event) ->
              csrfToken = $('meta[name="csrf-token"]').attr('content')
              deleteUrl = this.tests[index].delete_url
              $.ajax
                url: deleteUrl,
                method: "DELETE",
                headers: { "X-CSRF-TOKEN": csrfToken }
                error: (data) -> App.Message.alert(data.responseText)

            cancelRemove: (event) ->
              confirmBlock = $(event.target).parents('.cts-item-delete')
              confirmBlock.hide()
              confirmBlock.siblings('div.cts-item').removeClass('cts-item--behind')

            updateTest: (index, event) ->
              regressionCheck = this.tests[index]
              $('.panels-switch__panel').last()
                .addClass('panels-switch__panel--hide')
                .removeClass('panels-switch__panel--show')
              $("body").trigger('console-submit-form', {sentence: regressionCheck.sentence, language: regressionCheck.language, now: regressionCheck.now})
          },

        })
    else
      App.ConsoleTestSuite = null


Setup = -> new ConsoleTestSuite()

$(document).on('turbolinks:load', Setup)
