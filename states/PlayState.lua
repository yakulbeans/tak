PlayState = Class{__includes = BaseState}

function PlayState:init()
	resetBoard()
end

function resetBoard()
	board = Board()
	grid = {}
	mouseXGrid = 0
	mouseYGrid = 0
	player = 1
	player1stones = 21
	player1capstone = 1
	player2capstone = 1
	player2stones = 21
	stoneSelect = 1
	movementEvent = 1
	toggleMouseStone = false
	hideMouseStone = false
	movementOriginLocked = false
	movementOriginRow = nil
	movementOriginColumn = nil
	stonesInHandLocked = false
	firstMovementGridLocked = false
	firstMovementStonesDropped = false
	secondMovementStonesDropped = false
	downDirection = false
	upDirection = false
	leftDirection = false
	rightDirection = false
	droppedInMovementOrigin = 0
	droppedInFirstMovement = 0
	droppedInSecondMovement = 0
	stonesToCopy = 0
	lowestMSStackOrder = 1
	moveType = 'place'
	moveLockedRow = 0
	moveLockedColumn = 0
	mouseStones = Occupant()
	mouseStones.members = {}
	mouseStones.occupants = 0
	PUIndex = 0

	--POPULATES GRID TABLE WITH PROPER GRID X AND Y FIELDS AND OCCUPANT OBJECTS
	for i = 1, 5 do
		grid[i] = {}
		for j = 1, 5 do --first bracket is row, second bracket is column
			grid[i][j] = {}
			grid[i][j] = Occupant()
			grid[i][j].x = j * 144 - 144
			grid[i][j].y = i * 144 - 144
			for k = 1, 10 do --GIVES US MEMORY FOR 10 MEMBER OBJECTS IN EACH OCCUPANT INSTANCE
				grid[i][j].members[k] = Member(nil, nil, grid[i][j].x, grid[i][j].y)
				mouseStones.members[k] = Member()
			end
		end
	end

