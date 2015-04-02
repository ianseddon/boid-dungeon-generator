require 'class'

-- holds all our rooms
rooms = {}

function love.load ()

end

lastSTime = 0

started = false

function love.update (dt)
	--if( love.keyboard.isDown("up") ) and lastSTime < love.timer.getTime() - 0.2 then
	if love.keyboard.isDown("up") then started = true end
	if started then
		separate()
		
		for i, room in ipairs(rooms) do
			room.x = room.x + room.v.x*100
			room.y = room.y + room.v.y*100
		end
		
		separate()
		
		for i, room in ipairs(rooms) do
			room.x = room.x + room.v.x*100
			room.y = room.y + room.v.y*100
		end
		
		separate()
		
		for i, room in ipairs(rooms) do
			room.x = room.x + room.v.x*100
			room.y = room.y + room.v.y*100
		end
		
		separate()
		
		for i, room in ipairs(rooms) do
			room.x = room.x + room.v.x*100
			room.y = room.y + room.v.y*100
		end
		
		separate()
		
		for i, room in ipairs(rooms) do
			room.x = room.x + room.v.x*100
			room.y = room.y + room.v.y*100
		end
	--	lastSTime = love.timer.getTime()
	end
end

function makeRoom (x,y,w,h)
	room = class:new()
	room.x = x
	room.y = y
	room.w = w
	room.h = h
	room.v = {}
	room.v.x = 0
	room.v.y = 0
	room.nbc = 0
	
	function room:getDistance(other)
		return math.sqrt((self.x - other.x) ^ 2 + (self.y - other.y) ^ 2)
	end
	
	return room
end

numRooms = 150

math.randomseed( os.time() )

scrWidth = love.graphics.getWidth()
scrHeight = love.graphics.getHeight()

minWidth = 40
minHeight = 40
maxWidth = 70
maxHeight = 70
padding = 0

scale = 1

minPosX = scrWidth / 3 / scale
maxPosX = scrWidth / 3 * 2 / scale
minPosY = scrHeight / 3 / scale
maxPosY = scrHeight / 3 * 2 / scale

-- Create numRooms rooms
for i = 1, numRooms do
	v = i * 10
	rooms[i] = makeRoom(math.random(minPosX, maxPosX), math.random(minPosY, maxPosY), math.floor(math.random(minWidth, maxWidth)/10)*10, math.floor(math.random(minHeight, maxHeight)/10)*10)
end

function separate()
	for i, room in ipairs(rooms) do
		mean = {}
		mean.x = 0
		mean.y = 0
		count = 0
		room.neighbours = {}
		
		for j, other in ipairs(rooms) do
			if other ~= room then
				distX = math.abs(room.x - other.x)
				distY = math.abs(room.y - other.y)
				sepX = room.w/2 + other.w/2 + padding
				sepY = room.h/2 + other.h/2 + padding
				if (distX > 0 and distY > 0) and (distX < sepX and distY < sepY) then
					dist = math.sqrt(((room.x - other.x)*(room.x - other.x) + ((room.y - other.y)*(room.y - other.y))))
					mag = math.sqrt(((room.x - other.x)*(room.x - other.x)) + ((room.y - other.y)*(room.y - other.y)))
					mean.x = mean.x + ((room.x - other.x)/mag/dist)
					mean.y = mean.y + ((room.y - other.y)/mag/dist)
					room.neighbours[count] = other
					count = count + 1
				end
			end
		end
		
		if count > 0 then
			mean.x = mean.x / count
			mean.y = mean.y / count
		end
		room.v.x = mean.x
		room.v.y = mean.y
	end
end

function love.draw ()
	c = 0
	for i, room in ipairs(rooms) do
		
		drawX = scale * (room.x - (room.w/2))
		drawY = scale * (room.y - (room.h/2))
		drawW = scale * room.w
		drawH = scale * room.h
		gridSize = 10
		
		if (drawX + drawW > 0 and drawX < scrWidth) and (drawY + drawH > 0 and drawY < scrHeight) then
			love.graphics.setColor(255, 255, 255,50)
			for x = 0, drawW, gridSize*scale do
				love.graphics.line(drawX + x, drawY, drawX + x, drawY + drawH)
			end
			for y = 0, drawH, gridSize*scale do
				love.graphics.line(drawX, drawY + y, drawX + drawW, drawY + y)
			end
			love.graphics.setColor(255, 255, 255, 80)
			love.graphics.rectangle("line", drawX, drawY, drawW, drawH )
			love.graphics.setColor(255,255,0,70)
			love.graphics.line(drawX + drawW/2, drawY + drawH/2, drawX + drawW/2 + room.v.x*500, drawY + drawH/2 + room.v.y*500)
			if room.neighbours then
				for j, neigh in ipairs(room.neighbours) do
					love.graphics.setColor( 0, 255, 255, 80 )
					love.graphics.line(drawX + drawW, drawY + drawH, neigh.x*scale, neigh.y*scale)
				end
			end
		end
		c = c + 1
	end
	love.graphics.setColor(5, 5, 5, 100)
	love.graphics.rectangle( "fill", 5, 5, 100, 50 )
	love.graphics.setColor(255,255,255)
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
	love.graphics.print("Rooms: "..c, 10, 25)
end