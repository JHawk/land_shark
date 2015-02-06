fetchMap = (id) ->
  $.ajax(
    url: "/games/#{id}"
    data:
      id: id
    success: onMapSuccess
    dataType: 'json'
    type: "GET"
        )

$(document).ready -> if $('.location_map').length > 0
                       id = $('.location_map').data('game-id')
                       fetchMap(id)

onMapSuccess = (response) ->
  undefined