---[[10-STACK TESTER
	grid[3][3].members[1].stoneColor = 'WHITE'
	grid[3][3].members[1].stoneType = 'LS'
	grid[3][3].occupied = true
	grid[3][3].stackControl = 'WHITE'
	grid[3][3].members[1].stackOrder = 1

	grid[3][3].members[2].stoneColor = 'BLACK'
	grid[3][3].members[2].stoneType = 'LS'
	grid[3][3].stackControl = 'BLACK'
	grid[3][3].members[2].stackOrder = 2

	grid[3][3].members[3].stoneColor = 'WHITE'
	grid[3][3].members[3].stoneType = 'LS'
	grid[3][3].stackControl = 'WHITE'
	grid[3][3].members[3].stackOrder = 3

	grid[3][3].members[4].stoneColor = 'BLACK'
	grid[3][3].members[4].stoneType = 'LS'
	grid[3][3].stackControl = 'BLACK'
	grid[3][3].members[4].stackOrder = 4
	grid[3][3].occupants = 4

---[[
	grid[3][3].members[5].stoneColor = 'WHITE'
	grid[3][3].members[5].stoneType = 'LS'
	grid[3][3].stackControl = 'WHITE'
	grid[3][3].members[5].stackOrder = 5
	grid[3][3].occupants = 5

	grid[3][3].members[6].stoneColor = 'BLACK'
	grid[3][3].members[6].stoneType = 'LS'
	grid[3][3].stackControl = 'BLACK'
	grid[3][3].members[6].stackOrder = 6

	grid[3][3].members[7].stoneColor = 'WHITE'
	grid[3][3].members[7].stoneType = 'LS'
	grid[3][3].stackControl = 'WHITE'
	grid[3][3].members[7].stackOrder = 7

	grid[3][3].members[8].stoneColor = 'BLACK'
	grid[3][3].members[8].stoneType = 'LS'
	grid[3][3].stackControl = 'BLACK'
	grid[3][3].members[8].stackOrder = 8

	grid[3][3].members[9].stoneColor = 'WHITE'
	grid[3][3].members[9].stoneType = 'LS'
	grid[3][3].stackControl = 'WHITE'
	grid[3][3].stoneControl = 'LS'
	grid[3][3].members[9].stackOrder = 9
	grid[3][3].occupants = 9




	grid[3][3].members[10].stoneColor = 'BLACK'
	grid[3][3].members[10].stoneType = 'LS'
	grid[3][3].stackControl = 'BLACK'
	grid[3][3].members[10].stackOrder =10

	grid[3][3].occupants = 10
--]]

--[[3-STACK TESTER
	grid[3][3].members[1].stoneColor = 'WHITE'
	grid[3][3].members[1].stoneType = 'LS'
	grid[3][3].occupied = true
	--grid[3][3].stackControl = 'WHITE'
	grid[3][3].members[1].stackOrder = 1

	grid[3][3].members[2].stoneColor = 'BLACK'
	grid[3][3].members[2].stoneType = 'LS'
	--grid[3][3].stackControl = 'BLACK'
	grid[3][3].members[2].stackOrder = 2

	grid[3][3].members[3].stoneColor = 'WHITE'
	grid[3][3].members[3].stoneType = 'LS'
	grid[3][3].stackControl = 'WHITE'
	grid[3][3].members[3].stackOrder = 3

	grid[3][3].occupants = 3

	--updateStoneControl(grid[3][3])
--]]
end

function updateStackControl(Occupant)
	for i = 10, 1, -1 do
		if Occupant.members[i].stoneColor ~= nil then
			Occupant.stackControl = Occupant.members[i].stoneColor
			break
		end
	end
end

function updateStoneControl(Occupant)
	for i = 10, 1, -1 do
		if Occupant.members[i].stoneType ~= nil then
			Occupant.stoneControl = Occupant.members[i].stoneType
			break
		end
	end
end

function falsifyAllOccupantsLegalMove()
	for i = 1, 5 do
		for j = 1, 5 do
			grid[i][j].legalMove = false
		end
	end
end

function playerSwapGridReset()
	player = player == 1 and 2 or 1
	falsifyAllOccupantsLegalMove()
	for i = 1, 5 do
		for j = 1, 5 do
			grid[i][j].moveLockedHighlight = false
		end
	end

	movementEvent = 1
	lowestMSStackOrder = 1
	moveLockedRow = 0
	moveLockedColumn = 0
	movementOriginLocked = false
	movementOriginRow = nil
	movementOriginColumn = nil
	droppedInMovementOrigin = 0
	stonesInHandLocked = false
	firstMovementGridLocked = false
	droppedInFirstMovement = 0
	stonesToCopy = 0
	firstMovementStonesDropped = false
	downDirection = false
	upDirection = false
	leftDirection = false
	rightDirection = false
end


function PlayState:update(dt)
---[[MOUSE POSITION VARIABLES
	mouseMasterX, mouseMasterY = love.mouse.getPosition()
	mouseX, mouseY = love.mouse.getPosition()
	--SHIFTS MOUSE_X AND MOUSE_Y TO GRID COORDINATES RATHER THAN SCREEN COORDINATES
	mouseY = mouseY - Y_OFFSET
	mouseX = mouseX - X_OFFSET

	--[NILLIFY THE MOUSE COORDINATES IF OFF GRID
	if mouseY < 0 or mouseY > 720 or mouseX < X_OFFSET or mouseX > 720 then --COMMENT OUT TO EASE DEBUG CRASH
		--mouseY = nil
		--mouseX = nil
	end
--]]

---[[ASSIGNS SELECTION LIMIT FOR PLAYERS
	if player1capstone == 1 then
		p1SelectLimit = 3
	else
		p1SelectLimit = 2
	end

	if player2capstone == 1 then
		p2SelectLimit = 3
	else
		p2SelectLimit = 2
	end
--]]

---[[GRID RESET
	if love.keyboard.wasPressed('r') then
		resetBoard()
	end
--]]

---[[TOGGLE MOUSE STONE
	if love.keyboard.wasPressed('e') then
		toggleMouseStone = toggleMouseStone == false and true or false
	end
--]]


---[[STONE SELECT
	if moveType == 'place' then
	
		--mouseStones.occupants = 1

		if player == 1 then
			if love.keyboard.wasPressed('right') then
				sounds['beep']:play()
				if stoneSelect < p1SelectLimit then
					stoneSelect = stoneSelect + 1
				elseif stoneSelect == p1SelectLimit then
					stoneSelect = 1
				end
			end

			if love.keyboard.wasPressed('left') then
				sounds['beep']:play()
				if stoneSelect > 1 then
					stoneSelect = stoneSelect - 1
				elseif stoneSelect == 1 then
					stoneSelect = p1SelectLimit
				end
			end

		elseif player == 2 then
			if love.keyboard.wasPressed('right') then
				sounds['beep']:play()
				if stoneSelect < p2SelectLimit then
					stoneSelect = stoneSelect + 1
				elseif stoneSelect == p2SelectLimit then
					stoneSelect = 1
				end
			end

			if love.keyboard.wasPressed('left') then
				sounds['beep']:play()
				if stoneSelect > 1 then
					stoneSelect = stoneSelect - 1
				elseif stoneSelect == 1 then
					stoneSelect = p2SelectLimit
				end
			end
		end
	end
--]]

---[[POPULATES MOUSE GRID WITH CURSOR LOCATION
	--Math to find which Row mouse is in
	if mouseY ~= nil then
		if mouseY / 144 < 1 then
			mouseYGrid = 1
		elseif mouseY / 144 < 2 then
			mouseYGrid = 2
		elseif mouseY / 144 < 3 then
			mouseYGrid = 3
		elseif mouseY / 144 < 4 then
			mouseYGrid = 4
		elseif mouseY / 144 < 5 then
			mouseYGrid = 5
		end
	else
		mouseYGrid = nil
	end	

	--Math to find which Column mouse is in
	if mouseX ~= nil then
		if mouseX / 144 < 1 then
			mouseXGrid = 1
		elseif mouseX / 144 < 2 then
			mouseXGrid = 2
		elseif mouseX / 144 < 3 then
			mouseXGrid = 3
		elseif mouseX / 144 < 4 then
			mouseXGrid = 4
		elseif mouseX / 144 < 5 then
			mouseXGrid = 5
		end
	else
		mouseXGrid = nil
	end

	for i = 1, 5 do
		for j = 1, 5 do --UPDATES OCCUPANTS LEGALMOVE HIGHLIGHT BASED ON LEGAL MOVE STATUS
			grid[i][j]:update(dt)
		end
	end
--]]

---[[SWAP MOVETYPES
	if moveType == 'place' then
		if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
			sounds['beep']:play()
			moveType = 'move'
		end
	elseif moveType == 'move'  and movementEvent == 1 then
		if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
			sounds['beep']:play()
			moveType = 'place'
		end
	end
--]]

---[PLACING A STONE IN EMPTY SPOT
	function love.mousepressed(x, y, button)
		if button == 1 and mouseXGrid ~= nil and mouseYGrid ~= nil then --ENSURES WE CLICKED WITHIN GRID
			if moveType == 'place' then
				if not grid[mouseYGrid][mouseXGrid].occupied then --ENSURES STONE CANNOT BE PLACE IN OCCUPIED GRID
					sounds['stone']:play()
					grid[mouseYGrid][mouseXGrid].occupied = true
					grid[mouseYGrid][mouseXGrid].occupants = 1
					grid[mouseYGrid][mouseXGrid].members[1].stackOrder = 1

					if stoneSelect == 1 then --LAYSTONE PLACEMENT
						grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'LS'
						if player == 1 then
							player1stones = player1stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].stackControl = 'WHITE'
						elseif player == 2 then
							player2stones = player2stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].stackControl = 'BLACK'
						end
					elseif stoneSelect == 2 then --STANDING STONE PLACEMENT
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'SS'
						if player == 1 then
							player1stones = player1stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].stackControl = 'WHITE'
						elseif player == 2 then
							player2stones = player2stones - 1
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].stackControl = 'BLACK'
						end
					elseif stoneSelect == 3 then --CAPSTONE PLACEMENT
							grid[mouseYGrid][mouseXGrid].members[1].stoneType = 'CS'
						if player == 1 then
							player1capstone = 0
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'WHITE'
							grid[mouseYGrid][mouseXGrid].stackControl = 'WHITE' 
						elseif player == 2 then
							player2capstone = 0
							grid[mouseYGrid][mouseXGrid].members[1].stoneColor = 'BLACK'
							grid[mouseYGrid][mouseXGrid].stackControl = 'BLACK'
						end
					end
					--SWAPS PLAYER AFTER SELECTION
					player = player == 1 and 2 or 1
					stoneSelect = 1
					updateStoneControl(grid[mouseYGrid][mouseXGrid])
				end
			end
		end
	end
