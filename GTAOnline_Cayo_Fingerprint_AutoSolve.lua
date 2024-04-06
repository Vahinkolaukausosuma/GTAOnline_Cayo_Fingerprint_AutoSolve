if not CreateDisplay then require"glwrapper" end
-- if not sleep then require"socket" sleep = socket.sleep end
local ReadImagePixelColorEx = function(x,y)
	return ReadImagePixelColor(x*(Width/imageX),y*(Height/imageY))
end
-- ReadPixelColorColor_ = ReadPixelColorColor
ReadPixelColor_ = ReadPixelColorColorUnsafeAsFuck
-- function ReadPixelColorColor(x,y) return ReadPixelColorColor_(x,y) end
-- function ReadPixelColorColor(x,y) local r,g,b,a = ReadPixelColorColor_(x,y) if r and g and b then return r,g,b end return 0,0,0 end
local Width = 395
local Height = 310
-- local Width = 1920/2
-- local Height = 1080/2
local TimerHash = ""
local TimerTime = 0
local Hw = Width/2
local Hh = Height/2
local yrat = (Height/Width)
local xrat = (Width/Height)
local VK_LEFT = 0x25
local VK_RIGHT = 0x27
-- local VK_UP = 1
-- local VK_DOWN = 1
local VK_UP = 0x26
local VK_DOWN = 0x28

local HashSimilarity = 4						--      <-------- Settings
local renderFingerprint = true					--      <-------- Settings
local RenderAllSections = true					--      <-------- Settings
local FASTMODE = false							--      <-------- Settings
local DEBUG_DISABLE_HASH_CHECK_AND_FINGERPRINT_POSITION_CORRECTION = false -- ONLY WORKS ON 6.png FINGERPRINT WHEN ENABLED
if FASTMODE then 
	renderFingerprint = false
	RenderAllSections = false
end

flags = SDL_WINDOW_OPENGL
-- flags = BitOR(flags,SDL_WINDOW_ALWAYS_ON_TOP)
-- flags = BitOR(flags,SDL_WINDOW_RESIZABLE)
flags = BitOR(flags,SDL_WINDOW_SKIP_TASKBAR)
-- flags = BitOR(flags,SDL_WINDOW_BORDERLESS)

local WindowPositionX = -1280
local WindowPositionY = 465
local TargetPrintWindow = {x=902,y=296,w=668,h=686}
local ComponentPrintWindow = {x=383,y=352,w=468,h=603}
local HashLocation = {x=1004,y=339,w=450,h=634}
local TimerLocation = {x=578,y=133,w=170,h=48}


local function DrawRect(xx,yy,w,h,skip)
	for x = 0,w,skip do 
		for y = 0,h,skip do 
			GlDraw2f(xx+x,yy+y)
		end
	end
end
-- imageX,imageY = LoadTexture("gtao2.png")


function table.Count(tbl)
	local count = 0
	for k,v in pairs(tbl) do
		count = count + 1
		
	end
	return count
end

BoxList = 
{
	{{x=387,y=357,w=460,h=61},{x=983,y=350,w=502,h=67}},
	{{x=387,y=433,w=460,h=61},{x=983,y=426,w=502,h=67}},
	{{x=387,y=509,w=460,h=61},{x=983,y=503,w=502,h=67}},
	{{x=387,y=585,w=460,h=61},{x=983,y=580,w=502,h=67}},
	{{x=387,y=661,w=460,h=61},{x=983,y=657,w=502,h=67}},
	{{x=387,y=737,w=460,h=61},{x=983,y=734,w=502,h=67}},
	{{x=387,y=813,w=460,h=61},{x=983,y=811,w=502,h=67}},
	{{x=387,y=889,w=460,h=61},{x=983,y=887,w=502,h=67}}
}

-- local FingerprintOffsets = 
-- {
	-- ["8ecd451e71a37450de6ea19b6f29617612d0c600657582e655c1215f"] = {3,5}, --1.png
	-- ["e5d5e05d872683964541cb2dc70457cede123bbdf4beb4c2a4f86e74"] = {-7,4}, --2.png
	-- ["564cdbd4a3a0e25cc307785f2c5d098f0e8b6e45d54c61b4b913da1a"] = {3,-3}, --3.png
	-- ["aef70351f78aecb4d75f3f3c72e816c9b6244724077a28b4bb4ae935"] = {-3,3}, --4.png
	-- ["b582918d70ce259639e7e7afbdebe408a1dbcbbe6aa2c7bfa32ed721"] = {-8,1}, --5.png
	-- ["502eef0ad4d98ec1755d3ad76e03e6ad735db94c9696998bc7a53f1a"] = {0,0}, --6.png
	-- ["836ce0498c879368dce516050fc57d1c4fb4a18555505de75bbb03a5"] = {-7,7} --7.png
-- }
-- local FingerprintOffsets = 
-- {
	-- ["2bfaa3b6080ac8144f9d387b4d2ad0c41beabf54f5ee99879d44d7c9"] = {3,5}, --1.png
	-- ["8b9f2bb65fd1bdaa6e04eda6a12a6f5305cb14c5ac1aa49ef5a494f9"] = {-7,4}, --2.png
	-- ["f0fd22cbea4f24deff46f9fb09d580a3c9dd309a9a0dce8051a623dc"] = {3,-3}, --3.png
	-- ["44c9c859b3c1adc350523dce2ed637f7ab3c14ae12b4a94dfb1eaf9c"] = {-3,3}, --4.png
	-- ["88498c0bf2d05139417a16a6fcd5d85660b10456fa2517b5794d804a"] = {-8,1}, --5.png
	-- ["fa909fb4ee7722bbfb3797eb73e1e67cc1fd81ab37ab79801e90c9d4"] = {0,0}, --6.png
	-- ["3ee6489eba2925394cd1c2dcd819e283fb1f7367387def68fa236440"] = {-7,7} --7.png
-- }

