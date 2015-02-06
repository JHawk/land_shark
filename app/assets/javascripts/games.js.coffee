fetchMap = () ->
  $.ajax(
    url: '/games/1'
    data:
      id: 1
    success: onMapSuccess
    dataType: 'json'
    type: "GET"
        )

$(document).ready -> if $('.loaction_map').length > 0
                       fetchMap()
onMapSuccess = (response) ->
  undefined