--]]

	
---[[
	if moveType == 'move' then
	---[[MOUSE STONES POSITION
		for i = 1, 10 do
			mouseStones.members[i].x = mouseMasterX - X_OFFSET - OUTLINE - 60
			mouseStones.members[i].y = mouseMasterY - Y_OFFSET - OUTLINE - 60
		end
	--]]

		if movementEvent == 1 then 
		---[[LEGAL MOVE HIGHLIGHTS
			for i = 1, 5 do
				for j = 1, 5 do
					if player == 1 then --SET LEGAL MOVES UPON STACKCONTROL
						if grid[i][j].stackControl == 'WHITE' then
							grid[i][j].legalMove = true
						--RENDER LEGALMOVEHIGHLIGHTS UPON MOUSEOVER
						if mouseYGrid == i and mouseXGrid == j and grid[mouseYGrid][mouseXGrid].stackControl == 'WHITE' then
							grid[i][j].legalMoveHighlight = true
						else
							grid[i][j].legalMoveHighlight = false
						end
					end
					elseif player == 2 then --SET LEGAL MOVES UPON STACKCONTROL
						if grid[i][j].stackControl == 'BLACK' then
							grid[i][j].legalMove = true
						end
						--RENDER LEGALMOVEHIGHLIGHTS UPON MOUSEOVER
						if mouseYGrid == i and mouseXGrid == j and grid[mouseYGrid][mouseXGrid].stackControl == 'BLACK' then
							grid[i][j].legalMoveHighlight = true
						else
							grid[i][j].legalMoveHighlight = false
						end
					end
				end
			end
		--]]

		---[[LOCK IN MOVEMENT ORIGIN GRID
			function love.mousepressed(x, y, button)
				if button == 1 then
					if grid[mouseYGrid][mouseXGrid].legalMove then
						grid[mouseYGrid][mouseXGrid].legalMove = false
						movementOriginRow = mouseXGrid
						movementOriginColumn = mouseYGrid
					end

					if grid[mouseYGrid][mouseXGrid].occupants >= 5 then
						stonesToCopy = 5
					else
						stonesToCopy = grid[mouseYGrid][mouseXGrid].occupants
					end

					for i = 1, stonesToCopy do --COPY OVER <5 STONES
						mouseStones.members[grid[mouseYGrid][mouseXGrid].occupants].stoneColor = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneColor
						mouseStones.members[grid[mouseYGrid][mouseXGrid].occupants].stoneType = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneType
						mouseStones.members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder = grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder

						grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneColor = nil
						grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stoneType = nil
						grid[mouseYGrid][mouseXGrid].members[grid[mouseYGrid][mouseXGrid].occupants].stackOrder = nil

						mouseStones.occupants = mouseStones.occupants + 1
						grid[mouseYGrid][mouseXGrid].occupants = grid[mouseYGrid][mouseXGrid].occupants - 1
					end

					updateStoneControl(grid[mouseYGrid][mouseXGrid])
					updateStackControl(grid[mouseYGrid][mouseXGrid])
					movementEvent = 2
				end
			end
		--]]
		end

		elseif movementEvent == 2 then

		elseif movementEvent == 3 then

		elseif movementEvent == 4 then

		elseif movementEvent == 5 then

		elseif movementEvent == 6 then

		elseif movementEvent == 7 then
	end
	--]]