local FingerprintOffsets = 
{
	["1311.9482917821"] = {3,5}, --1.png
	["1147.6823638042"] = {-7,4}, --2.png
	["1167.460757156"] = {3,-3}, --3.png
	["1243.1394275162"] = {-3,3}, --4.png
	["1005.7987072946"] = {-8,1}, --5.png
	["1173.5734072022"] = {0,0}, --6.png
	["1097.1560480148"] = {-7,7} --7.png
}

local function SampleQuad(imagex,imagey,w)
	local num = 0
	local pxcount = 0
	for x = 0,w,4 do
		for y = 0,w-1,4 do 
			
			local BigBoxX = imagex + x
			local BigBoxY = imagey + y
			-- print(BigBoxX,BigBoxY)
			r,g,b,a = ReadPixelColor(BigBoxX,BigBoxY)
			-- print(r,g,b)
			if r and g and b then
				r = math.floor(r/20)*20
				g = math.floor(g/20)*20
				b = math.floor(b/20)*20
				pxcount = pxcount + 1
				num = num + r + g + b
				-- print(num)
			end
		end
	end
	
	return num / pxcount / 3
end


local function GetFingerprintHash()
	local hash = 0
	for x = 0,HashLocation.w,75 do 
		for y = 0,HashLocation.h-1,75 do 
			
			local BigBoxX = HashLocation.x + x
			local BigBoxY = HashLocation.y + y
			-- r,g,b,a = ReadPixelColorColor(BigBoxX,BigBoxY) 
			local sample_ = SampleQuad(BigBoxX,BigBoxY,75)
			hash = hash + sample_
			-- print(sample_)
		end
	end
	-- return sha2.sha224(hash)
	return hash
end
-- local function GetFingerprintHash()
	-- return "fa909fb4ee7722bbfb3797eb73e1e67cc1fd81ab37ab79801e90c9d4"
-- end

local function FindActiveSection()
	for i = 1,8 do
		local r,g,b,a = ReadPixelColor(BoxList[i][1].x + 9,BoxList[i][1].y + 28)
		if r+g+b > 400 then return i end
	end
end

-- function FindClosestUncompleteSection(activep_)
	-- activep_ = activep_ or 1
    -- for u = activep_,activep_+3 do
    -- local uoooh = u%8 +1
        -- if greencounts[i]/greenfcounts[i] < 0.4 then return true end
    -- end
    -- return false
-- end

