
local basedir = 'vpet/'

local buttondir = basedir .. 'buttons/'

local main_screen = {
	w = 128,
	h = 128,
}

local hw = {
	info = {
		name = 'Action PET',
		version = {0, 0, 1},
	},
	base = {
		image = 'w27rotten_shell.png',
		x = -math.floor(168 / 2),
		y = -math.floor(96 / 2),
		w = 168,
		h = 96,
		minw = 152,
		minh = 88,
		defaultscale = 2,
	},
	output = {},
	input = {
		buttons = {
			['1'] = {
				x = -24,
				y = 36,
				w = 20,
				h = 8,
			},
			['2'] = {
				x = 0,
				y = 36,
				w = 20,
				h = 8,
			},
			['3'] = {
				x = 24,
				y = 36,
				w = 20,
				h = 8,
			},
			['back'] = {
				x = -48,
				y = -30,
				w = 12,
				h = 12,
			},
			['home'] = {
				x = 48,
				y = -30,
				w = 12,
				h = 12,
			},
			['left'] = {
				x = -60 - 8,
				y = 10,
				w = 8,
				h = 8,
			},
			['right'] = {
				x = -60 + 8,
				y = 10,
				w = 8,
				h = 8,
			},
			['up'] = {
				x = -60,
				y = 10 - 8,
				w = 8,
				h = 8,
			},
			['down'] = {
				x = -60,
				y = 10 + 8,
				w = 8,
				h = 8,
			},
			['a'] = {
				x = 68,
				y = 14,
				w = 14,
				h = 14,
			},
			['b'] = {
				x = 52,
				y = 6,
				w = 14,
				h = 14,
			},
		},
	},
}

local api = inherithw(hwdir .. 'base.lua')

local lcd = api.newDotMatrixLCD(0, -6, main_screen.w, main_screen.h, 4)

lcd.vram.font = 'font.png'

lcd.scale = 1

-- VV8 color
lcd.bgcolor = {0xff, 0xff, 0xee}

lcd.ghosting = 0xaa

lcd.colors = {}

for r = 0, 1 do
	for g = 0, 1 do
		for b = 0, 1 do
			lcd.colors[7 - (r * 4 + g * 2 + b)] = {
				0x11 + r * 0x77 + g * 0x66 + b * 0x44,
				0x11 + r * 0x33 + g * 0x77 + b * 0x33,
				0x11 + r * 0x22 + g * 0x33 + b * 0x77,
			}
		end
	end
end

for index, color in pairs(lcd.colors) do
	for channel, value in pairs(color) do
		if value > 0xff then
			color[channel] = 0xff
			--print(index, channel, value)
		end
	end
end

lcd.colornames = {
	White = 0,
	Yellow = 1,
	Pink = 2, Magenta = 2,
	Red = 3,
	Grey = 4, Gray = 4,
	Green = 5,
	Blue = 6,
	Black = 7,
}

table.insert(hw.output, lcd)

table.insert(hw.output, {
	-- the led unit is a simple light that can be on or off
	type = 'led',
	x = -40,
	y = -18,
	w = 4,
	h = 4,
	image_on = basedir .. 'led_on.png',
	image_off = basedir .. 'led_off.png',
})

--[[
for k,v in pairs(hw.input.buttons) do
	v.image_up = basedir .. k .. '_button.png'
	v.image_down = basedir .. k .. '_button_pressed.png'
end
--]]

api.vpetInsertButtonImages(hw, buttondir, {labels = true})

for _, v in ipairs({'left', 'right', 'up', 'down'}) do
	hw.input.buttons[v].image_up = nil
	hw.input.buttons[v].image_down = nil
end

return hw