---[[MOVEMENT ORIGIN HIGHLIGHT
	if movementOriginRow ~= nil and movementOriginColumn ~= nil then
		grid[movementOriginRow][movementOriginColumn].legalMoveHighlight = true
	end
	
--]]
---[[LEGAL MOVES HIGHLIGHTS
	for i = 1, 5 do
		for j = 1, 5 do
			if moveType == 'place' then
				if mouseXGrid == j and mouseYGrid == i then --SELECTIONHIGHLIGHT IF OVER MOUSE LOCATION
					grid[i][j].selectionHighlight = true
				else
					grid[i][j].selectionHighlight = false
				end
			end
		end
	end



end



-------------------------------------OLD CODE OLD CODE OLD CODE


--[[FIRST MOVETYPE OLDCODE
			if moveType == 'move' then --PICKING UP STONES FROM MOVEMENT ORIGIN
				if grid[mouseYGrid][mouseXGrid].legalMove and grid[mouseYGrid][mouseXGrid].occupants < 6 and not movementOriginLocked then
					movementOriginRow = mouseYGrid
					movementOriginColumn = mouseXGrid
					--MOVE ALL 5 occupants to mouse positions
					for i = 1, grid[mouseYGrid][mouseXGrid].occupants do
						mouseStones.occupants = mouseStones.occupants + 1
						mouseStones.members[i].stoneColor = grid[mouseYGrid][mouseXGrid].members[i].stoneColor
						mouseStones.members[i].stoneType = grid[mouseYGrid][mouseXGrid].members[i].stoneType
						mouseStones.members[i].stackOrder = grid[mouseYGrid][mouseXGrid].members[i].stackOrder
						mouseStones.members[i].originalStackOrder = grid[mouseYGrid][mouseXGrid].members[i].stackOrder
						grid[mouseYGrid][mouseXGrid].members[i].stoneColor = nil
						grid[mouseYGrid][mouseXGrid].members[i].stoneType = nil
						grid[mouseYGrid][mouseXGrid].members[i].stackOrder = nil

					end 

					grid[mouseYGrid][mouseXGrid].occupied = false
					movementOriginLocked = true
					grid[mouseYGrid][mouseXGrid].moveLockedHighlight = true
					moveLockedRow = mouseYGrid
					moveLockedColumn = mouseXGrid
					grid[mouseYGrid][mouseXGrid].legalMove = false
					grid[mouseYGrid][mouseXGrid].occupants = 0

				elseif grid[mouseYGrid][mouseXGrid].legalMove and grid[mouseYGrid][mouseXGrid].occupants > 5 and not movementOriginLocked then
					lowestMSStackOrder = grid[mouseYGrid][mouseXGrid].occupants - 4
					movementOriginRow = mouseYGrid
					movementOriginColumn = mouseXGrid
					--MOVE TOP FIVE MEMBERS INTO MOUSESTONES.MEMBERS
					for i = grid[mouseYGrid][mouseXGrid].occupants - 4, grid[mouseYGrid][mouseXGrid].occupants do --RUN THIS LOOP 5 TIMES
						mouseStones.occupants = mouseStones.occupants + 1
						mouseStones.members[i].stoneColor = grid[mouseYGrid][mouseXGrid].members[i].stoneColor
						mouseStones.members[i].stoneType = grid[mouseYGrid][mouseXGrid].members[i].stoneType
						mouseStones.members[i].stackOrder = grid[mouseYGrid][mouseXGrid].members[i].stackOrder
						mouseStones.members[i].originalStackOrder = grid[mouseYGrid][mouseXGrid].members[i].stackOrder
						grid[mouseYGrid][mouseXGrid].members[i].stoneColor = nil
						grid[mouseYGrid][mouseXGrid].members[i].stoneType = nil
						grid[mouseYGrid][mouseXGrid].members[i].stackOrder = nil
					end
					movementOriginLocked = true
					grid[mouseYGrid][mouseXGrid].moveLockedHighlight = true
					moveLockedRow = mouseYGrid
					moveLockedColumn = mouseXGrid
					grid[mouseYGrid][mouseXGrid].legalMove = false
					grid[mouseYGrid][mouseXGrid].occupants = grid[mouseYGrid][mouseXGrid].occupants - 5
				end
				
			end
---[[STONES IN HAND LOCKED
	if moveType == 'move' and movementOriginLocked then --FIRST STONES DROP
		--do some checking so we cannot drop or pickup more than we started with
		if love.keyboard.wasPressed('down') and mouseStones.occupants > 1 and not stonesInHandLocked then --DROP STONE IN ORIGIN LOCKED SPACE
			droppedInMovementOrigin = droppedInMovementOrigin + 1
			sounds['stone']:play()
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants + 1].stoneColor = mouseStones.members[lowestMSStackOrder].stoneColor
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants + 1].stoneType = mouseStones.members[lowestMSStackOrder].stoneType
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants + 1].stackOrder = mouseStones.members[lowestMSStackOrder].stackOrder
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants + 1].originalStackOrder = mouseStones.members[lowestMSStackOrder].originalStackOrder
			mouseStones.occupants = mouseStones.occupants - 1 --MAKE NEW VARIABLE TO HOLD MOUSE STONE MEMBER NUMBER
			grid[movementOriginRow][movementOriginColumn].occupants = grid[movementOriginRow][movementOriginColumn].occupants + 1

			grid[movementOriginRow][movementOriginColumn].occupied = true
			mouseStones.members[lowestMSStackOrder].stoneColor = nil
			mouseStones.members[lowestMSStackOrder].stoneType = nil
			mouseStones.members[lowestMSStackOrder].stackOrder = nil

			lowestMSStackOrder = lowestMSStackOrder + 1

		elseif love.keyboard.wasPressed('up') and droppedInMovementOrigin >= 1 and not stonesInHandLocked then --PICKUP STONE IN ORIGIN LOCKED SPACE
			sounds['stone']:play()
			droppedInMovementOrigin = droppedInMovementOrigin - 1
			lowestMSStackOrder = lowestMSStackOrder - 1
			--COPY MOVEMENTORIGIN STONE INTO MOUSESTONE AT APPROPRIATE INDEX
			mouseStones.members[lowestMSStackOrder].stoneColor = grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants].stoneColor 
			mouseStones.members[lowestMSStackOrder].stoneType = grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants].stoneType
			mouseStones.members[lowestMSStackOrder].stackOrder = grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants].stackOrder
			mouseStones.members[lowestMSStackOrder].originalStackOrder = grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants].originalStackOrder
			--NIL THE TOPMOST STONE IN OUR MO GRID
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants].stoneColor = nil
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants].stoneType = nil
			grid[movementOriginRow][movementOriginColumn].members[grid[movementOriginRow][movementOriginColumn].occupants].stackOrder = nil
			
			--UPDATE OCCUPANTS
			mouseStones.occupants = mouseStones.occupants + 1
			grid[movementOriginRow][movementOriginColumn].occupants = grid[movementOriginRow][movementOriginColumn].occupants - 1
		elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
			stonesInHandLocked = true
			updateStackControl(grid[movementOriginRow][movementOriginColumn])
			updateStoneControl(grid[movementOriginRow][movementOriginColumn])
		end
	end

	if moveType == 'move' and stonesInHandLocked then --ACTIVATING FIRSTMOVEMENTGRID
		function love.mousepressed(x, y, button)
			if button == 1 and mouseXGrid ~= nil and mouseYGrid ~= nil then 
				if grid[mouseYGrid][mouseXGrid].legalMove and not firstMovementGridLocked then
					--stonesInHandLocked = false
					firstMovementGridLocked = true
					grid[mouseYGrid][mouseXGrid].moveLockedHighlight = true
					falsifyAllOccupantsLegalMove()
					if mouseYGrid > moveLockedRow then
						downDirection = true
					elseif mouseYGrid < moveLockedRow then
						topDirection = true
					elseif mouseXGrid > moveLockedColumn then
						rightDirection = true
					elseif mouseXGrid < moveLockedColumn then
						leftDirection = true
					end
					--moveLockedRow = mouseYGrid
					--moveLockedColumn = mouseXGrid
				end
			end
		end
	end
