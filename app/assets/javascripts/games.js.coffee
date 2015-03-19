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

$(document).ready -> 
  if $('.location_map').length > 0
    fetchMap()
  else
    selectorStuff()

selectorStuff = () ->
  $('select').change (e) ->
    i = 1

onMapSuccess = (response) ->
  lm = $('.location_map')
  lm.empty()

  recent_moves = response['recent_moves']

  traveled = {}
  if recent_moves
    for position in recent_moves
      traveled[position['end_position']] = position['character_id']

  max_x = response['max_x']
  max_y = response['max_y']

  positionToSprite = {}

  character_id = -1

  drop_z = response['json_map']

  traveled_klass = (traveled, x, y) ->
    if traveled["[#{x},#{y},1]"]
      'traveled'
    else
      'nothing'

  for k,v of drop_z
    coords = for coord in k.split(',')
      parseInt(coord.replace('[', '').replace(']', ''))

    if coords.length > 2
      drop_z["[#{coords[0]}, #{coords[1]}]"] = v

      # hack
      if v["is_pc"]
        character_id = v["id"]
  rows = for y in [0..max_y]
    tiles = for x in [0..max_x]
      visible = drop_z["[#{x}, #{y}]"]
      klass = if visible
        # hack
        if visible["charisma"]
          if visible["is_pc"]
            'character'
          else
            'npc'
        else
          'unwalkable'
      else if Object.keys(traveled).length > 0
        traveled_klass(traveled, x, y)
      else
        'nothing'

      "<td class='#{klass}' data-x='#{x}' data-y='#{y}'></td>"
    "<tr>#{tiles.join('')}</tr>"

  lm.html("<table>#{rows}</table>")

  $('.location_map td').click (e) ->
    cell_x = $(this).data('x')
    cell_y = $(this).data('y')
    moveTo(cell_x,cell_y,0,character_id)

