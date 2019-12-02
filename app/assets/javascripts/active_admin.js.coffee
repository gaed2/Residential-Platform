#= require active_admin/base
#= require jquery-ui

$ ->
  $('.autocomplete-filter').each (index, input) ->
    $input = $(input)
    $input
      .autocomplete
        minLength: 3
        delay: 600
        source: (request, response) ->
          $.ajax
            url: $input.data('url')
            dataType: 'json'
            data:
              term: request.term
            success: (data) ->
              response(data)
              $('.ui-helper-hidden-accessible').remove('div')
        focus: (event, ui) ->
          $input.val(Object.values(ui.item)[1])
          $('.ui-menu-item-wrapper').css('background-color', '#fff')
          $('.ui-state-active').css('background-color', '#cdcdcd')
          false
        select: (event, ui) ->
          $input.val(Object.values(ui.item)[1])
          $('.filter_form').submit()
          false
      .data('ui-autocomplete')._renderItem = (ul, item) ->
        $('<li></li>')
          .data('item.autocomplete', item)
          .append('<a>' + Object.values(item)[1] + '</a>')
          .appendTo(ul)