--]]

--[[FIRSTMOVEMENTGRID LOCKED
	if moveType == 'move' and firstMovementGridLocked then --DROP IN FIRST MOVEMENT GRID
		--do some checking so we cannot drop or pickup more than we started with
		if love.keyboard.wasPressed('down') and mouseStones.occupants >= 1 and not firstMovementStonesDropped then  --DROP STONE IN FIRSTMOVEMENT GRID
			sounds['stone']:play()
			droppedInFirstMovement = droppedInFirstMovement + 1
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].stoneColor = mouseStones.members[lowestMSStackOrder].stoneColor
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].stoneType = mouseStones.members[lowestMSStackOrder].stoneType
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].stackOrder = grid[moveLockedRow][moveLockedColumn].occupants + 1
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].originalStackOrder = mouseStones.members[lowestMSStackOrder].originalStackOrder
			mouseStones.occupants = mouseStones.occupants - 1 --MAKE NEW VARIABLE TO HOLD MOUSE STONE MEMBER NUMBER
			grid[moveLockedRow][moveLockedColumn].occupants = grid[moveLockedRow][moveLockedColumn].occupants + 1

			grid[moveLockedRow][moveLockedColumn].occupied = true
			mouseStones.members[lowestMSStackOrder].stoneColor = nil
			mouseStones.members[lowestMSStackOrder].stoneType = nil
			mouseStones.members[lowestMSStackOrder].stackOrder = nil

			lowestMSStackOrder = lowestMSStackOrder + 1
		elseif love.keyboard.wasPressed('up') and droppedInFirstMovement >= 1 and not firstMovementStonesDropped then --PICKUP STONE IN ORIGIN LOCKED SPACE
			sounds['stone']:play()
			droppedInFirstMovement = droppedInFirstMovement - 1
			lowestMSStackOrder = lowestMSStackOrder - 1
			--COPY MOVEMENTORIGIN STONE INTO MOUSESTONE AT APPROPRIATE INDEX
			mouseStones.members[lowestMSStackOrder].stoneColor = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneColor 
			mouseStones.members[lowestMSStackOrder].stoneType = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneType
			mouseStones.members[lowestMSStackOrder].stackOrder = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].originalStackOrder
			mouseStones.members[lowestMSStackOrder].originalStackOrder = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].originalStackOrder
			--NIL THE TOPMOST STONE IN OUR MO GRID
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneColor = nil
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneType = nil
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stackOrder = nil
			
			--UPDATE OCCUPANTS
			mouseStones.occupants = mouseStones.occupants + 1
			grid[moveLockedRow][moveLockedColumn].occupants = grid[moveLockedRow][moveLockedColumn].occupants - 1  
		elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') and droppedInFirstMovement >= 1 and not firstMovementStonesDropped then
			firstMovementStonesDropped = true
			updateStackControl(grid[moveLockedRow][moveLockedColumn])
			updateStoneControl(grid[movementOriginRow][movementOriginColumn])
				---[[	

			if topDirection then --LOCK IN DIRECTIONAL LEGAL MOVE
					moveLockedRow = moveLockedRow - 1
					grid[moveLockedRow][moveLockedColumn].moveLockedHighlight = true
			elseif downDirection then
					moveLockedRow = moveLockedRow + 1
					grid[moveLockedRow][moveLockedColumn].moveLockedHighlight = true
			elseif leftDirection then
					moveLockedColumn = moveLockedColumn - 1
					grid[moveLockedRow][moveLockedColumn].moveLockedHighlight = true
			elseif rightDirection then
					moveLockedColumn = moveLockedColumn + 1
					grid[moveLockedRow][moveLockedColumn].moveLockedHighlight = true
			end	

			if mouseStones.occupants == 0 then --DROPPED ALL STONES
				moveType = 'place'
				playerSwapGridReset()
			end
		end
	
	end
--]]

