game = {}

screen = {}

function get_size()
	-- Find all output devices,
	for _, output in ipairs(hw.getInfo()['output']) do
		if output.type == 'lcd' then
			for _, device in ipairs(output) do
				if device.type == 'dotmatrix' then
					return device.w, device.h
				end
			end
		end
	end
end

screen.w, screen.h = get_size()

--[[if not (screen.w and screen.h) then
	screen.w = 64
	screen.h = 64
end]]

function ease(x, targetx, drag, minimum)
	minimum = minimum or 0.001
	local dx = (targetx - x) / drag
	if math.abs(dx) < minimum then
		return targetx
	else
		return x + dx
	end
end

-- Map
map = {}
map.data = {}

map.drawx = 0
map.drawy = 0

function map:set(x, y, tile)
	self.data[math.floor(y % 256) * 256 + math.floor(x % 256)] = tile % 256
end

function map:get(x, y)
	return self.data[math.floor(y % 256) * 256 + math.floor(x % 256)]
end

function map:rect(x, y, w, h, tile)
	for yi = y, y + h - 1 do
		for xi = x, x + w - 1 do
			map:set(xi, yi, tile)
		end
	end
end

map:rect(0, 0, 256, 256, 1)
map:rect(1, 1, 254, 254, 0)

function map:draw(x, y, tx, ty, w, h)
	x = x or 0
	y = y or 0
	tx, ty, w, h = tx or 0, ty or 0, w or 255, h or 255
	local tile, drawx, drawy
	for yi = 0, h - 1 do
		for xi = 0, w - 1 do
			tile = map:get(xi + tx, yi + ty)
			drawx = x + xi * 8
			drawy = y + yi * 8
			if tile == 1 then
				draw.setColor('Green')
				draw.rect(drawx, drawy, 8, 8)
			end
		end
	end
end

--function map:isSolid(()

for i = 0, 5 do
	map:set(i + 1, 5, 1)
end

for _ = 0, 30 do
	local x, y = math.random(0,60), math.random(0,60)
	for i = 0, 5 do
		map:set(x + i + 5, y + 5, 1)
	end
end

player = {
	x = 3, y = 2,
	dx = 0, dy = 0,
}

function sign(n)
	if n > 0 then return  1 end
	if n < 0 then return -1 end
	return 0
end

function player:update()
	map:set(3, 3, 1)
	map:set(3, 4, 1)
	map:set(2, 3, 1)
	player.dy = player.dy + 0.01
	if -- Not really doing much right now
	true
	then
		player.x = player.x + player.dx
	end
	if
	map:get(player.x - 0.5, player.y + player.dy) == 0 and
	map:get(player.x + 0.5, player.y) == 0 and
	map:get(player.x + 0.5, player.y + (player.dy - 1)) == 0 and
	map:get(player.x - 0.5, player.y + (player.dy - 1)) == 0
	then
		player.y = player.y + player.dy
	else
		player.dy = 0
	end
end

function player:draw()
	draw.setColor('Yellow')
	local x, y = screen.w / 2 - camera.x + (player.x * 8), screen.h / 2 - camera.y + (player.y * 8)
	draw.rect(x - 3, y - 10, 6, 10)
	draw.setColor('Red')
end

camera = {
	x = 0, y = 0,
}

function game:init()
end

function game:tick()
	draw.cls()
	draw.setColor('Black')

	player.dx = 0
	if hw.btn('left') then
		player.dx = player.dx - (1 / 8)
	end
	if hw.btn('right') then
		player.dx = player.dx + (1 / 8)
	end
	if hw.btn('up') then
		if map:get(player.x, player.y + 0.3) ~= 0 then
			player.dy = -0.21
		end
	end
	player:update()

	camera.x = ease(camera.x, player.x * 8, 8) - 0.5
	camera.y = ease(camera.y, player.y * 8, 8) - 0.5 --fixme
	map.drawx = camera.x / 8 - screen.w / 16
	map.drawy = camera.y / 8 - screen.h / 16
	map:draw(
		--screen.w / 2 - camera.x + map.drawx * 8, screen.h / 2 - camera.y + map.drawy * 8,
		(-camera.x) % 8 - 8, (-camera.y) % 8 - 8,
		map.drawx, map.drawy,
		screen.w / 8 + 1, screen.h / 8 + 1
	)
	player:draw()
end

function game:event(type, data)
	if type == 'button' and data.down then
		if data.button == 'left' then
		elseif data.button == 'right' then
		elseif data.button == 'up' then
		elseif data.button == 'down' then
		elseif data.button == '1' then
		elseif data.button == '2' then
		elseif data.button == '3' then
		elseif data.button == 'a' then
		elseif data.button == 'b' then
		end
	end
end

return game
