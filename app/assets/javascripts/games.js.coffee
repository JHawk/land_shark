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

  current_char = response['json_map']['current_character']
  character_id = current_char['id']
  character_name = current_char['name']
  action_tds = for action in response['json_map']['current_actions']
    "<td>#{action['name']}</td>"

  actions = "<tr><td>Current Character : #{character_name}</td></tr><tr>#{action_tds}</tr>"
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

  rows = for y in [0..max_y]
    tiles = for x in [0..max_x]
      current_character = response['json_map']['current_character']
      coord = "[#{x}, #{y}]"
      visible = drop_z[coord]
      klass = if visible
        # hack
        if visible["charisma"]
          if visible["is_pc"]
            if current_character['x'] == x && current_character['y'] == y
              'current_character'
            else
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

  lm.html("<table>#{actions}</table><table>#{rows}</table>")

  $('.location_map td').click (e) ->
    cell_x = $(this).data('x')
    cell_y = $(this).data('y')
    moveTo(cell_x,cell_y,0,character_id)