--[[SECONDMOVEMENTGRID LOCKED
	if moveType == 'move' and firstMovementStonesDropped then
		if love.keyboard.wasPressed('down') and mouseStones.occupants >= 1 then
			sounds['stone']:play()
			droppedInSecondMovement = droppedInSecondMovement + 1
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].stoneColor = mouseStones.members[lowestMSStackOrder].stoneColor
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].stoneType = mouseStones.members[lowestMSStackOrder].stoneType
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].stackOrder = grid[moveLockedRow][moveLockedColumn].occupants + 1
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants + 1].originalStackOrder = mouseStones.members[lowestMSStackOrder].originalStackOrder
			mouseStones.occupants = mouseStones.occupants - 1 --MAKE NEW VARIABLE TO HOLD MOUSE STONE MEMBER NUMBER
			grid[moveLockedRow][moveLockedColumn].occupants = grid[moveLockedRow][moveLockedColumn].occupants + 1

			grid[moveLockedRow][moveLockedColumn].occupied = true
			mouseStones.members[lowestMSStackOrder].stoneColor = nil
			mouseStones.members[lowestMSStackOrder].stoneType = nil
			mouseStones.members[lowestMSStackOrder].stackOrder = nil

			lowestMSStackOrder = lowestMSStackOrder + 1
		elseif love.keyboard.wasPressed('up') and droppedInSecondMovement >= 1 then
			sounds['stone']:play()
			droppedInSecondMovement = droppedInSecondMovement - 1
			lowestMSStackOrder = lowestMSStackOrder - 1
			--COPY MOVEMENTORIGIN STONE INTO MOUSESTONE AT APPROPRIATE INDEX
			mouseStones.members[lowestMSStackOrder].stoneColor = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneColor 
			mouseStones.members[lowestMSStackOrder].stoneType = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneType
			mouseStones.members[lowestMSStackOrder].stackOrder = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].originalStackOrder
			mouseStones.members[lowestMSStackOrder].originalStackOrder = grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].originalStackOrder
			--NIL THE TOPMOST STONE IN OUR MO GRID
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneColor = nil
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stoneType = nil
			grid[moveLockedRow][moveLockedColumn].members[grid[moveLockedRow][moveLockedColumn].occupants].stackOrder = nil
			
			--UPDATE OCCUPANTS
			mouseStones.occupants = mouseStones.occupants + 1
			grid[moveLockedRow][moveLockedColumn].occupants = grid[moveLockedRow][moveLockedColumn].occupants - 1  
		end

	elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') and droppedInSecondMovement >= 1 then
		secondMovementStonesDropped = true
		--updateStackControl(grid[moveLockedRow][moveLockedColumn])
		--updateStoneControl(grid[moveLockedRow][moveLockedColumn])
		--UPDATE MOVELOCKEDGRID BASED ON MOVEMENT DIRECTION
		if mouseStones.occupants == 0 then --DROPPED ALL STONES
			moveType = 'place'
			playerSwapGridReset()
		end

	end
--]]


