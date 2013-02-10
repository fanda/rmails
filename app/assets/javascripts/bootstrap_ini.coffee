#= require twitter/bootstrap-button
#= require twitter/bootstrap-dropdown
#= require twitter/bootstrap-tab
$(document).ready ->
  $('.dropdown-toggle').dropdown()
  $('.nav-tabs a').click( (e) ->
    e.preventDefault()
    $(this).tab('show')
  )
  $('.nav-tabs a:first').tab('show')