local function CheckBoxesForRightComponent(xoffset,yoffset)
	-- profiler:start()
	local greencounts = {}
	local greenfcounts = {}
	local biggerPTR = 2
	local smallerPTR = 1
	local xratio = BoxList[1][smallerPTR].w / BoxList[1][biggerPTR].w
	local yratio = BoxList[1][smallerPTR].h / BoxList[1][biggerPTR].h
	for i = 1,8 do
		local pxcount = 0
		local gcount = 0
		local gfcount = 0
		local box = BoxList[i]
		
		for x = 0,box[biggerPTR].w,5 do 
			for y = 0,box[biggerPTR].h-1,5 do 
				pxcount = pxcount + 1
				local BigBoxX = box[2].x + x - xoffset
				local BigBoxY = box[2].y + y - yoffset
				local SmallBoxX = box[1].x + (x*xratio)
				local SmallBoxY = box[1].y + (y*yratio)
				r1,g1,b1,a1 = ReadPixelColor(BigBoxX,BigBoxY)
				-- print(BigBoxX,BigBoxY,r1,g1,b1,a1)
				r2,g2,b2,a2 = ReadPixelColor(SmallBoxX,SmallBoxY)
				-- print(r1,g1,b1,a1)
				local g = math.max(0,g1-g2)
				local gf = math.max(0,g1)
				gcount = gcount + g
				gfcount = gfcount + gf
				
				if renderFingerprint then
					SetColor(0,g,0)
					GlDraw2f(BigBoxX-700,BigBoxY-340)	
				end
				
			end
		end
		greencounts[i] = gcount/pxcount
		greenfcounts[i] = gfcount/pxcount
	end
	local activep = FindActiveSection()
	local keypressed = false
	for i = 1,8 do
		
		if greencounts[i]/greenfcounts[i] < 0.34 and not keypressed then
			SetColor(0,255,0)
			if activep == i and not keypressed then
				-- keybd_event(VK_DOWN and FindClosestUncompleteSection() or VK_UP,30)
				local HowManyDown = 0
				for u = activep,activep+7 do
					-- if not keypressed then 
						local uoooh = u%8 +1
						HowManyDown = HowManyDown + 1
						if greencounts[uoooh]/greenfcounts[uoooh] > 0.34 then
							break
						end
							-- keybd_event(VK_UP,80) print("up") susbaka = true
							
							-- Sleep(200) 
							-- keypressed = true
							-- break
						-- end
					-- end
				end
				-- if not susbaka then keybd_event(VK_DOWN,80) print("down") end
				-- if not susbaka then print("down") Sleep(200) keypressed = true end
				-- print(HowManyDown)
				-- if HowManyDown >= 4 then print(HowManyDown,"up") else print(HowManyDown,"down") end
				if HowManyDown >= 4 then
					-- print(HowManyDown,"up") 
					keybd_event(VK_UP,15)
					WaitUntilNewFrame()
				else
					-- print(HowManyDown,"down")
					keybd_event(VK_DOWN,15)
					WaitUntilNewFrame()
				end
				-- keybd_event(VK_DOWN,25)
				keypressed = true
				-- 
				-- keybd_event(VK_DOWN and HowManyDown >= 4 or VK_UP,300)
				-- keybd_event(VK_DOWN,300)

				
				-- break
				if not RenderAllSections then return end
			end
			else
			SetColor(255,0,0)
			if activep == i and not keypressed then
				keybd_event(VK_RIGHT,15) 
				WaitUntilNewFrame()
				keypressed = true
				-- break
				if not RenderAllSections then return end
			end
		end
		if activep == i then
			DrawRect(50,i*50-50,40,40,4)
		end
		DrawRect(0,i*50-50,40,40,4)
		end
	-- profiler:stop()
end


local function GetTimerHash()
	local hash = ""
	for x = 0,TimerLocation.w,25 do 
		for y = 0,TimerLocation.h-1,25 do 
			
			local BigBoxX = TimerLocation.x + x
			local BigBoxY = TimerLocation.y + y
			-- r,g,b,a = ReadPixelColor_(BigBoxX,BigBoxY) 
			hash = hash .. SampleQuad(BigBoxX,BigBoxY,25)
		end
	end
	-- return sha2.sha224(hash)
	return hash
end
function WaitUntilNewFrame()
	-- local t__ = os.clock()
	local num_ = 0

	while true do
		if num_ == 2 then 
			break
		end
		CaptureScreen()
		local tt = GetTimerHash()
		if TimerHash ~= tt then
			TimerHash = tt
			num_ = num_ + 1
		end
	end
end

SetWindowPointer(1)
CreateDisplay(Width,Height,"My nuts",flags)
EnableVSyncUnsafe(0)
SetViewport(0,0,Width*2,Height*2)
print(Width,Height,"My nuts",flags)


-- MoveWindow(-1280,465) --aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa hi
MoveWindow(WindowPositionX,WindowPositionY) --aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa hi

-- for i = 1,7 do
	-- io.read()
	-- CaptureScreen()
	-- print(i .. " " .. GetFingerprintHash())
-- end


    -- profiler = newProfiler()



function closestHashMatch(hash)
	for k,v in pairs(FingerprintOffsets) do
		-- for i,j in pairs(v) do print(i,j) end
		if math.abs(hash-k) < HashSimilarity then
			return v
		end
	end
	-- break
end

while not DisplayIsClosed() do
-- for i = 1,200 do
	-- GetFingerprintHash()
	-- WaitUntilNewFrame()
	CaptureScreen()

	-- print("sus", TimerHash)
	DisplayClear()
	GlBeginPoints()
	
	if DEBUG_DISABLE_HASH_CHECK_AND_FINGERPRINT_POSITION_CORRECTION then
		CheckBoxesForRightComponent(0,0)
		else
		local hash_ = GetFingerprintHash()
		local hash = closestHashMatch(hash_)
		-- print(hash_,hash)
		-- io.read()
		
		if hash then
			-- print(hash)
				
				CheckBoxesForRightComponent(hash[1],hash[2])
		end
	end
	
	GlEnd()
	DisplayUpdate()
end
    
    -- local outfile = io.open( "profile.txt", "w+" )
    -- profiler:report( outfile )
    -- outfile:close()

DestroyDisplay()