--[[ASSIGN LOWESTMSSTACKORDER
	for i = 10, 1, -1 do
		if mouseStones.members[i].stackOrder ~= nil then
			lowestMSStackOrder = mouseStones.members[i].stackOrder
		end
	end
--]]

--[[MOVE 1 LEGAL HIGHLIGHTS
	--CHANGE HIGHLIGHT BOOL TO LEGALMOVE BOOL, CONTROL HIGHLIGHT FROM THERE
	if stonesInHandLocked and not firstMovementGridLocked then
		if moveLockedRow == 1 and moveLockedColumn == 1 then --CORNERCASES 
			grid[1][2].legalMove = true
			grid[2][1].legalMove = true
		elseif moveLockedRow == 1 and moveLockedColumn == 5 then
			grid[1][4].legalMove = true
			grid[2][5].legalMove = true
		elseif moveLockedRow == 5 and moveLockedColumn == 1 then
			grid[4][1].legalMove = true
			grid[5][2].legalMove = true
		elseif moveLockedRow == 5 and moveLockedColumn == 5 then
			grid[5][4].legalMove = true
			grid[4][5].legalMove = true
		end
	--elseif firstMovementStonesDropped then --LOCK IN DIRECTIONAL LEGALMOVE

	end

	--EDGECASES
	if stonesInHandLocked and not firstMovementGridLocked then
		if moveLockedColumn == 1 and moveLockedRow ~= 1 and moveLockedRow ~= 5 then --LEFT EDGE
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
		elseif moveLockedColumn == 5 and moveLockedRow ~= 1 and moveLockedRow ~= 5 then --RIGHT EDGE
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
		elseif moveLockedRow == 1 and moveLockedColumn ~= 1 and moveLockedColumn ~= 5 then --TOP EDGE
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
		elseif moveLockedRow == 5 and moveLockedColumn ~= 1 and moveLockedColumn ~= 5 then --BOTTOM EDGE
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
		end
	elseif firstMovementGridLocked then 

	end

	--MIDDLECASES
	if stonesInHandLocked and not firstMovementGridLocked then
		if moveLockedColumn > 1 and moveLockedColumn < 5 and moveLockedRow > 1 and moveLockedRow < 5 then
			grid[moveLockedRow - 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow + 1][moveLockedColumn].legalMove = true
			grid[moveLockedRow][moveLockedColumn + 1].legalMove = true
			grid[moveLockedRow][moveLockedColumn - 1].legalMove = true
		end
	elseif firstMovementGridLocked then

	end
--]]

--[[FALSIFYING LEGAL MOVES
	for i = 1, 5 do
		for j = 1, 5 do
			if movementOriginLocked and not stonesInHandLocked then --NO LEGALMOVES WHEN PLACING STONES IN MOVEMENT ORIGIN
				grid[i][j].legalMove = false
			elseif stonesInHandLocked then
				if grid[i][j].stoneControl == 'CS' or grid[i][j].stoneControl == 'SS' then --FLUSHES LEGAL MOVES IF SPACE INCLUDES CS OR SS
					grid[i][j].legalMove = false
				end
			end
		end
	end
end





			elseif moveType == 'move' then
				if player == 1 then
					if mouseXGrid == j and mouseYGrid == i and not movementOriginLocked then
						if grid[i][j].stackControl == 'WHITE' then
							grid[i][j].legalMove = true
						end
					--ADD firstmovementgridlocked highlights
					else
						grid[i][j].legalMoveHighlight = false
					end
				elseif player == 2 then
					if mouseXGrid == j and mouseYGrid == i  and not movementOriginLocked then
						if grid[i][j].stackControl == 'BLACK' then
							grid[i][j].legalMove = true
						end
					else
						grid[i][j].legalMoveHighlight = false
					end
				end
			end
			if mouseXGrid == j and mouseYGrid == i and grid[i][j].legalMove then --FLUSHES LM HIGHLIGHT IF MOUSE NOT OVER IT
				grid[i][j].legalMoveHighlight = true
			else
				grid[i][j].legalMoveHighlight = false
			end
	--]]
	---------OLD CODE

function PlayState:render()

	love.graphics.clear(80/255, 80/255, 80/255, 255/255)
	board:render()
	
---[[RENDERS PLACED STONES
	for i = 1, 5 do
		for j = 1, 5 do
			if moveType == 'place' then
				--RENDERS GRID HIGHLIGHT IF NOT OCCUPIED
				if grid[i][j].selectionHighlight and not grid[i][j].occupied then
					grid[i][j]:render()
				end

			elseif moveType == 'move' then
				if grid[i][j].legalMoveHighlight or grid[i][j].moveLockedHighlight then
					grid[i][j]:render()
				end
			end

			--RENDERS MEMBER STONES
			for i = 1, 5 do
				for j = 1, 5 do
					for k = 1, 10 do
						grid[i][j].members[k]:render()
					end
				end
			end

		end
	end
--]]

