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
  lm = $('.location_map')
  lm.empty()

  max_x = 100
  max_y = 100

  positionToSprite = {}

  for sprite in response['json_map']
    positionToSprite["#{sprite['x']}.#{sprite['y']}"] = sprite

  rows = for y in [0..100]
    row =
    tiles = row = for x in [0..100]
      klass = if positionToSprite["#{x}.#{y}"]
        'present'
      else
        'nothing'
      "<td class='#{klass}'></td>"
    "<tr>#{tiles.join('')}</tr>"

  lm.html("<table>#{rows}</table>")
