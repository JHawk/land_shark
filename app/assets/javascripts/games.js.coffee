fetchMap = () ->
  id = game_id()
  $.ajax(
    url: "/games/#{id}"
    data:
      id: id
    success: onMapSuccess
    dataType: 'json'
    type: "GET"
        )

moveTo = (x,y,z,character_id) ->
  id = game_id()
  $.ajax(
    url: "/games/#{id}"
    data:
      game_action: 'move'
      character_id: character_id
      id: id
      x: x
      y: y
      z: z
    success: onMapSuccess
    dataType: 'json'
    type: "PUT"
  )

game_id = () ->
  $('.location_map').data('game-id')

$(document).ready -> if $('.location_map').length > 0
                       fetchMap()

onMapSuccess = (response) ->
  lm = $('.location_map')
  lm.empty()

  max_x = response['max_x']
  max_y = response['max_y']

  positionToSprite = {}

  character_id = -1

  for sprite in response['json_map']
    positionToSprite["#{sprite['x']}.#{sprite['y']}"] = sprite
    character_id = sprite['id']

  rows = for y in [0..max_y]
    tiles = for x in [0..max_x]
      klass = if positionToSprite["#{x}.#{y}"]
        'present'
      else
        'nothing'

      "<td class='#{klass}' data-x='#{x}' data-y='#{y}'></td>"
    "<tr>#{tiles.join('')}</tr>"

  lm.html("<table>#{rows}</table>")

  $('.location_map td').click (e) ->
    cell_x = $(this).data('x')
    cell_y = $(this).data('y')
    moveTo(cell_x,cell_y,0,character_id)