---[[RENDERS STONE SELECTION AT MOUSE POSITION
	if not toggleMouseStone then
		if moveType == 'place' then
			if player == 1 then
				love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
			elseif player == 2 then
				love.graphics.setColor(0/255, 0/255, 0/255, 255/255)
			end
			if stoneSelect == 1 then
				love.graphics.rectangle('fill', mouseMasterX - 60, mouseMasterY - 60, 120, 120)
			elseif stoneSelect == 2 then
				love.graphics.rectangle('fill', mouseMasterX - 60, mouseMasterY - 22, 120, 44)
			elseif stoneSelect == 3 then
				love.graphics.circle('fill', mouseMasterX, mouseMasterY, 50)
			end
		elseif moveType == 'move' and movementEvent == 2 then
			for i = 1, 10 do
				mouseStones.members[i]:render()
			end
		end
	end
--]]

---[[RENDERS PLAYER'S TURN
	if player == 1 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is White\'s move', 45, VIRTUAL_HEIGHT - 38)
	elseif player == 2 then
		love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
		love.graphics.print('It is Black\'s move', 45, VIRTUAL_HEIGHT - 38)
	end
--]]

---[[TITLE
	love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
	love.graphics.setFont(titleFont)
	love.graphics.print('TAK', VIRTUAL_WIDTH - 400, 40)
--]]

	--DEBUG INF0
	love.graphics.setColor(0/255, 255/255, 0/255, 255/255)
	love.graphics.setFont(smallFont)
	--love.graphics.print('stoneSelect: ' .. tostring(stoneSelect), VIRTUAL_WIDTH - 400, 180)
	if moveType == 'place' then
		love.graphics.print('moveType: place', VIRTUAL_WIDTH - 380, 180)
	elseif moveType == 'move' then
		love.graphics.print('moveType: move', VIRTUAL_WIDTH - 380, 180)
	end
--[[
	--love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.stoneColor: ' .. tostring(grid[mouseYGrid][mouseXGrid].members[1].stoneColor), VIRTUAL_WIDTH - 490, 220)
	love.graphics.print('right: ' ..tostring(rightDirection), VIRTUAL_WIDTH - 490, 270)

	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.control: ' .. tostring(grid[mouseYGrid][mouseXGrid].stackControl), VIRTUAL_WIDTH - 490, 320)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.occupants: ' .. tostring(grid[mouseYGrid][mouseXGrid].occupants), VIRTUAL_WIDTH - 490, 370)
	love.graphics.print('[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. tostring(']') .. '.LM: ' .. tostring(grid[mouseYGrid][mouseXGrid].legalMove), VIRTUAL_WIDTH - 490, 420)
	love.graphics.print('StoneIHLock: ' .. tostring(stonesInHandLocked), VIRTUAL_WIDTH - 490, 470)
	love.graphics.print('MS.occupants: ' .. tostring(mouseStones.occupants), VIRTUAL_WIDTH - 490, 520)
	love.graphics.print('LMHighlight: : ' .. tostring(grid[mouseYGrid][mouseXGrid].legalMoveHighlight), VIRTUAL_WIDTH - 490, 570)
	love.graphics.print('lowStacOrd: ' .. tostring(lowestMSStackOrder), VIRTUAL_WIDTH - 490, 620)
--]]
	
	love.graphics.print('GRID[' .. tostring(mouseYGrid) .. '][' .. tostring(mouseXGrid) .. ']', VIRTUAL_WIDTH - 490, DEBUGY)
	love.graphics.print('legalMove: ' ..tostring(grid[mouseYGrid][mouseXGrid].legalMove), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET)
	love.graphics.print('stackControl: ' ..tostring(grid[mouseYGrid][mouseXGrid].stackControl), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 2)
	love.graphics.print('stoneControl: ' ..tostring(grid[mouseYGrid][mouseXGrid].stoneControl), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 3)
	love.graphics.print('mouseStoneOccupants: ' .. tostring(mouseStones.occupants), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 4)	--love.graphics.print('StoneIHLock: ' .. tostring(stonesInHandLocked), VIRTUAL_WIDTH - 490, 470)
	--love.graphics.print('MLRow[' .. tostring(moveLockedRow) .. tostring(']'), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 5)	--love.graphics.print('StoneIHLock: ' .. tostring(stonesInHandLocked), VIRTUAL_WIDTH - 490, 470)
	--love.graphics.print('MLCol[' .. tostring(moveLockedColumn) .. tostring(']'), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 6)
	love.graphics.print('movementEvent#: ' .. tostring(movementEvent), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 6)
	love.graphics.print('mOriginRow: ' .. tostring(movementOriginRow), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 7)
	love.graphics.print('mOriginColumn: ' .. tostring(movementOriginRow), VIRTUAL_WIDTH - 490, DEBUGY + DEBUGYOFFSET * 8)
	--love.graphics.print('MS.occupants: ' .. tostring(mouseStones.occupants), VIRTUAL_WIDTH - 490, 520)
	--love.graphics.print('LMHighlight: : ' .. tostring(grid[mouseYGrid][mouseXGrid].legalMoveHighlight), VIRTUAL_WIDTH - 490, 570)
	--love.graphics.print('lowStacOrd: ' .. tostring(lowestMSStackOrder), VIRTUAL_WIDTH - 490, 620)

	--STONE COUNT
	love.graphics.print('player1 stones: ' .. tostring(player1stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 100)
	love.graphics.print('player2 stones: ' .. tostring(player2stones), VIRTUAL_WIDTH - 400, VIRTUAL_HEIGHT - 50)
end