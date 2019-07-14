--  Name: MapFunctions v1.18.0
--  Author: Mikali
--  Created: 2004/10/07
--  Updated: 2013/09/30
--  Homepage: http//isometricland.net
--  Discussion:
--  http://forums.relicnews.com/showthread.php?t=48818
--  http://forums.relicnews.com/showthread.php?t=82964 (old thread)
-- http://forums.relicnews.com/showthread.php?t=40779 (old thread)
--  Credits:
--  * MathWorld and Wikipedia for the parametric surface functions used in 
--    "shapeAdd", "harmonographAdd" and probably elsewhere.
--  * GameDev.net for the implicit metaball formula used in "blobAdd".
--  * The function "flokalAdd" is based on 'doodle 4' by bitcraft at 
--    OpenProcessing.org.
--  * Lorenzo Donati at Stack Overflow for the new pseudo random number 
--    generator.


--------------------------------------------------------------------------------
-- Global variables.
--

-- incremental counters
iStartPoints, iPoints, iSpheres, iCameras, iSquadrons, iAsteroids, iSalvage, iPebbles, iClouds, iDustClouds, iNebulas, iDirLights, iRvAsteroids, iRvSquadrons = 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
TWO_PI = 2 * PI


--------------------------------------------------------------------------------
--  Name:		appendShape
--  Description:	General shape-adding function utilized internally by the other functions.
--  Syntax:		appendShape(<tPos>, <i>, <tPar>, <j>, <tCoo>, <tRot>)
--  Arguments:
--	<tPos>: a table containing the initial coordinates for the object.
--	<i>: the index of the object within the distribution table.
--	<tPar>: a table containing the object-specific parameters.
--	<j>: the position number of the object within the distribution table.
--	<tCoo>: a table containing the modified coordinates for the object.
--	<tRot>: a table containing the Euler rotation angles.
--  Notes:
--	1. I would like to change the order of the parameters so that <tPos> 
--	   comes after <tRot> since translation is done after rotation. Would 
--	   be good to modify all the other functions to copy this syntax as 
--	   well.
--	2. I should group <i> and <j> together as well.
--------------------------------------------------------------------------------

function appendShape(tPos, i, tPar, j, tCoo, tRot)
	tCoo = vaddV(vrotate(tCoo, tRot), tPos)
	local objType = tPar[2]
	if (objType == "Squadron") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--addSquadron(<sSquadronName>, <sSquadronType>, <tPosition>, <iPlayerIndex>, <tRotation>, <iNumberShips>, <bHyperspace>)
		addSquadron(name, tPar[4], vaddV(tCoo, tPar[5]), tPar[6], tPar[7], tPar[8], tPar[9])
		iSquadrons = iSquadrons + 1
	elseif (objType == "Asteroid") then
		--addAsteroid(<sAsteroidType>, <tPosition>, <fRU%>, ?, ?, ?, ?)
		addAsteroid(tPar[3], vaddV(tCoo, tPar[4]), tPar[5], tPar[6], tPar[7], tPar[8], tPar[9])
		iAsteroids = iAsteroids + 1
	elseif (objType == "Salvage") then
		--addSalvage(<sChunkType>, <tPosition>, <fRU%>, ?, ?, ?, ?)
		addSalvage(tPar[3], vaddV(tCoo, tPar[4]), tPar[5], tPar[6], tPar[7], tPar[8], tPar[9])
		iSalvage = iSalvage + 1
	elseif (objType == "Pebble") then
		--addPebble(<sPebbleType>, <tPosition>, ?, ?, ?)
		addPebble(tPar[3], vaddV(tCoo, tPar[4]), tPar[5], tPar[6], tPar[7])
		iPebbles = iPebbles + 1
	elseif (objType == "Cloud") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--addCloud(<sCloudName>, <sCloudType>, <tPosition>, <tColor>, ?, <fRadius>)
		addCloud(name, tPar[4], vaddV(tCoo, tPar[5]), tPar[6], tPar[7], tPar[8])
		iClouds = iClouds + 1
	elseif (objType == "DustCloud") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--addDustCloud(<sDustCloudName>, <sDustCloudType>, <tPosition>, <tColor>, ?, <fRadius>)
		addDustCloud(name, tPar[4], vaddV(tCoo, tPar[5]), tPar[6], tPar[7], tPar[8])
		iDustClouds = iDustClouds + 1
	elseif (objType == "Nebula") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--addNebula(<sNebulaName>, <sNebulaType>, <tPosition>, <tColor>, ?, <fRadius>)
		addNebula(name, tPar[4], vaddV(tCoo, tPar[5]), tPar[6], tPar[7], tPar[8])
		iNebulas = iNebulas + 1
	elseif (objType == "Point") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--addPoint(<sPointName>, <tPosition>, <tRotation>)
		addPoint(name, vaddV(tCoo, tPar[4]), tPar[5])
		iPoints = iPoints + 1
	elseif (objType == "StartPoint") then
		local name = "StartPos" .. iStartPoints
		--addPoint(<sPointName>, <tPosition>, <tRotation>)
		addPoint(name, vaddV(tCoo, tPar[4]), tPar[5])
		iStartPoints = iStartPoints + 1
	elseif (objType == "Sphere") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--addSphere(<sSphereName>, <tPosition>, <fRadius>)
		addSphere(name, vaddV(tCoo, tPar[4]), tPar[5])
		iSpheres = iSpheres + 1
	elseif (objType == "Camera") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--addCamera(<sCameraName>, <tTarget>, <tPosition>)
		addCamera(name, tPar[5], vaddV(tCoo, tPar[4]))
		iCameras = iCameras + 1
	elseif (objType == "DirLight") then
		local name = tPar[3]
		if (tPar[1] > 1) then
			name = name .. "_" .. j
		end
		--createDirLight(<sLightName>, <tPosition>, <tColor>)
		createDirLight(name, vaddV(tCoo, tPar[4]), tPar[5])
		--setLightSpecular (<sLightName>, <tSpecular>)
		setLightSpecular(name, tPar[6])
		iDirLights = iDirLights + 1
	elseif (objType == "ReactiveSquadron") then
		--addReactiveFleetSlot(<sSobGroupName>, <iPlayerIndex>, ?, <tPosition>, ?, ?, ?, <sShipType>)
		addReactiveFleetSlot(tPar[5], tPar[6], tPar[7], vaddV(tCoo, tPar[4]), tPar[8], tPar[9], tPar[10], tPar[3])
		iRvSquadrons = iRvSquadrons + 1
	elseif (objType == "ReactiveAsteroid") then
		--addReactiveFleetResourceSlot(<sResourceType>, <tPosition>, ?, ?, ?)
		addReactiveFleetResourceSlot(tPar[3], vaddV(tCoo, tPar[4]), tPar[5], tPar[6], tPar[7])
		iRvAsteroids = iRvAsteroids + 1
	elseif (objType == "Coordinate") then
		tinsert(tPar[3], tCoo)
		print("function appendShape: adding a coordinate to the coordinate table")
		print("function appendShape: coordinate table length = " .. getn(tPar[3]))
	elseif (objType == "Function") then
		if not (tPar[7]) then
			tPar[7] = {0,0,0,}
		end
		if (tPar[3] == literalAdd) then
			literalAdd(tPar[4], tPar[5], tPar[6], vaddV(tRot, tPar[7]))
		else
			tPar[3](vaddV(tCoo, tPar[4]), tPar[5], tPar[6], vaddV(tRot, tPar[7]))
		end
	else
		print("function appendShape: object class not recognized")
	end
end

function addCoordinate(tCoo, rTable)
	tinsert(rTable, tCoo)
end

function addSOBGroup(sSobName, ...)
	createSOBGroup(sSobName)
	for i = 1, getn(arg) do
		addToSOBGroup(arg[i], sSobName)
	end
end

function doAllSOBGroups(ttable)
	for sobgname, sobgarray in ttable do
		for j = 1, getn(sobgarray) do
			if sobgarray[j][4] == 0 then
				if sobgarray[j][2] == 1 then
					addToSOBGroup(sobgarray[j][1], sobgname)
				else
					for k = 1, sobgarray[j][2] do
						addToSOBGroup(sobgarray[j][1] .. "_" .. k, sobgname)
					end
				end
			end
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		branchAdd
--  Description:	Creates a branching tree-like fractal.
--  Syntax:		branchAdd(<tPos>, <tDst>, {<tDiv>, <tInt>, <tFrq>, <tBeg>, <tEnd>, <tRad>, <tLen>, <tThk>, <tAng>, <iMod>,}, <tRot>, <tSeed>, ...)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following ten parameters:
--		<tDiv>: a table containing the minimum and maximum number of new shoots that are generated each time the tree divides.
--		<tInt>: a table containing the minimum and maximum number of segments between instances of division.
--		<tFrq>: a table containing the minimum and maximum number of times the tree divides.
--		<tBeg>: a table containing the minimum and maximum number of segments added to the beginning of the tree.
--		<tEnd>: a table containing the minimum and maximum number of segments added to the end of the tree (at the end of each branch). (Note: this value needs to be greater than zero in order for the last division to be noticable.)
--		<tRad>: a table containing the the minimum and maximum radius of a segment.
--		<tLen>: a table containing the minimum and maximum length of a segment.
--		<tThk>: a table containing the minimum and maximum thickness, as percentages of the radius, of a segment.
--		<tAng>: a table containing the minimum and maximum angle of deviation between segments.
--		<iMod>: 0 is non-random mode, 1 is random placement with steadily decreasing length and radius, 2 is random placement with random length and radius, 3 is a bug-ridden method using splines.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<tSeed>: the seed for the random number functions.
--	The remaining arguments are used internally by the function and should not be modified directly.
--  Notes:
--	1. I suppose I need an <iMod> = 4 mode for a random method using splines, but without decreasing length and radius.
--------------------------------------------------------------------------------

function branchAdd(tPos, tDst, tPar, tRot, tSeed, lastRad, countDiv, countFrq, lastPos, nextPos, tiltDeg, spinDeg)
	local thisPos = {}
	local tDiv, tInt, tFrq, tBeg, tEnd, tRad, tLen, tThk, tAng, iMod = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5], tPar[6], tPar[7], tPar[8], tPar[9], tPar[10]
	local minRad, maxRad, minDist, maxDist, minThck, maxThck = tRad[1], tRad[2], tLen[1], tLen[2], tThk[1]/100, tThk[2]/100
	local minAng, maxAng, minBeg, maxBeg, minEnd, maxEnd = tAng[1], tAng[2], tBeg[1], tBeg[2], tEnd[1], tEnd[2]
	local minDiv, maxDiv, minInt, maxInt, minFrq, maxFrq = tDiv[1], tDiv[2], tInt[1], tInt[2], tFrq[1], tFrq[2]
	local numSeg, numInt, numDiv, numBeg, numEnd, numFrq = 0, 0, 0, 0, 0, 0
	if (lastRad == nil) then
		lastRad = maxRad
		countDiv = 1
		countFrq = minFrq
	else
		countFrq = countFrq - 1
	end
	if (lastPos == nil) then
		lastPos = {0,0,0,}
		nextPos = {0,0,0,}
		tiltDeg, spinDeg = 0, 0
	end
	local thisRad = sqrt(lastRad^2/countDiv)
	-- if set to non-random mode
	if (iMod == 0) then
		numInt, numDiv, numBeg, numEnd, numFrq = maxInt, minDiv, maxBeg, maxEnd, maxFrq
	-- if set to random mode, or random mode with decreasing length and radius
	else
		numInt, numDiv, numBeg, numEnd, numFrq = srandom2(tSeed, minInt, maxInt), srandom2(tSeed, minDiv, maxDiv), srandom2(tSeed, minBeg, maxBeg), srandom2(tSeed, minEnd, maxEnd), srandom2(tSeed, minFrq, maxFrq)
	end
	if (numBeg > 0) then
		numSeg = numBeg
	elseif (numFrq > 0) then
		numSeg = numInt
	elseif (numEnd > 0) then
		numSeg = numEnd
	end
	for k = 1, numSeg do
		local rad, len, thk, angY, angZ = 0, 0, 0, 0, 0
		-- if set to non-random mode
		if (iMod == 0) then
			local sign1, sign2 = srandomSign(tSeed), srandomSign(tSeed)
			rad, len, angY, angZ = maxRad, maxDist, sign1 * maxAng, sign2 * maxAng
		-- if set to random mode with decreasing length and radius
		elseif (iMod == 1) or (iMod == 3) then
			local sign1, sign2, narrw = srandomSign(tSeed), srandomSign(tSeed), srandom3(tSeed, 0.9, 1)
			thisRad = thisRad * narrw
			thk, rad, len, angY, angZ = srandom3(tSeed, minThck, maxThck) * narrw, thisRad, maxDist - (maxDist - minDist)/(numFrq + 1), srandom3(tSeed, minAng, maxAng) * sign1, srandom3(tSeed, minAng, maxAng) * sign2
		-- if set to random mode
		elseif (iMod == 2) then
			local sign1, sign2 = srandomSign(tSeed), srandomSign(tSeed)
			thk, rad, len, angY, angZ = srandom3(tSeed, minThck, maxThck), srandom3(tSeed, minRad, maxRad), srandom3(tSeed, minDist, maxDist), srandom3(tSeed, minAng, maxAng) * sign1, srandom3(tSeed, minAng, maxAng) * sign2
		end
		tiltDeg, spinDeg = tiltDeg + angZ, spinDeg + angY
		thisPos = nextPos
		nextPos = vaddV(nextPos, vrotate({len, 0, 0,}, {0, spinDeg, tiltDeg,}))
		for i, tTab in tDst do
			local Volume1, Volume2 = PI * maxRad^2 * maxDist, PI * rad^2 * len
			local Density = Volume2/Volume1
			local iNum, gradX = floor(tTab[1] * Density + 0.5), len
			for j = 1, iNum do
				-- if set to non-random mode
				if (iMod == 0) then
					local tCoo = {gradX, 0, 0,}
					tCoo = vaddV(thisPos, vrotate(tCoo, {0, spinDeg, tiltDeg,}))
					appendShape(tPos, i, tTab, j, tCoo, tRot)
				-- if set to random mode with decreasing length and radius
				elseif (iMod == 1) then
					local r = sqrt(srandom(tSeed)) * thk * rad + (1 - thk) * rad
					local v, h = srandom3(tSeed, 360), srandom3(tSeed, len)
					local tCoo = {h, r * cos(v), r * sin(v),}
					tCoo = vaddV(thisPos, vrotate(tCoo, {0, spinDeg, tiltDeg,}))
					appendShape(tPos, i, tTab, j, tCoo, tRot)
				-- if set to random mode
				elseif (iMod == 2) then
					local r = sqrt(srandom(tSeed)) * thk * rad + (1 - thk) * rad
					local v, h = srandom3(tSeed, 360), srandom3(tSeed, len)
					local tCoo = {h, r * cos(v), r * sin(v),}
					tCoo = vaddV(thisPos, vrotate(tCoo, {0, spinDeg, tiltDeg,}))
					appendShape(tPos, i, tTab, j, tCoo, tRot)
				-- if set to random method using splines with decreasing length and radius
				elseif (iMod == 3) then
					local t = srandom(tSeed)
					local A = vmidpoint(lastPos, thisPos)
					local B = thisPos
					local C = vmidpoint(thisPos, nextPos)
					local r = sqrt(srandom(tSeed)) * thk * rad + (1 - thk) * rad
					local v = srandom(tSeed, 360)
					local tCirc =
					{
						r * cos(v),
						r * sin(v),
						0,
					}
					local tCoo =
					{
						(1 - t)^2 * A[1] + 2 * (1 - t) * t * B[1] + t^2 * C[1],
						(1 - t)^2 * A[2] + 2 * (1 - t) * t * B[2] + t^2 * C[2],
						(1 - t)^2 * A[3] + 2 * (1 - t) * t * B[3] + t^2 * C[3],
					}
					local tDerivatives =
					{
						2 * (1 - t) * (B[1] - A[1]) + 2 * t * (C[1] - B[1]),
						2 * (1 - t) * (B[2] - A[2]) + 2 * t * (C[2] - B[2]),
						2 * (1 - t) * (B[3] - A[3]) + 2 * t * (C[3] - B[3]),
					}
					local tNormedPos = vrotate(tCirc, vanglesXY(tDerivatives))
					appendShape(tPos, i, tTab, j, vaddV(tCoo, tNormedPos), tRot)
				end
				gradX = gradX - len/iNum
			end
		end
		lastPos = thisPos
	end
	if (numBeg > 0) then
		tBeg = {0, 0,}
		branchAdd(tPos, tDst, {tDiv, tInt, tFrq, tBeg, tEnd, tRad, tLen, tThk, tAng, iMod,}, tRot, tSeed, nil, nil, nil, lastPos, nextPos, tiltDeg, spinDeg)
	elseif (numFrq > 0) then
		if (minFrq >= numFrq) then
			minFrq = numFrq - 1
		end
		tFrq = {minFrq, numFrq - 1,}
		for j = 1, numDiv do
			branchAdd(tPos, tDst, {tDiv, tInt, tFrq, tBeg, tEnd, tRad, tLen, tThk, tAng, iMod,}, tRot, tSeed, thisRad, numDiv, countFrq, lastPos, nextPos, tiltDeg, spinDeg)
		end
	elseif (numEnd > 0) then
		tDiv, tInt, tFrq, tEnd = {0, 0,}, {0, 0,}, {0, 0,}, {0, 0,}
		branchAdd(tPos, tDst, {tDiv, tInt, tFrq, tBeg, tEnd, tRad, tLen, tThk, tAng, iMod,}, tRot, tSeed, thisRad, numDiv, countFrq, lastPos, nextPos, tiltDeg, spinDeg)
	end
end


--------------------------------------------------------------------------------
--  Name:		spline3Add
--  Description:	Creates a Hermite spline-shaped tube connecting any two points using two control points.
--  Syntax:		spline3Add(<tPos>, <tDst>, {<tP1A>, <tP1B>, <tP2A>, <tP2B>, <tRad>, <tThk>,}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following six parameters:
--		<tP1A>: a table containing the coordinates of the starting point.
--		<tP1B>: a table containing the coordinates of the first control point.
--		<tP2A>: a table containing the coordinates of the ending point.
--		<tP2B>: a table containing the coordinates of the second control point.
--		<tRad>: a table containing the initial and final radii of the tube.
--		<tThk>: a table containing the initial and final thickness of the tube lining, as a percentage of the radius.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. Still not sure whether <tThk> should be a percentage instead of a fixed value.
--	2. Needs an <iMode> parameter to output non-random coordinates.
--------------------------------------------------------------------------------

function spline3Add(tPos, tDst, tPar, tRot, tSeed)
	local tP1A, tP1B, tP2A, tP2B, tRad, tThk = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5], tPar[6]
	local begRad, endRad, begThk, endThk = tRad[1], tRad[2], tThk[1]/100, tThk[2]/100
	local P1A_x, P1A_y, P1A_z, P1B_x, P1B_y, P1B_z = tP1A[1], tP1A[2], tP1A[3], tP1B[1], tP1B[2], tP1B[3]
	local P2A_x, P2A_y, P2A_z, P2B_x, P2B_y, P2B_z = tP2A[1], tP2A[2], tP2A[3], tP2B[1], tP2B[2], tP2B[3]

	-- need to reverse the direction of the second control point so that the curves can be stitched neatly together, later
	local C_x = 2 * P2A_x - P2B_x
	local C_y = 2 * P2A_y - P2B_y
	local C_z = 2 * P2A_z - P2B_z

	for i, tTab in tDst do
		for j = 1, tTab[1] do
			local t, phi = srandom(tSeed), srandom(tSeed, 360)
			local r = begRad + (endRad - begRad) * t
			local h = begThk + (endThk - begThk) * t
			r = sqrt(srandom(tSeed)) * h * r + (1 - h) * r
			local tCirc =
			{
				r * cos(phi),
				r * sin(phi),
				0,
			}
			local tCoo =
			{
				(P2A_x + 3 * P1B_x - 3 * C_x - P1A_x) * t^3 + (3 * C_x - 6 * P1B_x + 3 * P1A_x) * t^2 + (3 * P1B_x - 3 * P1A_x) * t + P1A_x,
				(P2A_y + 3 * P1B_y - 3 * C_y - P1A_y) * t^3 + (3 * C_y - 6 * P1B_y + 3 * P1A_y) * t^2 + (3 * P1B_y - 3 * P1A_y) * t + P1A_y,
				(P2A_z + 3 * P1B_z - 3 * C_z - P1A_z) * t^3 + (3 * C_z - 6 * P1B_z + 3 * P1A_z) * t^2 + (3 * P1B_z - 3 * P1A_z) * t + P1A_z,
			}
			local tDerivatives =
			{
				(P2A_x + 3 * P1B_x - 3 * C_x - P1A_x) * 3 * t^2 + (3 * C_x - 6 * P1B_x + 3 * P1A_x) * 2 * t + (3 * P1B_x - 3 * P1A_x),
				(P2A_y + 3 * P1B_y - 3 * C_y - P1A_y) * 3 * t^2 + (3 * C_y - 6 * P1B_y + 3 * P1A_y) * 2 * t + (3 * P1B_y - 3 * P1A_y),
				(P2A_z + 3 * P1B_z - 3 * C_z - P1A_z) * 3 * t^2 + (3 * C_z - 6 * P1B_z + 3 * P1A_z) * 2 * t + (3 * P1B_z - 3 * P1A_z),
			}
			local tNormedPos = vrotate(tCirc, vanglesXY(tDerivatives))
			appendShape(tPos, i, tTab, j, vaddV(tCoo, tNormedPos), tRot)
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		spline2Add
--  Description:	Creates a quadratic spline-shaped tube connecting any two points using a control point.
--  Syntax:		spline2Add(<tPos>, <tDst>, {<tP1>, <tP2>, <tP3>, <tRad>, <tThk>,}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following six parameters:
--		<tP1>: a table containing the coordinates of the starting point.
--		<tP2>: a table containing the coordinates of the control point.
--		<tP3>: a table containing the coordinates of the ending point.
--		<tRad>: a table containing the initial and final radii of the tube.
--		<tThk>: a table containing the initial and final thickness of the tube lining, as a percentage of the radius.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. Still not sure whether <tThk> should be a percentage instead of a fixed value.
--	2. Needs an <iMode> parameter to output non-random coordinates.
--------------------------------------------------------------------------------

function spline2Add(tPos, tDst, tPar, tRot, tSeed)
	local tP1, tP2, tP3, tRad, tThk = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5]
	local begRad, endRad, begThk, endThk = tRad[1], tRad[2], tThk[1]/100, tThk[2]/100
	for i, tTab in tDst do
		for j = 1, tTab[1] do
			local t, phi = srandom(tSeed), srandom(tSeed, 360)
			local r = begRad + (endRad - begRad) * t
			local h = begThk + (endThk - begThk) * t
			r = sqrt(srandom(tSeed)) * h * r + (1 - h) * r
			local tCirc =
			{
				r * cos(phi),
				r * sin(phi),
				0,
			}
			local tCoo =
			{
				(1 - t)^2 * tP1[1] + 2 * (1 - t) * t * tP2[1] + t^2 * tP3[1],
				(1 - t)^2 * tP1[2] + 2 * (1 - t) * t * tP2[2] + t^2 * tP3[2],
				(1 - t)^2 * tP1[3] + 2 * (1 - t) * t * tP2[3] + t^2 * tP3[3],
			}
			local tDerivatives =
			{
				2 * (1 - t) * (tP2[1] - tP1[1]) + 2 * t * (tP3[1] - tP2[1]),
				2 * (1 - t) * (tP2[2] - tP1[2]) + 2 * t * (tP3[2] - tP2[2]),
				2 * (1 - t) * (tP2[3] - tP1[3]) + 2 * t * (tP3[3] - tP2[3]),
			}
			local tNormedPos = vrotate(tCirc, vanglesXY(tDerivatives))
			appendShape(tPos, i, tTab, j, vaddV(tCoo, tNormedPos), tRot)
		end
	end
end

--------------------------------------------------------------------------------
--  Name:		blobAdd
--  Description:	Creates a network of metaballs, or blobs, based on the formula for electromagnetic fields.
--  Syntax:		blobAdd(<tPos>, <tDst>, {<tBlobs>, <fThrsh1>, <fThrsh2>, <tScale>,}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following four parameters:
--		<tBlobs>: a table containing the location coordinates and strength of each blob.
--		<fThrsh1>: threshold 1 in units of field strength.
--		<fThrsh2>: threshold 2 in units of field strength.
--		<tScale>: scale the entire shape by these amounts in the {x,y,z} directions.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. This function is kind of a mess, but the results look OK. I would 
--	   rather plot points parametrically instead of plotting them randomly 
--	   and then testing whether they're inside the blob or not. 
--	   Unfortunately, the function is an implicit isosurface.
--	2. Negative field strength/radius doesn't work here like it does in 
--	   "fieldAdd". Nor does it make sense to I think.
--	3. Should this function use the "fieldCalc" function to calculate 
--	   field strength?
--	4. See Method 1 at: http://www.geogebra.org/en/upload/files/english/Michael_Horvath/Metaballs/geogebra_metaballs.htm
--------------------------------------------------------------------------------

function blobAdd(tPos, tDst, tPar, tRot, tSeed)
	local tBlobs = tPar[1]
	local Blob_threshold_1 = tPar[2]
	local Blob_threshold_2 = tPar[3]
	local Blob_scale = tPar[4]

	-- calculate the bounding box enclosing the blobs
	local Blob_min = {0,0,0,}
	local Blob_max = {0,0,0,}
	for j, jBlob in tBlobs do
		local Blob_vector = jBlob[1]
		local Blob_radius = jBlob[2]
		Blob_min = {min(Blob_min[1], Blob_vector[1] - Blob_radius), min(Blob_min[2], Blob_vector[2] - Blob_radius), min(Blob_min[3], Blob_vector[3] - Blob_radius),}
		Blob_max = {max(Blob_max[1], Blob_vector[1] + Blob_radius), max(Blob_max[2], Blob_vector[2] + Blob_radius), max(Blob_max[3], Blob_vector[3] + Blob_radius),}
	end

	for i, tTab in tDst do
		local jCount = 1
		local jMax = tTab[1]
		while (jCount <= jMax) do
			-- generate a new point somewhere within the blob's bounding box
			local Vector_new = {srandom3(tSeed, Blob_min[1], Blob_max[1]), srandom3(tSeed, Blob_min[2], Blob_max[2]), srandom3(tSeed, Blob_min[3], Blob_max[3]),}
	--		local Vector_new = {random3(Blob_min[1], Blob_max[1]), random3(Blob_min[2], Blob_max[2]), random3(Blob_min[3], Blob_max[3]),}

			-- get the field strength at that point
			local Actual_strength = 0
			for j, jBlob in tBlobs do
				local Blob_vector = jBlob[1]
				local Blob_radius = jBlob[2]
				Actual_strength = Actual_strength + (Blob_radius / sqrt((Vector_new[1] - Blob_vector[1])^2 + (Vector_new[2] - Blob_vector[2])^2 + (Vector_new[3] - Blob_vector[3])^2))
			end

			if (Actual_strength > Blob_threshold_1) then
				-- the field strength, normalized to between 0 and 1
				local Strength_ratio = (Actual_strength - Blob_threshold_1)/(Blob_threshold_2 - Blob_threshold_1)
				-- points should be denser where the strength is greater
				if (Strength_ratio > sqrt(srandom3(tSeed))) then
					-- scale all coordinates by this amount to make the blobs look flatter and better
					Vector_new = vmultiplyV(Vector_new, Blob_scale)
					appendShape(tPos, i, tTab, jCount, Vector_new, tRot)
					jCount = jCount + 1
				end
			end
		end
	end
end

-- old version not using distributions
function blobAdd2(tPos, xNil, tPar, tRot, tSeed)
	local tBlobs = tPar[1]
	local Point_number = tPar[2]
	local Blob_threshold_1 = tPar[3]
	local Blob_threshold_2 = tPar[4]
	local Blob_scale = tPar[5]

	-- calculate the bounding box enclosing the blobs
	-- not really a good method...
	local Blob_min = {0,0,0,}
	local Blob_max = {0,0,0,}
	for j, jBlob in tBlobs do
		local Blob_vector = jBlob[1]
		local Blob_radius = jBlob[2]
		Blob_min = {min(Blob_min[1], Blob_vector[1] - Blob_radius), min(Blob_min[2], Blob_vector[2] - Blob_radius), min(Blob_min[3], Blob_vector[3] - Blob_radius),}
		Blob_max = {max(Blob_max[1], Blob_vector[1] + Blob_radius), max(Blob_max[2], Blob_vector[2] + Blob_radius), max(Blob_max[3], Blob_vector[3] + Blob_radius),}
	end

	local Point_padding = 500		-- put in tPar?
	local Point_maxradius = 1000;
	local Point_list = {}
	local Point_count = 1
	while (Point_count <= Point_number) do
		-- generate a new point somewhere within the blob's bounding box
		local Vector_new = {srandom3(tSeed, Blob_min[1], Blob_max[1]), srandom3(tSeed, Blob_min[2], Blob_max[2]), srandom3(tSeed, Blob_min[3], Blob_max[3]),}
--		local Vector_new = {random3(Blob_min[1], Blob_max[1]), random3(Blob_min[2], Blob_max[2]), random3(Blob_min[3], Blob_max[3]),}

		-- get the field strength at that point
		local Actual_strength = 0
		for j, jBlob in tBlobs do
			local Blob_vector = jBlob[1]
			local Blob_radius = jBlob[2]
			Actual_strength = Actual_strength + (Blob_radius / sqrt((Vector_new[1] - Blob_vector[1])^2 + (Vector_new[2] - Blob_vector[2])^2 + (Vector_new[3] - Blob_vector[3])^2))
		end

		if (Actual_strength > Blob_threshold_1) then
			-- the field strength, normalized to between 0 and 1
			local Strength_ratio = (Actual_strength - Blob_threshold_1)/(Blob_threshold_2 - Blob_threshold_1)
			local Random_ratio = Strength_ratio * srandom3(tSeed)
			-- points should be denser where the strength is greater
			if (Random_ratio > sqrt(srandom3(tSeed))) then
				-- the point's radius, points should be larger where the strength is greater
				local Radius_new = min(Point_maxradius * Random_ratio, Point_maxradius)

				-- scale all coordinates by this amount to make the blobs look flatter and better
				Vector_new = vmultiplyV(Vector_new, Blob_scale)

				-- make sure the asteroids are not too close to each other (TOO SLOW!!!)
				local Pass_bool = 1

				local Point_count_sub = 1
				while (Point_count_sub < Point_count) do
					local Vector_old = Point_list[Point_count_sub][1]
					local Radius_old = Point_list[Point_count_sub][2]
					local Distance = vdistance(Vector_old, Vector_new)
					local Radius_all = max(Radius_old, Radius_new, Point_padding)
					if (Distance <= Radius_all) then
						Pass_bool = 0
						break
					end
					Point_count_sub = Point_count_sub + 1
				end

				-- make sure no points are equal
--				local Point_count_sub = 1
--				while (Point_count_sub < Point_count) do
--					local Vector_old = Point_list[Point_count_sub][1]
--					if (veq(Vector_old, Vector_new) == 1) then
--						Pass_bool = 0
--						print("\tPoint_count = " .. Point_count .. "\n\tVector_old = " .. vstr(Vector_old) .. "\tPoint_count_sub = " .. Point_count_sub .. "\n\tVector_new = " .. vstr(Vector_new))
--						break
--					end
--					Point_count_sub = Point_count_sub + 1
--				end

				if (Pass_bool == 1) then
					-- the square roots here may not be necessary
					-- raising the threshold might achieve the same
					-- but the test map looks good with them
					if (Random_ratio <= sqrt(2/10)) then
						--appendShape(tPos, i, tPar, j, tCoo, tRot)
						--addAsteroid(<sAsteroidType>, <tPosition>, <fRU%>, ?, ?, ?, ?)
	--					appendShape(tPos, 1, {1, "Asteroid", "Asteroid_1", {0,0,0,}, 100, 0, 0, 0, 0,}, Point_count, Vector_new, tRot)
						appendShape(tPos, 1, {1, "Pebble", "Pebble_1", {0,0,0,}, 100, 0, 0, 0, 0,}, Point_count, Vector_new, tRot)
					elseif (Random_ratio <= sqrt(4/10)) then
						appendShape(tPos, 1, {1, "Asteroid", "Asteroid_2", {0,0,0,}, 100, 0, 0, 0, 0,}, Point_count, Vector_new, tRot)
					elseif (Random_ratio <= sqrt(6/10)) then
						appendShape(tPos, 1, {1, "Asteroid", "Asteroid_3", {0,0,0,}, 100, 0, 0, 0, 0,}, Point_count, Vector_new, tRot)
					elseif (Random_ratio <= sqrt(8/10)) then
						appendShape(tPos, 1, {1, "Asteroid", "Asteroid_4", {0,0,0,}, 100, 0, 0, 0, 0,}, Point_count, Vector_new, tRot)
					elseif (Random_ratio <= sqrt(10/10)) then
						appendShape(tPos, 1, {1, "Asteroid", "Asteroid_5", {0,0,0,}, 100, 0, 0, 0, 0,}, Point_count, Vector_new, tRot)
					end
					--print("Point_count = " .. Point_count .. "\nVector_new = " .. vstr(Vector_new))
					Point_list[Point_count] = {Vector_new, Radius_new}
					Point_count = Point_count + 1
				end
			end
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		fieldAdd
--  Description:	Similar to blobAdd, except it produces a heightmap based on the field strength instead of 3D blobs.
--  Syntax:		fieldAdd(<tPos>, <tRes>, {<tBlobs>, <fThrshMin>, <fThrshMax>, <fFieldSize>, <fStepHeight>,}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tRes>: a table containing the parameters of the outputted pebble or asteroid.
--	<tPar>: a table containing the following four parameters:
--		<tBlobs>: a table containing the location coordinates and strength of each blob.
--		<fThrshMin>: minimum threshold in units of field strength.
--		<fThrshMax>: maximum threshold in units of field strength.
--		<fFieldSize>: the size of the entire field in X, Y, Z dimensions.
--		<fStepHeight>: the height of one unit of field strength.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. The output looks kind of weird near the peaks of the functions 
--	   unless you use a large value for <fFieldSize>.
--	2. See Method 1 at: http://www.geogebra.org/en/upload/files/english/Michael_Horvath/Metaballs/geogebra_metaballs.htm
--------------------------------------------------------------------------------

function fieldAdd(tPos, tTab, tPar, tRot, xNil)
	local tBlobs = tPar[1]
	local Blob_threshold_1 = tPar[2]
	local Blob_threshold_2 = tPar[3]
	local field_size = tPar[4]
	local step_height = tPar[5]
	local jCount = 0
	local jMax = floor(sqrt(tTab[1]))
	local jStep = field_size/jMax
	for j = 0, jMax do
		for k = 0, jMax do
			-- generate a new point
			local Vector_new = {j * jStep - field_size/2, 0, k * jStep - field_size/2,}

			-- get the field strength at that point
			local Actual_strength = fieldCalc(tBlobs, Vector_new, Blob_threshold_1, Blob_threshold_2)

			Vector_new = {Vector_new[1], Actual_strength * step_height, Vector_new[3],}

			jCount = jCount + 1
			appendShape(tPos, i, tTab, jCount, Vector_new, tRot)
		end
	end
end

-- calculate the strength of an electromagnetic field at a given point
function fieldCalc(tBlobs, tVector, minThrsh, maxThrsh)
	-- get the field strength at that point
	local Actual_strength = 0
	for j, jBlob in tBlobs do
		local Blob_vector = jBlob[1]
		local Blob_radius = jBlob[2]
		Actual_strength = Actual_strength + Blob_radius / sqrt((tVector[1] - Blob_vector[1])^2 + (tVector[2] - Blob_vector[2])^2 + (tVector[3] - Blob_vector[3])^2)
	end
	return max(min(Actual_strength, maxThrsh), minThrsh)
end

--------------------------------------------------------------------------------
--  Name:		flokalAdd
--  Description:	Creates a kaleidoscopic bubble and swirl pattern kind of like a doily.
--  			Based on 'doodle 4' by bitcraft, http://www.openprocessing.org/sketch/17344 
--  Syntax:		flokalAdd(<tPos>, <tRes>, {<iNx>, <iNy>, <iXmin>, <iSx>, <iSy>, <iSym>, <fEcc>, <bInside>, <fScale>}, <tRot>, <xNil>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tRes>: a table containing the parameters of the outputted pebble or asteroid.
--	<tPar>: a table containing the following parameters:
--		<iNx>: the number of "horizontal" equipotential lines per charge, not taking into account iXmin.
--		<iNy>: the number of "vertical" flow lines per charge.
--		<iXmin>: size of the empty hole for each charge, measured in "horizontal" lines.
--		<iSx>: the number of extra items spaced between "horizontal" lines.
--		<iSy>: the number of extra items spaced between "vertical" lines.
--		<iSym>: number of charges arranged around the origin.
--		<fEcc>: the eccentricity of the shape, i.e. the amount the shape diverges from a circle.
--		<bInside>: are the curved lines inside or outside of the reference circle?
--		<fScale>: scale the whole shape by this amount in all directions.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<xNil>: this should always remain "nil".
--  Notes:
--	1. Not sure if <fEcc> has the same meaning as the eccentricity of an ellipse.
--------------------------------------------------------------------------------

function flokalAdd(tPos, tRes, tPar, tRot, xNil)
	local iNx = tPar[1];
	local iNy = tPar[2];
	local iXmin = tPar[3];
	local iSx = tPar[4];
	local iSy = tPar[5];
	local iSym = tPar[6];
	local fEcc = tPar[7];
	local bInside = tPar[8];
	local fScale = tPar[9];
	local pow = function(fA, fB)
		return fA^fB
	end
	local dist = function(fX1, fY1, fX2, fY2)
		return sqrt(%pow(fX2 - fX1, 2) + %pow(fY2 - fY1, 2))
	end
	local mag = function(fX, fY)
		return %dist(fX, fY, 0, 0)
	end
	local norm = function()
		local fY1 = 0;
		local fX1 = 0;
		local fX2 = exp(fX1) * cos(deg(fY1));
		local fY2 = exp(fX1) * sin(deg(fY1)) + %fEcc;
		local fD = 0;
		if (%bInside == 1) then
			fD = %pow(%mag(fX2, fY2),  1/%iSym);
		else
			fD = %pow(%mag(fX2, fY2), -1/%iSym);
		end
		local fArg = rad(atan2(fX2, fY2)) * -1/%iSym;
		local fX3 = fD * cos(deg(fArg))/TWO_PI;
		local fY3 = fD * sin(deg(fArg))/TWO_PI;
		return %mag(fX3, fY3)
	end

	-- calculate the distance from the origin to the center of each eye, then use it to normalize the shape to within 1 unit of the center
	local fNorm = norm();

	local fn = function(fX, fY)
		local aP = {};
		local fX1 = exp(fX) * cos(deg(fY));
		local fY1 = exp(fX) * sin(deg(fY)) + %fEcc;
		local fD = 0;
		if (%bInside == 1) then
			fD = %pow(%mag(fX1, fY1),  1/%iSym);
		else
			fD = %pow(%mag(fX1, fY1), -1/%iSym);
		end
		local fArg = rad(atan2(fX1, fY1)) * -1/%iSym;
		for i = 0, %iSym - 1 do
			local fX2 = fD * cos(deg(fArg + i * TWO_PI/%iSym))/TWO_PI;
			local fY2 = fD * sin(deg(fArg + i * TWO_PI/%iSym))/TWO_PI;
			aP[i + 1] = {fX2, fY2};
		end
		return aP
	end
	local lines = function(aP1, aP2)
		for i = 0, %iSym - 1 do
			local fX1 = aP1[i + 1][0 + 1];
			local fY1 = aP1[i + 1][1 + 1];
			local fX2 = aP2[i + 1][0 + 1];
			local fY2 = aP2[i + 1][1 + 1];
			local tCoo = {fX1 * %fScale/%fNorm, 0, fY1 * %fScale/%fNorm,}
			appendShape(%tPos, 1, %tRes, 0, tCoo, %tRot)
		end
	end

	-- for each vertical flowline
	for i = 0, iNy - 1 do
		local fY = i * TWO_PI/iNy;
		for j = iXmin * iSx, iNx * iSx - 1 do
			-- make sure we don't have overlapping objects
			if (mod(j, iSx) > 0) then
				local fX1 = j * TWO_PI/iNx/iSx;
				local fX2 = (j + 1) * TWO_PI/iNx/iSx;
				lines(fn(fX1, fY), fn(fX2, fY))
			end
		end
	end
	-- for each horizontal equipotential line
	for i = iXmin, iNx do
		local fX = i * TWO_PI/iNx;
		for j = 0, iNy * iSy - 1 do
			local fY1 = j * TWO_PI/iNy/iSy;
			local fY2 = (j + 1) * TWO_PI/iNy/iSy;
			lines(fn(fX, fY1), fn(fX, fY2))
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		ringAdd
--  Description:	Creates an elliptical ring centered on one focus.
--  Syntax:		ringAdd(<tPos>, <tDst>, {<fAx1>, <fAx2>, <fThk>, <fHgh>, <tArc>, <iMod>,}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following six parameters:
--		<fAx1>: the length of axis 1.
--		<fAx2>: the length of axis 2.
--		<fThk>: the distance from the outer radius to the inner radius (varies according to <iMod>).
--		<fHgh>: the height of the ring, relative to the plane.
--		<tArc>: a table containing the beginning and ending degrees of the arc.
--		<iMod>: if 0, then non-random mode. If 1, then random mode w/ gradual width. If 2, then random mode w/ even width.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. Should maybe add an option to center the shape on the origin instead of only the foci.
--------------------------------------------------------------------------------

function ringAdd(tPos, tDst, tPar, tRot, tSeed)
	local fAx1, fAx2, fThk, fHgh, tArc, iMod = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5], tPar[6]
	local fFoc = sqrt(abs(fAx1^2 - fAx2^2))
	local tCoo, minArc, maxArc = {}, tArc[1], tArc[2]
	for i, tTab in tDst do
		local u, w, h, arc, iNum = 0, 0, 0, 0, tTab[1]
		for j = 1, iNum do
			if (iMod == 2) then
				u = srandom3(tSeed, minArc, maxArc)
				tCoo =
				{
					cos(u) * fAx2 - srandom3(tSeed, fThk),
					random3(fHgh) - fHgh/2,
					sin(u) * fAx1 - srandom3(tSeed, fThk),
				}
			elseif (iMod == 1) then
				u = srandom3(tSeed, minArc, maxArc)
				tCoo =
				{
					cos(u) * (fAx2 - srandom3(tSeed, fThk)),
					srandom3(tSeed, fHgh) - fHgh/2,
					sin(u) * sqrt((fAx2 - srandom3(tSeed, fThk))^2 - fAx2^2 + fAx1^2),
				}
			elseif (iMod == 0) then
				u = minArc + arc
				tCoo =
				{
					cos(u) * (fAx2 + fThk/-2 + w),
					fHgh/-2 + h,
					sin(u) * (fAx1 + fThk/-2 + w),
				}
				arc, w, h = arc + (maxArc - minArc)/iNum, w + fThk/iNum, h + fHgh/iNum
			end
			tCoo = vaddV(tCoo, {0,0,fFoc,})
			appendShape(tPos, i, tTab, j, tCoo, tRot)
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		globeAdd
--  Description:	Creates a series of rings in the shape of a sphere, like the latitudinal and longitudinal lines of a globe.
--  Syntax:		globeAdd(<tPos>, <tDst>, {<fRad>, <iLat>, <iLon>, <fThk>, <fHgh>, <tArc>, <iMod>,}, <xNil>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tPar>: a table containing the following seven parameters:
--		<fRad>: the radius of the sphere.
--		<iLat>: the number of latitudinal rings.
--		<iLon>: the number of longitudinal rings.
--		<fThk>: see the description for the "ringAdd" function.
--		<fHgh>: see the description for the "ringAdd" function.
--		<tArc>: see the description for the "ringAdd" function.
--		<iMod>: see the description for the "ringAdd" function.
--	<xNil>: this argument is ignored and is used only to adhere to the API.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--  	1. Beware that objects may overlap where the longitudinal rings intersect at the poles.
--	2. Need to get <tRot> working for this function.
--------------------------------------------------------------------------------

function globeAdd(tPos, tDst, tPar, xNil, tSeed)
	local lat, lon, u, X, Y = 0, 0, 0, 0, 0
	local fRad, iLat, iLon, fThk, fHgh, tArc, iMod = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5], tPar[6], tPar[7]
	for i = 1, iLat do
		lat = lat + 360/(iLat * 2 + 2)
		u = lat
		X, Y = cos(u) * fRad, sin(u) * fRad
		-- ringAdd(<tPos>, <tDst>, {<fAx1>, <fAx2>, <fThk>, <fHgh>, <tArc>, <iMod>,}, <tRot>, <tSeed>)
		ringAdd(vaddV(tPos, {0, X, 0,}), tDst, {Y, Y, fThk, fHgh, tArc, iMod,}, {0, 0, 0,}, tSeed)
	end
	for i = 1, iLon do
		lon = lon + 360/iLon
		-- ringAdd(<tPos>, <tDst>, {<fAx1>, <fAx2>, <fThk>, <fHgh>, <tArc>, <iMod>,}, <tRot>, <tSeed>)
		ringAdd(tPos, tDst, {fRad, fRad, fThk, fHgh, tArc, iMod,}, {0, lon, 90,}, tSeed)
	end
end


--------------------------------------------------------------------------------
--  Name:		shapeAdd
--  Description:	Creates one of several available shapes.
--  Syntax:		shapeAdd(<tPos>, <tDst>, {<sLay>, ...}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing up to several parameters: <sLay> and <fA>, <fB>, ..., etc.
--		<sLay>: the type of shape to generate.
--		If <sLay> is "Cylinder", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Cone", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Ellipsoid", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Cuboid", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Toroid", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the width of the tube, <fD> equals the thickness, and <fE> equals the height of the tube.
--		If <sLay> is "Helicoid", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, and <fD> equals the width (thickness is not supported), <fE> is the number of revolutions.
--		If <sLay> is "Paraboloid", then <fA> equals the length of axis 1 at a height of 1000 units, <fB> equals the length of axis 2 at a height of 1000 units, <fC> equals the length of axis 3, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Hyperboloid", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Astroid", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Funnel", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals roughly the inverse of the length of axis 3 for large numbers of objects, <fD> equals the thickness, and <fE> is zero.
--		If <sLay> is "Dini", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the distance between each twist, <fD> is zero, and <fE> is the number of twists.
--		If <sLay> is "Corkscrew", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the height of the screw, <fD> is zero, and <fE> is zero.
--		If <sLay> is "Seashell", then <fA> equals the length of axis 1 of the tube, <fB> equals the length of axis 2 of the tube, <fC> equals the vertical separation between revolutions, <fD> equals the radius of the center gap, and <fE> equals the number of revolutions.
--		If <sLay> is "SineDisc", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the maximum height of the wave, <fD> zero, and <fE> equals the frequency of the wave pattern.
--		If <sLay> is "SinePlane", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the maximum height of the wave, <fD> zero, and <fE> equals the frequency of the wave pattern.
--		If <sLay> is "Moebius", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals half the width of the strip, <fD> is zero, and <fE> is zero.
--		If <sLay> is "Klein", then <fA> equals the scaling along the x-axis, <fB> equals the scaling along the z-axis, <fC> equals the scaling along the y-axis, <fD> is zero, and <fE> is zero.
--		If <sLay> is "Klein8", then <fA> equals the scaling along the x-axis, <fB> equals the scaling along the z-axis, <fC> equals the scaling along the y-axis, <fD> is zero, and <fE> is the radius of the circle before scaling.
--		If <sLay> is "Boy", then <fA> equals the scaling along the x-axis, <fB> equals the scaling along the z-axis, <fC> equals the scaling along the y-axis.
--		If <sLay> is "Rectangle", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, and <fD> equals the thickness.
--		If <sLay> is "Ellipse", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the length of axis 3, and <fD> equals the thickness.
--		If <sLay> is "Triangle", [...to do.]
--		If <sLay> is "Parabola", then <fA> equals the distance between the vertex and the focus, <fB> equals the length, <fC> equals the height, and <fD> equals the thickness.
--		If <sLay> is "Hyperbola", then <fA> equals the length of axis 1, <fB> equals the length of axis 2, <fC> equals the distance from the origin to one of the foci, <fD> equals the thickness.
--		If <sLay> is "Catenary", [...to do.]
--		If <sLay> is "Hypotrochoid", then <fA> equals the radius of the greater circle, <fB> equals the radius of the lesser circle, <fC> equals the radius of the sphere sweep, <fD> equals the distance from the center of the lesser circle, and <fE> equals the number of revolutions.
--		If <sLay> is "Epitrochoid", then <fA> equals the radius of the greater circle, <fB> equals the radius of the lesser circle, <fC> equals the radius of the sphere sweep, <fD> equals the distance from the center of the lesser circle, and <fE> equals the number of revolutions.
--	<tRot>: a table containing the X, Y and Z Euler rotation angles, in degrees, for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. Should be able to plot non-random points as well as random ones. Lots of extra work though.
--------------------------------------------------------------------------------

function shapeAdd(tPos, tDst, tPar, tRot, tSeed)
	local sLay = tPar[1]
	for i, tTab in tDst do
		for j = 1, tTab[1] do
			local tCoo = {}
			if (sLay == "Cuboid") then
				tCoo = makeCuboid(tPar, tSeed)
			elseif (sLay == "Ellipsoid") then
				tCoo = makeEllipsoid(tPar, tSeed)
			elseif (sLay == "Cylinder") then
				tCoo = makeCylinder(tPar, tSeed)
			elseif (sLay == "Cone") then
				tCoo = makeCone(tPar, tSeed)
			elseif (sLay == "Toroid") then
				tCoo = makeToroid(tPar, tSeed)
			elseif (sLay == "Helicoid") then
				tCoo = makeHelicoid(tPar, tSeed)
			elseif (sLay == "Paraboloid") then
				tCoo = makeParaboloid(tPar, tSeed)
			elseif (sLay == "Hyperboloid") then
				tCoo = makeHyperboloid(tPar, tSeed)
			elseif (sLay == "Astroid") then
				tCoo = makeAstroid(tPar, tSeed)
			elseif (sLay == "Funnel") then
				tCoo = makeFunnel(tPar, tSeed)
			elseif (sLay == "Dini") then
				tCoo = makeDini(tPar, tSeed)
			elseif (sLay == "Corkscrew") then
				tCoo = makeCorkscrew(tPar, tSeed)
			elseif (sLay == "Seashell") then
				tCoo = makeSeashell(tPar, tSeed)
			elseif (sLay == "SineDisc") then
				tCoo = makeSineDisc(tPar, tSeed)
			elseif (sLay == "SinePlane") then
				tCoo = makeSinePlane(tPar, tSeed)
			elseif (sLay == "Moebius") then
				tCoo = makeMoebius(tPar, tSeed)
			elseif (sLay == "Klein") then
				tCoo = makeKlein(tPar, tSeed)
			elseif (sLay == "Klein8") then
				tCoo = makeKlein8(tPar, tSeed)
			elseif (sLay == "Kuen") then
				tCoo = makeKuen(tPar, tSeed)
			elseif (sLay == "Boy") then
				tCoo = makeBoy(tPar, tSeed)
			elseif (sLay == "Rectangle") then
				tCoo = makeRectangle(tPar, tSeed)
			elseif (sLay == "Ellipse") then
				tCoo = makeEllipse(tPar, tSeed)
			--elseif (sLay == "Triangle") then
				-- to do
			elseif (sLay == "Parabola") then
				tCoo = makeParabola(tPar, tSeed)
			elseif (sLay == "Hyperbola") then
				tCoo = makeHyperbola(tPar, tSeed)
			--elseif (sLay == "Catenary") then
				-- to do
			elseif (sLay == "Hypotrochoid") then
				tCoo = makeHypotrochoid(tPar, tSeed)
			elseif (sLay == "Epitrochoid") then
				tCoo = makeEpitrochoid(tPar, tSeed)
			else
				print("function shapeAdd: shape not recognized")
			end
			appendShape(tPos, i, tTab, j, tCoo, tRot)
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		harmonographAdd
--  Description:	Creates a squiggly curving tube. The shape is similar to that produced by a harmonograph, except in three dimensions.
--			See for more info: http://en.wikipedia.org/wiki/Harmonograph
--  Syntax:		harmonographAdd(<tPos>, <tDst>, {{<fA>, <fF>, <fP>, <fD>}, <tGrp2>, <tGrp3>, <tGrp4>, <tGrp5>, <tGrp6>, <fTim>, <fRad>, <fThk>, <tScale>, <iMod>}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following seven parameters:
--		<tGrp1>: a table containing the following four parameters:
--			<fA>: amplitude.
--			<fF>: frequency (degrees).
--			<fP>: phase (degrees).
--			<fD>: damping.
--		<fGrp2>: ditto.
--		<fGrp3>: ditto.
--		<fGrp4>: ditto.
--		<fGrp5>: ditto.
--		<tGrp6>: ditto.
--		<fTim>: the time parameter.
--		<fRad>: the radius of the curving tube.
--		<fThk>: the thickness of the tube as a percentage of the radius.
--		<tScale>: scale the entire shape by this much.
--		<iMod>: 0 = non-random, 1 = random.
--	<tRot>: a table containing the X, Y and Z Euler rotation angles, in degrees, for the entire object.
--	<tSeed>: the seed for the random number functions.
--------------------------------------------------------------------------------

function harmonographAdd(tPos, tDst, tPar, tRot, tSeed)
	local grp1, grp2, grp3, grp4, grp5, grp6 = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5], tPar[6]
	local fTime, fRadius, fThick, tScale, iMod = rad(tPar[7]), tPar[8], tPar[9]/100, tPar[10], tPar[11]
	local A1, F1, P1, D1 = grp1[1], grp1[2], grp1[3], grp1[4]
	local A2, F2, P2, D2 = grp2[1], grp2[2], grp2[3], grp2[4]
	local A3, F3, P3, D3 = grp3[1], grp3[2], grp3[3], grp3[4]
	local A4, F4, P4, D4 = grp4[1], grp4[2], grp4[3], grp4[4]
	local A5, F5, P5, D5 = grp5[1], grp5[2], grp5[3], grp5[4]
	local A6, F6, P6, D6 = grp6[1], grp6[2], grp6[3], grp6[4]
	print
	(
		"\n{A1 = " .. A1 .. ",\tF1 = " .. F1 .. ",\tP1 = " .. P1 .. ",\tD1 = " .. D1 .. "}," ..
		"\n{A2 = " .. A2 .. ",\tF2 = " .. F2 .. ",\tP2 = " .. P2 .. ",\tD2 = " .. D2 .. "}," ..
		"\n{A3 = " .. A3 .. ",\tF3 = " .. F3 .. ",\tP3 = " .. P3 .. ",\tD3 = " .. D3 .. "}," ..
		"\n{A4 = " .. A4 .. ",\tF4 = " .. F4 .. ",\tP4 = " .. P4 .. ",\tD4 = " .. D4 .. "}," ..
		"\n{A5 = " .. A5 .. ",\tF5 = " .. F5 .. ",\tP5 = " .. P5 .. ",\tD5 = " .. D5 .. "}," ..
		"\n{A6 = " .. A6 .. ",\tF6 = " .. F6 .. ",\tP6 = " .. P6 .. ",\tD6 = " .. D6 .. "},"
	)
	for i, tTab in tDst do
		local jNum = tTab[1]
		local t, u, r = 0, 0, 0
		local tReg, uReg = 0, 0
		local tDif, uDif = fTime/jNum, 360/jNum
		for j = 1, jNum do
			if (iMod == 1) then
				t, u = srandomSet(tSeed,fTime,360)
				r = fRadius * fThick * sqrt(srandom(tSeed)) + fRadius * (1 - fThick)
			else
				t, u, r = tReg, uReg, fRadius
			end
			local tCirc =
			{
				r * cos(u),
				r * sin(u),
				0,
			}
			local tCoo = 
			{
				A1 * sin(deg(t) * F1 + P1) * exp(-D1 * t) + A2 * sin(deg(t) * F2 + P2) * exp(-D2 * t),
				A3 * sin(deg(t) * F3 + P3) * exp(-D3 * t) + A4 * sin(deg(t) * F4 + P4) * exp(-D4 * t),
				A5 * sin(deg(t) * F5 + P5) * exp(-D5 * t) + A6 * sin(deg(t) * F6 + P6) * exp(-D6 * t),
			}
			tCoo = vmultiplyV(tCoo, tScale)
			local tDerivatives =
			{
				A1 * -D1 * exp(-D1 * t) * sin(deg(t) * F1 + P1) + A1 * F1 * exp(-D1 * t) * cos(deg(t) * F1 + P1)	+ A2 * -D2 * exp(-D2 * t) * sin(deg(t) * F2 + P2) + A2 * F2 * exp(-D2 * t) * cos(deg(t) * F2 + P2),
				A3 * -D3 * exp(-D3 * t) * sin(deg(t) * F3 + P3) + A3 * F3 * exp(-D3 * t) * cos(deg(t) * F3 + P3)	+ A4 * -D4 * exp(-D4 * t) * sin(deg(t) * F4 + P4) + A4 * F4 * exp(-D4 * t) * cos(deg(t) * F4 + P4),
				A5 * -D5 * exp(-D5 * t) * sin(deg(t) * F5 + P5) + A5 * F5 * exp(-D5 * t) * cos(deg(t) * F5 + P5)	+ A6 * -D6 * exp(-D6 * t) * sin(deg(t) * F6 + P6) + A6 * F6 * exp(-D6 * t) * cos(deg(t) * F6 + P6),
			}
			tDerivatives = vmultiplyV(tDerivatives, tScale)
			local tNormedPos = vrotate(tCirc, vanglesXY(tDerivatives))
			tCoo = vaddV(tCoo, tNormedPos)
			tReg = tReg + tDif
			uReg = uReg + uDif
			appendShape(tPos, i, tTab, j, tCoo, tRot)
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		heightmapAdd
--  Description:	Creates a matrix of dots based on heightmap data.
--  Syntax:		heightmapAdd(<tPos>, <tRes>, {<tData>, <tScale>}, <tRot>, <xNil>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tRes>: a table containing the parameters of the outputted pebble or asteroid.
--	<tPar>: a table containing the following five parameters:
--		<tData>: the heightmap data in the form of a two-dimensional array.
--		<tScale>: the amount to scale the heightmap in the X, Y and Z directions.
--	<tRot>: a table containing the X, Y and Z Euler rotation angles, in degrees, for the entire object.
--	<xNil>: this should always remain "nil". It is ignored and used only to adhere to the API.
--  Notes:
--	1. I used the included "pgm_to_array_converter.html" tool to convert 
--	   from PGM to a Lua table. PGM images can be read and written using 
--	   the Windows freeware program XnView. Make sure to set the output to 
--	   ASCII in the XnView options.
--------------------------------------------------------------------------------

function heightmapAdd(tPos, tRes, tPar, tRot, xNil)
	local tData, tScale = tPar[1], tPar[2]
	local iLen = getn(tData)
	for i, iCount in tData do
		local jLen = getn(iCount)
		for j, jCount in iCount do
			local tCoo = {i - iLen/2, jCount, j - jLen/2}
			tCoo = vmultiplyV(tCoo, tScale)
			appendShape(tPos, i, tRes, j, tCoo, tRot)
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		strangeAdd
--  Description:	Creates a strange attractor, such as the Clifford or Lorenz attractors.
--			See for more info: http://www.aidansamuel.com/strange.php
--  Syntax:		strangeAdd(<tPos>, <tDst>, {<fA>, <fB>, <fC>, <fD>, <fScale>}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following five parameters:
--		<fA>: an arbitrary constant that partially determines the end result.
--		<fB>: ditto.
--		<fC>: ditto.
--		<fD>: ditto.
--		<fScale>: the rough size or scale of the curve.
--	<tRot>: a table containing the X, Y and Z Euler rotation angles, in degrees, for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. Would like the function to generate spirals with three or five arms instead of always just four.
--------------------------------------------------------------------------------

function strangeAdd(tPos, tDst, tPar, tRot, tSeed)
	local a, b, c, d, scale = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5]
	print("{" .. a .. "," .. b .. "," .. c .. "," .. d .. "," .. scale .. ",}")
	local minBox = {0,0,0,}
	local maxBox = {0,0,0,}
	-- determine the bounding box so that you can then center the shape on the origin
	for i, tTab in tDst do
		local x, y, z = 0, 0, 0
		for j = 1, tTab[1] do
			local ptX = sin(deg(a * y)) - z * cos(deg(b * x))
			local ptY = z * sin(deg(c * x)) - cos(deg(d * y))
			local ptZ = sin(deg(x))
			if (i == 1) and (j == 1) then
				minBox = {ptX,ptY,ptZ,}
				maxBox = {ptX,ptY,ptZ,}
			else
				minBox = {min(minBox[1], ptX), min(minBox[2], ptY), min(minBox[3], ptZ),}
				maxBox = {max(maxBox[1], ptX), max(maxBox[2], ptY), max(maxBox[3], ptZ),}
			end
			x = ptX
			y = ptY
			z = ptZ
		end
	end
	local midBox = {(minBox[1] + maxBox[1])/2, (minBox[2] + maxBox[2])/2, (minBox[3] + maxBox[3])/2,}
	--print("minBox = " .. vstr(vmultiply(minBox, scale)))
	--print("maxBox = " .. vstr(vmultiply(maxBox, scale)))
	print("midBox = " .. vstr(vmultiply(midBox, scale)))
	for i, tTab in tDst do
		local x, y, z = 0, 0, 0
		for j = 1, tTab[1] do
			local ptX = sin(deg(a * y)) - z * cos(deg(b * x))
			local ptY = z * sin(deg(c * x)) - cos(deg(d * y))
			local ptZ = sin(deg(x))
			local tCoo = 
			{
				(ptX - midBox[1]) * scale,
				(ptY - midBox[2]) * scale,
				(ptZ - midBox[3]) * scale,
			}
			--print("tCoo = " .. vstr(tCoo))
			appendShape(tPos, i, tTab, j, tCoo, tRot)
			x = ptX
			y = ptY
			z = ptZ
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		spiralAdd
--  Description:	Creates a spiral.
--  Syntax:		spiralAdd(<tPos>, <tDst>, {<sLay>, <fRad>, <iArm>, <fRot>, <fAng>, <fHgh>, <fWid>, <fThk>, <tTim>, <iMod>,}, <tRot>, <tSeed>)
--  Arguments:
--	<tPos>: a table containing the shape's center coordinates.
--	<tDst>: the distribution table used to populate the shape.
--	<tPar>: a table containing the following ten parameters:
--		<sLay>: may be either "Nautilus" or "Archimedes".
--		<fRad>: depending on <fAng>, this is either the minimum or maximum radius of the spiral.
--		<iArm>: the number of arms the spiral will have.
--		<fRot>: the number of times the spiral will rotate around the origin.
--		<fAng>: the angle (degrees) of deviation (90' and 270' make a circle).
--		<fHgh>: the height of the spiral above the plane.
--		<fWid>: the width of the spiral arms.
--		<fThk>: the thickness of the spiral arms.
--		<tTim>: a table containing the minimum and maximum values for "t" (time) at which the curve is sampled. (must be a float between 0 and 1)
--		<iMod>: 0 is non-random, 1 is random, 2 is random-mode with tapering width.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. Would be nice to also have tubular cross-sections instead of only rectangular.
--------------------------------------------------------------------------------

function spiralAdd(tPos, tDst, tPar, tRot, tSeed)
	local sLay, nRad, nArm, nRot, nAng, nHgh, nWid, nThk, tTim, iMod = tPar[1], tPar[2], tPar[3], tPar[4], tPar[5], tPar[6], tPar[7], tPar[8], tPar[9], tPar[10]
	local minTim, maxTim, v, t, s, l, w, h = tTim[1], tTim[2], 360 * nRot, 0, 0, 0, 0, 0
	local rotArm = 0
	local divArm = (360/nArm)
	for k = 1, nArm do
		for i, tTab in tDst do
			local t_X, l_X, w_X, h_X = minTim, nWid/-2, nWid/-2, nThk/-2
			local iNum = tTab[1]
			for j = 1, iNum do
				local tCoo = {}
				if (iMod == 1) then
					v, t = v, srandom3(tSeed, minTim, maxTim)
					s = t
					if (sLay == "Archimedes") then
					--	s = 1 - t
					end
					l, w, h = srandom3(tSeed, nWid) - nWid/2, srandom3(tSeed, nWid) - nWid/2, srandom3(tSeed, nThk) - nThk/2
				elseif (iMod == 2) then
					v, t = v, srandom3(tSeed, minTim, maxTim)
					s = t
					if (sLay == "Archimedes") then
					--	s = 1 - t
					end
					l, w, h = srandom3(tSeed, 0, nWid * s), srandom3(tSeed, 0, nWid * s), srandom3(tSeed, nThk) - nThk/2
				elseif (iMod == 0) then
					v, t = v, t_X
					l, w, h = l_X, w_X, h_X
					t_X = t_X + (maxTim - minTim)/iNum
					l_X, w_X, h_X = l_X + nWid/iNum, w_X + nWid/iNum, h_X + nThk/iNum
				end
				if (sLay == "Nautilus") then
					tCoo =
					{
						exp(rad(v * t)/tan(nAng)) * cos(v * t) * nRad + l,
						h - nHgh * t + nHgh/2,
						exp(rad(v * t)/tan(nAng)) * sin(v * t) * nRad + w,
					}
				elseif (sLay == "Archimedes") then
					tCoo =
					{
						cos(v * t) * t * nRad + l,
						h + nHgh * t - nHgh/2,
						sin(v * t) * t * nRad + w,
					}
				end
				appendShape(tPos, i, tTab, j, vrotate(tCoo, {0,rotArm,0,}), tRot)
			end
		end
		rotArm = rotArm + divArm
	end
end


--------------------------------------------------------------------------------
--  Name:		stitchAdd
--  Description:	Generates a triangle made of crosshatched line segments, like in the art of curvestitching.
--  Syntax:		stitchAdd(<tPos>, <tRes>, {<tPtA>, <tPtB>, <tPtC>, <iNum>, <bAll>, <bCorners>}, <tRot>, <xNil>)
--  Inputs:
--	<tPos>: the center of the shape.
--	<tRes>: a table containing the parameters of the outputted pebble or asteroid.
--	<tPar>: a table containing the following parameters:
--		<tPtA>: a table containing the X, Y and Z coordinates of a point on the triangle.
--		<tPtB>: a table containing the X, Y and Z coordinates of a point on the triangle.
--		<tPtC>: a table containing the X, Y and Z coordinates of the center point on the triangle.
--		<iNum>: the number of line segments to generate.
--		<bAll>: turn this off to generate only the points on the spline defined by the line segments.
--		<bCorners>: enables/disables generation of points at the corners of the triangle to prevent duplicate overlapping asteroids.
--	<tRot>: a table containing the X, Y and Z rotation angles (degrees) for the entire object.
--	<xNil>: this should always remain "nil". It is ignored and used only to adhere to the API.
--  Notes:
--	1. Not sure I completely fixed the overlapping objects at the cornes and edges.
--------------------------------------------------------------------------------

function stitchAdd(tPos, tRes, tPar, tRot, xNil)
	local Point_A, Point_B, Point_C = tPar[1], tPar[2], tPar[3]
	local n, All, Corners = tPar[4], tPar[5], tPar[6]
	local iCount = 0
	if (All == 1) then
		local Start = 1
		local End = n - 1
		if (Corners == 1) then
			Start = 0
			End = n
		end
		for i = Start, End do
			for j = Corners and 0 or 1, Corners and n or n - 1 do
				local tCoo =
				{
					i * j/n^2 * Point_A[1] + (n - i) * (n - j)/n^2 * Point_C[1] + (i * (n - j) + j * (n - i))/n^2 * Point_B[1],
					i * j/n^2 * Point_A[2] + (n - i) * (n - j)/n^2 * Point_C[2] + (i * (n - j) + j * (n - i))/n^2 * Point_B[2],
					i * j/n^2 * Point_A[3] + (n - i) * (n - j)/n^2 * Point_C[3] + (i * (n - j) + j * (n - i))/n^2 * Point_B[3],
				}
				iCount = iCount + 1
				appendShape(tPos, 1, tRes, iCount, tCoo, tRot)
			end
		end
	else
		local Start = 1/n
		local End = (1 - 1/n)
		if (Corners == 1) then
			Start = 0
			End = 1
		end
		for i = Start, End, 1/n do
			local tCoo =
			{
				(1 - i)^2 * Point_A[1] + 2 * (1 - i) * i * Point_C[1] + i^2 * Point_B[1],
				(1 - i)^2 * Point_A[2] + 2 * (1 - i) * i * Point_C[2] + i^2 * Point_B[2],
				(1 - i)^2 * Point_A[3] + 2 * (1 - i) * i * Point_C[3] + i^2 * Point_B[3],
			}
			iCount = iCount + 1
			appendShape(tPos, 1, tRes, iCount, tCoo, tRot)
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		literalAdd
--  Description:	Adds the contents of a distribution table to the map without changing any values.
--  Syntax:		literalAdd(<tDst>)
--  Arguments:
--	<tDst>: the distribution table used to populate the shape.
--------------------------------------------------------------------------------

function literalAdd(tDst)
	for i, tTab in tDst do
		for j = 1, tTab[1] do
			appendShape({0, 0, 0,}, i, tTab, j, {0, 0, 0,}, {0, 0, 0,})
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		easyPatch
--  Description:	Creates a resource patch with minimal effort.
--  Syntax:		easyPatch(<tPos>, <fRUs>, <tSeed>)
--  Arguments:
--	<tPos>: the shape's center coordinates.
--	<fRUs>: the percent of the default RU to retain.
--	<tSeed>: the seed for the random number functions.
--  Notes:
--	1. Need to consider once again whether <fRUs> and <tSeed> should be optional.
--------------------------------------------------------------------------------

function easyPatch(tPos, fRUs, tSeed)
	if not (fRUs) then
		fRUs = 100
	end
	if not (tSeed) then
		tSeed = {seed = 977322}
	end
	local tCoo = {}
	-- asteroid_type = {amount, inner radius, outer radius,}
	local easyPatchDist = {Asteroid_4 = {1, 0, 0,}, Asteroid_3 = {4, 400, 800,}, Asteroid_2 = {5, 800, 1600,},}
	for k, tTab in easyPatchDist do
		for j = 1, tTab[1] do
			local r = srandom3(tSeed, tTab[2], tTab[3])
			local v, u = srandomSet(tSeed, 180,360)
			tCoo =
			{
				tPos[1] + sqrt(r^2 - (r * cos(v))^2) * cos(u),
				tPos[2] + r * cos(v),
				tPos[3] + sqrt(r^2 - (r * cos(v))^2) * sin(u),
			}
			addAsteroid(k, tCoo, fRUs, 0, 0, 0, 0)
		end
	end
end


--------------------------------------------------------------------------------
--  Name:		randomMusic
--  Description:	Randomly selects the level music.
--  Syntax:		randomMusic(<tSeed>, <iMod>, <tTab>, <sDir>)
--  Arguments:
--	<tSeed>: the seed for the random number functions.
--	<iMod>: may be 0, 1, 2, 3, 4 or 5.
--	If <iMod> is 0, then this function is disabled.
--	If <iMod> is 1, then the level music is selected from only the ambient tracks.
--	If <iMod> is 2, then the level music is selected from only the battle tracks.
--	If <iMod> is 3, then the level music is selected from both the ambient and battle tracks.
--	If <iMod> is 4, then the level music is selected from only <tTab>.
--	If <iMod> is 5, then the level music is selected from all of the above.
--	<tTab>: (optional) a table containing the names of the custom audio tracks. (table)
--	<sDir>: (optional) the directory where the extra files can be found. Must have a trailing slash. (string)
--  Notes:
--	1. This function must be called from within the "NonDetermChunk" 
--	   portion of a ".level" file.
--	2. Since it is a NonDetermChunk function, it does not need to be seeded 
--	   manually in order to avoid desyncs (I think).
--------------------------------------------------------------------------------

function randomMusic(tSeed, iMod, tTab, sDir)
	local iTot = 23
	local iLen = 0
	if (tTab) then
		iLen = getn(tTab)
		iTot = iTot + iLen
	end
	local ranNum, musDir, musTrk = 0, "", ""
	local musTab =
	{
		"amb_01", "amb_02", "amb_03", "amb_04", "amb_05", "amb_06", "amb_07", "amb_08", "amb_09", "amb_10", "amb_11", "amb_12", "amb_13", "amb_14",
		"battle_01", "battle_04", "battle_04_alt", "battle_06", "battle_keeper", "battle_movers", "battle_planetkillers", "battle_sajuuk", "bentus_arrival",
	}
	if ((iMod == 4) or (iMod == 5)) then
		for k = 1, iLen do
			musTab[k + 23] = tTab[k]
		end
	end
	if (iMod == 1) then
		ranNum = srandom(tSeed, 1, 14)
	elseif (iMod == 2) then
		ranNum = srandom(tSeed, 15, 23)
	elseif (iMod == 3) then
		ranNum = srandom(tSeed, 1, 23)
	elseif (iMod == 4) then
		ranNum = srandom(tSeed, 24, 23 + iLen)
	elseif (iMod == 5) then
		ranNum = srandom(tSeed, 1, 23 + iLen)
	end
	if (ranNum <= 14) then
		musDir = "data:sound\\music\\ambient\\"
	elseif (ranNum <= 23) then
		musDir = "data:sound\\music\\battle\\"
	elseif (ranNum <= (23 + iLen)) then
		musDir = sDir
	end
	if (iMod ~= 0) then
		setDefaultMusic(musDir .. musTab[ranNum])
		print("Level music: \"" .. musTab[ranNum] .. "\" (" .. ranNum .. "/" .. iTot .. ")")
	end
end


--------------------------------------------------------------------------------
--  Name:		randomBackground
--  Description:	Randomly selects the level background.
--  Syntax:		randomBackground(<tSeed>, <iMod>, <tTab>)
--  Arguments:
--	<tSeed>: the seed for the random number functions.
--	<iMod>: may be 0, 1, 2, 3, 4 or 5.
--	If <iMod> is 0, then this function has been disabled.
--	If <iMod> is 1, then the level background is selected from only the mission backgrounds.
--	If <iMod> is 2, then the level background is selected from only the other backgrounds.
--	If <iMod> is 3, then the level background is selected from both the mission and other backgrounds.
--	If <iMod> is 4, then the level background is selected from only <tTab>.
--	If <iMod> is 5, then the level background is selected from all of the above.
--	<tTab>: (optional) a table containing the names of the custom backgrounds.
--  Notes:
--	1. This function must be called from within the "NonDetermChunk" 
--	   portion of a ".level" file.
--	2. Since it is a NonDetermChunk function, it does not need to be seeded 
--         manually in order to avoid desyncs (I think).
--------------------------------------------------------------------------------

function randomBackground(tSeed, iMod, tTab)
	local iTot = 22
	local iLen = 0
	if (tTab) then
		iLen = getn(tTab)
		iTot = iTot + iLen
	end
	local ranNum = 0
	local backgroundTable =
	{
		"m01", "m02", "m03", "m04", "m05", "m06", "m07", "m08", "m09", "m10", "m11", "m12", "m13", "m14", "m15",
		"planet", "quick", "singlesun", "tanis", "taniswstars", "black", "white",
	}
	if ((iMod == 4) or (iMod == 5)) then
		for k = 1, iLen do
			backgroundTable[k + 22] = tTab[k]
		end
	end
	if (iMod == 1) then
		ranNum = srandom(tSeed, 1, 15)
	elseif (iMod == 2) then
		ranNum = srandom(tSeed, 16, 22)
	elseif (iMod == 3) then
		ranNum = srandom(tSeed, 1, 22)
	elseif (iMod == 4) then
		ranNum = srandom(tSeed, 23, 22 + iLen)
	elseif (iMod == 5) then
		ranNum = srandom(tSeed, 1, 23 + iLen)
	end
	if (iMod ~= 0) then
		loadBackground(backgroundTable[ranNum])
		print("Level background: \"" .. backgroundTable[ranNum] .. "\" (" .. ranNum .. "/" .. iTot .. ")")
	end
end


--------------------------------------------------------------------------------
-- Random number functions.
--

-- Randomly returns either 1 or -1.
function randomSign()
	if (random() > 0.5) then
		return 1
	else
		return -1
	end
end

-- Randomly returns either 1 or 0.
function randomBit()
	if (random() > 0.5) then
		return 1
	else
		return 0
	end
end

-- Works just like random(), but can accept zero as an argument.
function random2(fVal1, fVal2)
	if (fVal2) then
		if ((fVal2 - fVal1) == 0) then
			return fVal2
		else
			return random(fVal1, fVal2)
		end
	elseif (fVal1) then
		if (fVal1 == 0) then
			return 0
		else
			return random(fVal1)
		end
	else
		return random()
	end
end

-- Works just like random(), but can accept zero as an argument and always returns a float value, not an integer.
function random3(fVal1, fVal2)
	if (fVal2) then
		return fVal1 + random() * (fVal2 - fVal1)
	elseif (fVal1) then
		return random() * fVal1
	else
		return random()
	end
end

-- For each argument, returns a random float value between 0 and the argument.
function randomSet(...)
	local v = {}
	for i = 1, getn(arg) do
		v[i] = random3(arg[i])
	end
	if arg[5] then
		return v[1], v[2], v[3], v[4], v[5]
	elseif arg[4] then
		return v[1], v[2], v[3], v[4]
	elseif arg[3] then
		return v[1], v[2], v[3]
	elseif arg[2] then
		return v[1], v[2]
	elseif arg[1] then
		return v[1]
	end
end

-- For every two arguments, returns a random float value between the former argument and the latter argument.
function randomSet2(...)
	local v = {}
	for i = 2, getn(arg), 2 do
		v[i/2] = random3(arg[i-1], arg[i])
	end
	if arg[10] then
		return v[1], v[2], v[3], v[4], v[5]
	elseif arg[8] then
		return v[1], v[2], v[3], v[4]
	elseif arg[6] then
		return v[1], v[2], v[3]
	elseif arg[4] then
		return v[1], v[2]
	elseif arg[2] then
		return v[1]
	end
end

-- rough adaptation of Knuth float generator
-- Note: seedobj must be a table with a field named `seed`;
-- this field must be negative; after the first number has
-- been generated, the seedobj table will be populated with
-- additional state needed to generate numbers; changing its
-- `seed` field to a negative number will reinitialize the
-- generator and start a new pseudorandom sequence.
function srandom( seedobj, fVal1, fVal2 )
	local B =  4000000
	local ma = seedobj.ma
	local seed = seedobj.seed
	local mj, mk
	if seed < 0 or not ma then
		ma = {}
		seedobj.ma = ma
		mj = abs( 1618033 - abs( seed ) )
		mj = mod( mj, B )
		ma[55] = mj
		mk = 1
		for i = 1, 54 do
			local ii = mod( 21 * i,  55 )
			ma[ii] = mk
			mk = mj - mk
			if mk < 0 then
				mk = mk + B
			end
			mj = ma[ii]
		end
		for k = 1, 4 do
			for i = 1, 55 do
				ma[i] = ma[i] - ma[ 1 + mod( i + 30,  55) ]
				if ma[i] < 0 then
					ma[i] = ma[i] + B
				end
			end
		end
		seedobj.inext = 0
		seedobj.inextp = 31
		seedobj.seed = 1
	end -- if
	local inext = seedobj.inext
	local inextp = seedobj.inextp
	inext = inext + 1
	if inext == 56 then
		inext = 1
	end
	seedobj.inext = inext
	inextp = inextp + 1
	if inextp == 56 then
		inextp = 1
	end
	seedobj.inextp = inextp
	mj = ma[ inext ] - ma[ inextp ]
	if mj < 0 then
		mj = mj + B
	end
	ma[ inext ] = mj
	local temp_rand = mj / B
	if fVal2 then
		return floor( fVal1 + 0.5 + temp_rand * ( fVal2 - fVal1 ) )
	elseif fVal1 then
		return floor( temp_rand * fVal1 ) + 1
	else
		return temp_rand
	end
end


-- Randomly returns either 1 or -1. Seeded.
function srandomSign(seedobj)
	if (srandom(seedobj) > 0.5) then
		return 1
	else
		return -1
	end
end

-- Randomly returns either 1 or 0. Seeded.
function srandomBit(seedobj)
	if (srandom(seedobj) > 0.5) then
		return 1
	else
		return 0
	end
end

-- Works just like random(), but can accept zero as an argument. Seeded.
function srandom2(seedobj, fVal1, fVal2)
	if (fVal2) then
		if ((fVal2 - fVal1) == 0) then
			return fVal2
		else
			return srandom(seedobj, fVal1, fVal2)
		end
	elseif (fVal1) then
		if (fVal1 == 0) then
			return 0
		else
			return srandom(seedobj, fVal1)
		end
	else
		return srandom(seedobj)
	end
end

-- Works just like random(), but can accept zero as an argument and always returns a float value, not an integer. Seeded.
function srandom3(seedobj, fVal1, fVal2)
	if (fVal2) then
		return fVal1 + srandom(seedobj) * (fVal2 - fVal1)
	elseif (fVal1) then
		return srandom(seedobj) * fVal1
	else
		return srandom(seedobj)
	end
end

-- For each argument, returns a random float value between 0 and the argument. Seeded.
function srandomSet(seedobj, ...)
	local v = {}
	for i = 1, getn(arg) do
		v[i] = srandom3(seedobj, arg[i])
	end
	if arg[5] then
		return v[1], v[2], v[3], v[4], v[5]
	elseif arg[4] then
		return v[1], v[2], v[3], v[4]
	elseif arg[3] then
		return v[1], v[2], v[3]
	elseif arg[2] then
		return v[1], v[2]
	elseif arg[1] then
		return v[1]
	end
end

-- For every two arguments, returns a random float value between the former argument and the latter argument. Seeded.
function srandomSet2(seedobj, ...)
	local v = {}
	for i = 2, getn(arg), 2 do
		v[i/2] = srandom3(seedobj, arg[i-1], arg[i])
	end
	if arg[10] then
		return v[1], v[2], v[3], v[4], v[5]
	elseif arg[8] then
		return v[1], v[2], v[3], v[4]
	elseif arg[6] then
		return v[1], v[2], v[3]
	elseif arg[4] then
		return v[1], v[2]
	elseif arg[2] then
		return v[1]
	end
end

-- Returns a vector with random components.
function vrand(tVecIn)
	local tVecOut = {}
	for i = 1, getn(tVecIn) do
		tinsert(tVecOut, random(tVecIn[i]))
	end
	return tVecOut
end

-- Returns a vector with random components. Seeded.
function svrand(seedobj, tVecIn)
	local tVecOut = {}
	for i = 1, getn(tVecIn) do
		tinsert(tVecOut, srandom(seedobj, tVecIn[i]))
	end
	return tVecOut
end

-- Returns a vector with random components.
function vrand2(tVecIn)
	local tVecOut = {}
	for i = 1, getn(tVecIn) do
		tinsert(tVecOut, random2(tVecIn[i][1], tVecIn[i][2]))
	end
	return tVecOut
end

-- Returns a vector with random components. Seeded.
function svrand2(seedobj, tVecIn)
	local tVecOut = {}
	for i = 1, getn(tVecIn) do
		tinsert(tVecOut, srandom2(seedobj, tVecIn[i][1], tVecIn[i][2]))
	end
	return tVecOut
end

-- Returns a vector with random components.
function vrand3(tVecIn)
	local tVecOut = {}
	for i = 1, getn(tVecIn) do
		tinsert(tVecOut, random3(tVecIn[i][1], tVecIn[i][2]))
	end
	return tVecOut
end

-- Returns a vector with random components. Seeded.
function svrand3(seedobj, tVecIn)
	local tVecOut = {}
	for i = 1, getn(tVecIn) do
		tinsert(tVecOut, srandom3(seedobj, tVecIn[i][1], tVecIn[i][2]))
	end
	return tVecOut
end

--------------------------------------------------------------------------------
-- Some trigonometric functions.
--

-- Returns the hyperbolic cosine of an angle.
function cosh(fAng)
	return (exp(fAng) + exp(-fAng))/2
end


-- Returns the hyperbolic sine of an angle.
function sinh(fAng)
	return (exp(fAng) - exp(-fAng))/2
end


-- Returns the hyperbolic tangent of an angle.
function tanh(fAng)
	return (exp(fAng) - exp(-fAng))/(exp(fAng) + exp(-fAng))
end


-- Returns the hyperbolic cosecant of an angle.
function csch(fAng)
	return 1/sinh(fAng)
end


-- Returns the hyperbolic secant of an angle.
function sech(fAng)
	return 1/cosh(fAng)
end


-- Returns the hyperbolic cotangent of an angle.
function coth(fAng)
	return 1/tanh(fAng)
end


-- Returns the cosecant of an angle.
function csc(fAng)
	return 1/sin(fAng)
end


-- Returns the secant of an angle.
function sec(fAng)
	return 1/cos(fAng)
end


-- Returns the cotangent of an angle.
function cot(fAng)
	return 1/tan(fAng)
end


-- Returns the exsecant of an angle.
function exsec(fAng)
	return sec(fAng) - 1
end


-- Returns the coexsecant of an angle.
function coexsec(fAng)
	return csc(fAng) - 1
end


-- Returns the versesine of an angle.
function vers(fAng)
	return 1 - cos(fAng)
end


-- Returns the coversesine of an angle.
function covers(fAng)
	return 1 - sin(fAng)
end


-- Returns the half-versesine of an angle.
function hav(fAng)
	return vers(fAng)/2
end


--------------------------------------------------------------------------------
-- Some miscellaneous mathematical functions.
--

-- Rounds a number to the nearest integer.
function round(fVal)
	return floor(fVal + 0.5)
end

-- Some programming languages need this
function pow(fA, fB)
	return fA^fB
end


--------------------------------------------------------------------------------
-- Some vector functions.
--

-- Returns the normalized form of a vector.
function vnormalize(tVec)
	return vdivide(tVec, vlength(tVec))
end

-- Returns the length of a vector.
function vlength(tVec)
	return sqrt(vsum(vpower(tVec, 2)))
end

-- Returns the distance between two vectors.
function vdistance(tVec1, tVec2)
	return vlength(vsubtractV(tVec2, tVec1))
end

-- Returns the dot product of two vectors.
function vdot(tVec1, tVec2)
	return vsum(vmultiplyV(tVec1, tVec2))
end

-- Returns the angle between two vectors.
function vangle(tVec1, tVec2)
	return acos(vdot(vnormalize(tVec1), vnormalize(tVec2)))
end

-- Returns the cross product of two vectors as a new vector.
function vcross(tVec1, tVec2)
	return
	{
		tVec1[2] * tVec2[3] - tVec1[3] * tVec2[2],
		tVec1[3] * tVec2[1] - tVec1[1] * tVec2[3],
		tVec1[1] * tVec2[2] - tVec1[2] * tVec2[1],
	}
end

-- tests whether two vectors are equal
function veq(tVec1, tVec2)
	if (tVec1[1] == tVec2[1]) and (tVec1[2] == tVec2[2]) and (tVec1[3] == tVec2[3]) then
		return 1
	else
		return 0
	end
end

-- returns the midpoint of two points as a new point
function vmidpoint(tVec1, tVec2)
	return
	{
		(tVec1[1] + tVec2[1]) / 2,
		(tVec1[2] + tVec2[2]) / 2,
		(tVec1[3] + tVec2[3]) / 2,
	}
end

-- Adds an amount to each vector component, then returns the resulting vector.
function vadd(tVec, fVal)
	local tmpVec = {}
	for i, tTab in tVec do
		tmpVec[i] = tVec[i] + fVal
	end
	return tmpVec
end

-- Adds the components of the second vector to the components of the first vector, then returns the resulting vector.
function vaddV(tVec1, tVec2)
	local tmpVec = {}
	for i, tTab in tVec2 do
		tmpVec[i] = tVec1[i] + tTab
	end
	return tmpVec
end

-- Subtracts an amount from each vector component, then returns the resulting vector.
function vsubtract(tVec, fVal)
	local tmpVec = {}
	for i, tTab in tVec do
		tmpVec[i] = tVec[i] - fVal
	end
	return tmpVec
end

-- Subtracts the components of the second vector from the components of the first vector, then returns the resulting vector.
function vsubtractV(tVec1, tVec2)
	local tmpVec = {}
	for i, tTab in tVec2 do
		tmpVec[i] = tVec1[i] - tTab
	end
	return tmpVec
end

-- Multiplies each vector component by some amount, then returns the resulting vector.
function vmultiply(tVec, fVal)
	local tmpVec = {}
	for i, tTab in tVec do
		tmpVec[i] = tTab * fVal
	end
	return tmpVec
end

-- Multiplies the components of the first vector by the components of the second vector, then returns the resulting vector.
function vmultiplyV(tVec1, tVec2)
	local tmpVec = {}
	for i, tTab in tVec2 do
		tmpVec[i] = tVec1[i] * tTab
	end
	return tmpVec
end

-- Divides each vector component by some amount, then returns the resulting vector.
function vdivide(tVec, fVal)
	local tmpVec = {}
	for i, tTab in tVec do
		tmpVec[i] = tTab/fVal
	end
	return tmpVec
end

-- Divides the components of the first vector by the components of the second vector, then returns the resulting vector.
function vdivideV(tVec1, tVec2)
	local tmpVec = {}
	for i, tTab in tVec2 do
		tmpVec[i] = tVec1[i]/tTab
	end
	return tmpVec
end

-- Raises each vector component to the some power, then returns the new vector.
function vpower(tVec, fVal)
	local tmpVec = {}
	for i, tTab in tVec do
		tmpVec[i] = tTab^fVal
	end
	return tmpVec
end

-- Raises the components of the first vector to the power specified by the components the second vector, then returns the new vector.
function vpowerV(tVec1, tVec2)
	local tmpVec = {}
	for i, tTab in tVec2 do
		tmpVec[i] = tVec1[i]^tTab
	end
	return tmpVec
end

-- Returns the sum of all the vector's components.
function vsum(tVec1)
	local tmpVal = 0
	for i, tTab in tVec1 do
		tmpVal = tmpVal + tTab
	end
	return tmpVal
end

-- Returns a vector converted into a string.
function vstr(tVec)
	local tmpStr = "{"
	for i, tTab in tVec do
		tmpStr = tmpStr .. tTab .. ", "
	end
	tmpStr = tmpStr .. "}\n"
	return tmpStr
end

-- Rotates a vector around the origin by the specified Euler angles, then returns the resulting vector.
-- Rotates around the Z-axis first, followed by the X-axis and the Y-axis.
function vrotate(tVec, tAng)
	tVec =
	{
		tVec[1] * cos(tAng[3]) - tVec[2] * sin(tAng[3]),
		tVec[1] * sin(tAng[3]) + tVec[2] * cos(tAng[3]),
		tVec[3],
	}
	tVec =
	{
		tVec[1],
		tVec[2] * cos(tAng[1]) - tVec[3] * sin(tAng[1]),
		tVec[2] * sin(tAng[1]) + tVec[3] * cos(tAng[1]),
	}
	tVec =
	{
		tVec[1] * cos(tAng[2]) + tVec[3] * sin(tAng[2]),
		tVec[2],
		-1 * tVec[1] * sin(tAng[2]) + tVec[3] * cos(tAng[2]),
	}
	return tVec
end

-- Returns an array containing the vector's Euler angles, relative to the Z-axis.
-- To reproduce the original vector, rotate a point on the Z-axis by these angles.
function vanglesXY(tVec2)
	local fSgnX, fSgnY, tPrjB1 = 1, 1, vnormalize({tVec2[1], 0, tVec2[3],})
	if (tPrjB1[1] ~= 0) then
		fSgnX = tPrjB1[1]/abs(tPrjB1[1]) * -1
	end
	local fAngY = acos(tPrjB1[3]) * fSgnX
	local tPrjB2 = vnormalize(vrotate(tVec2, {0, fAngY, 0,}))
	if (tPrjB2[2] ~= 0) then
		fSgnY = tPrjB2[2]/abs(tPrjB2[2])
	end
	local fAngX = acos(tPrjB2[3]) * fSgnY
	return {fAngX * -1, fAngY * -1, 0,}
end

-- Rotates the first vector around the second vector by some amount, then returns the resulting vector.
function vaxis_rotate(tVec1, tVec2, fAngZ)
	local tAng = vanglesXY(tVec2)
	return vrotate(vrotate(vrotate(vrotate(tVec1, {0, tAng[2], 0,}), {tAng[1], 0, 0,}), {0, 0, fAngZ,}), vmultiply(tAng, -1))
end


--------------------------------------------------------------------------------
-- Some table manipulation functions.
--

--------------------------------------------------------------------------------
-- Returns the length of a table. Useful where the 'getn' function is normally unavailable.
if not getn then
	function getn(tTable)
		local nCount = 0
		for i, iCount in tTable do
			if i ~= "n" then
				nCount = nCount + 1
			end
		end
		return nCount
	end
end


--------------------------------------------------------------------------------
-- Inserts an item into a table. Useful where the 'tinsert' function is normally unavailable.
if not tinsert then
	function tinsert(tTable, Arg1, Arg2)
		if (Arg2) then
			local TempTable = {}
			for i = Arg1, getn(tTable) do
				TempTable[i + 1] = tTable[i]
			end
			for i = Arg1, getn(tTable) do
				tTable[i + 1] = TempTable[i + 1]
			end
			tTable[Arg1] = Arg2
		else
			tTable[getn(tTable) + 1] = Arg1
		end
	end
end


--------------------------------------------------------------------------------
-- Compares two tables and returns true if they're equal and false if they're not.
function tcomp(tTable1, tTable2)
	local same = 1
	if (getn(tTable1) ~= getn(tTable2)) then
		same = 0
	else
		for i, k in tTable1 do
			if (type(tTable1[i]) == "table") and (type(tTable2[i]) == "table") then
				same = tcomp(tTable1[i], tTable2[i])
				if (same == 0) then
					break
				end
			elseif (tTable1[i] ~= tTable2[i]) then
				same = 0
				break
			end
		end
	end
	return same
end


--------------------------------------------------------------------------------
-- Mathematical shape functions
--

function makeCuboid(tPar, tSeed)
	local t, p = srandom(tSeed), srandomSign(tSeed)
	local l, w, h, L, W, H = srandomSet2(tSeed, -tPar[2], tPar[2], -tPar[3], tPar[3], -tPar[4], tPar[4], tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	if (t < 1/3) then
		l = L * p
	elseif (t < 2/3) then
		w = W * p
	elseif (t <= 1) then
		h = H * p
	end
	return {l, h, w,}
end

function makeEllipsoid(tPar, tSeed)
	local L, W, H = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	local u, v = srandomSet(tSeed, 180, 360)
	return {L * cos(v) * sin(u), H * sin(v) * sin(u), W * cos(u),}
end

function makeCylinder(tPar, tSeed)
	local L, W, h = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], -tPar[4], tPar[4])
	local u, v = srandomSet(tSeed, 180, 360)
	return {L * cos(v), h, W * sin(v),}
end

function makeCone(tPar, tSeed)
	local L, W, h = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], -tPar[4], tPar[4])
	local v = srandom3(tSeed, 360)
	return {(1 - h/c) * L * cos(v)/2, h, (1 - h/c) * W * sin(v)/2,}
end

function makeToroid(tPar, tSeed)
	local H, M = srandomSet2(tSeed, tPar[4] - tPar[5], tPar[4], tPar[6] - tPar[5], tPar[6])
	local v, o = srandomSet(tSeed, 360, 360)
	return {(tPar[2] + M * cos(v)) * cos(o), H * sin(v), (tPar[3] + M * cos(v)) * sin(o),}
end

function makeHelicoid(tPar, tSeed)
	local L, W = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3])
	local t = srandom(tSeed)
	return {L * cos(t * tPar[6] * 360), tPar[4] * (2 * t - 1), W * sin(t * tPar[6] *  360),}
end

function makeParaboloid(tPar, tSeed)
	local L, W, h = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], -tPar[4], tPar[4])
	local v = srandom3(tSeed, 360)
	return {L * sqrt(h/1000) * cos(v), h, W * sqrt(h/1000) * sin(v),}
end

function makeHyperboloid(tPar, tSeed)
	local L, W, H = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	local t, v, p = srandom(tSeed), srandom3(tSeed, 360), srandomSign(tSeed)
	return {L * sqrt(1 + (t * p)^2) * cos(v), H * (t * p), W * sqrt(1 + (t * p)^2) * sin(v),}
end

function makeAstroid(tPar, tSeed)
	local L, W, H = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	local v, o = srandomSet(tSeed, 360, 360)
	return {L * (cos(o) * cos(v))^3, H * (sin(v))^3, W * (sin(o) * cos(v))^3,}
end

function makeFunnel(tPar, tSeed)
	local L, W, H = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	local t, v = srandom(tSeed), srandom3(tSeed, 360)
	return {L * t * cos(v), H * log(t)/10, W * t * sin(v),}
end

function makeDini(tPar, tSeed)
	local L, W, H = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	local v, u = srandomSet(tSeed, 360, 180)
	return {L * (cos(tPar[6] * v) * sin(u/2)), H * (cos(u/2) + log(tan(u/4)) + rad(tPar[6] * v)/(2 * PI)), W * (sin(tPar[6] * v) * sin(u/2)),}
end

function makeCorkscrew(tPar, tSeed)
	local L, W, H = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	local v, u = srandomSet(tSeed, 360, 180)
	return {L * cos(v) * cos(u), H * rad(v)/(2 * PI), W * sin(v) * cos(u),}
end

function makeSeashell(tPar, tSeed)
	local t, o = srandom(tSeed), srandom3(tSeed, 360)
	return
	{
		(tPar[5]/tPar[6] + (1 - t) * (1 + cos(o))) * tPar[2] * cos(tPar[6] * t * 360),
		tPar[4] * t^(1/2) * (2 * tPar[6] - 1) + tPar[3] * sin(o) * (1 - t),
		(tPar[5]/tPar[6] + (1 - t) * (1 + cos(o))) * tPar[2] * sin(tPar[6] * t * 360),
	}
end

function makeSineDisc(tPar, tSeed)
	local L, W, H = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], tPar[4] - tPar[5], tPar[4])
	local t, v = srandom(tSeed), srandom3(tSeed, 360)
	return {L * t * cos(v), H * sin(t * 360 * tPar[6]), W * t * sin(v),}
end

function makeSinePlane(tPar, tSeed)
	local s, t = srandom(tSeed), srandom(tSeed)
	return
	{
		tPar[2] * s * 2 - tPar[2],
		tPar[4] * (sin(s * 360 * tPar[6]) + sin(t * 360 * tPar[6]))/2,
		tPar[3] * t * 2 - tPar[3],
	}
end

function makeMoebius(tPar, tSeed)
	local L, W, h = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], -tPar[4], tPar[4])
	local v = srandom3(tSeed, 360)
	return {L * cos(v) + h * cos(v/2) * cos(v), h * sin(v/2), W * sin(v) + h * cos(v/2) * sin(v),}
end

function makeKlein(tPar, tSeed)
	local u, v = srandomSet(tSeed,360,180)
	return
	{
		cos(u) * (cos(u/2) * (sqrt(2) + cos(v)) + sin(u/2) * sin(v) * cos(v))	* tPar[2],
		(-sin(u/2) * (sqrt(2) + cos(v)) + cos(u/2) * sin(v) * cos(v))		* tPar[4],
		sin(u) * (cos(u/2) * (sqrt(2) + cos(v)) + sin(u/2) * sin(v) * cos(v))	* tPar[3],
	}
end

function makeKlein8(tPar, tSeed)
	local u, v = srandomSet(tSeed,360,360)
	return
	{
		(tPar[6] + cos(u/2) * sin(v) - sin(u/2) * sin(v*2)) * cos(u)	* tPar[2],
		(sin(u/2) * sin(v) + cos(u/2) * sin(v*2))			* tPar[3],
		(tPar[6] + cos(u/2) * sin(v) - sin(u/2) * sin(v*2)) * sin(u)	* tPar[4],
	}
end

function makeKuen(tPar, tSeed)
	local u, v = srandomSet(tSeed,180,360)
	return
	{
		2 * (cos(v) + rad(v) * sin(v)) * sin(u)/(1 + rad(v)^2 * sin(u)^2)	* tPar[2],
		(log(tan(u/2)) + 2 * cos(u)/(1 + rad(v)^2 * sin(u)^2))			* tPar[3],
		2 * (sin(v) - rad(v) * cos(v)) * sin(u)/(1 + rad(v)^2 * sin(u)^2)	* tPar[4],
	}
end

function makeBoy(tPar, tSeed)
	local u, v = srandom(tSeed,180) - 90, srandom(tSeed,180)
	return
	{
		(sqrt(2) * cos(v)^2 * cos(2 * u) + cos(u) * sin(2 * v)) / (2 - sqrt(2) * sin(3 * u) * sin(2 * v))	* tPar[2],
		(3 * cos(v)^2) / (2 - sqrt(2) * sin(3 * u) * sin(2 * v))						* tPar[3],
		(sqrt(2) * cos(v)^2 * sin(2 * u) - sin(u) * sin(2 * v)) / (2 - sqrt(2) * sin(3 * u) * sin(2 * v))	* tPar[4],
	}
end

function makeRectangle(tPar, tSeed)
	local L, W, l = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], -tPar[2], tPar[2])
	local w, h = srandomSet2(tSeed, -tPar[3], tPar[3], -tPar[4], tPar[4])
	local p, t = srandomSign(tSeed), srandom(tSeed)
	if (t < 1/2) then
		l = L * p
	else
		w = W * p
	end
	return {l, h, w,}
end

function makeEllipse(tPar, tSeed)
	local L, W, h, v = srandomSet2(tSeed, tPar[2] - tPar[5], tPar[2], tPar[3] - tPar[5], tPar[3], -tPar[4], tPar[4])
	local v = srandom3(tSeed, 360)
	return {L * cos(v), h, W * sin(v),}
end

function makeParabola(tPar, tSeed)
	local w, h, p = srandomSet2(tSeed, -tPar[3], tPar[3], -tPar[4], tPar[4])
	local p = srandomSign(tSeed)
	return
	{
		sqrt(4 * w * tPar[2]) * p + srandom3(tSeed, -tPar[5]/2, tPar[5]/2),
		h,
		w + srandom3(tSeed, -tPar[5]/2, tPar[5]/2),
	}
end

function makeHyperbola(tPar, tSeed)
	local h, v = srandom3(tSeed, -tPar[4], tPar[4]), srandom3(tSeed, 360)
	return
	{
		tPar[2]/cos(v) + srandom3(tSeed, -tPar[5]/2, tPar[5]/2),
		h,
		tPar[3] * tan(v) + srandom3(tSeed, -tPar[5]/2, tPar[5]/2),
	}
end

function makeHypotrochoid(tPar, tSeed)
	local v, o, u = srandomSet(tSeed,360,360,180)
	return
	{
		(tPar[2] - tPar[3]) * cos(v * tPar[6]) + tPar[5] * cos((tPar[2] - tPar[3])/tPar[3] * v * tPar[6])	+ tPar[4] * sin(u) * cos(o),
		0													+ tPar[4] * sin(u) * sin(o),
		(tPar[2] - tPar[3]) * sin(v * tPar[6]) - tPar[5] * sin((tPar[2] - tPar[3])/tPar[3] * v * tPar[6])	+ tPar[4] * cos(u),
	}
end

function makeEpitrochoid(tPar, tSeed)
	local v, o, u = srandomSet(tSeed,360,360,180)
	return
	{
		(tPar[2] + tPar[3]) * cos(v * tPar[6]) - tPar[5] * cos((tPar[2] + tPar[3])/tPar[3] * v * tPar[6])	+ tPar[4] * sin(u) * cos(o),
		0													+ tPar[4] * sin(u) * sin(o),
		(tPar[2] + tPar[3]) * sin(v * tPar[6]) - tPar[5] * sin((tPar[2] + tPar[3])/tPar[3] * v * tPar[6])	+ tPar[4] * cos(u),
	}
end


--------------------------------------------------------------------------------
-- Debug functions
--

function print_map_stats()
	local total = iStartPoints + iPoints + iSpheres + iCameras + iSquadrons + iAsteroids + iSalvage + iPebbles + iClouds + iDustClouds + iNebulas + iDirLights + iRvAsteroids + iRvSquadrons
	print("Level loaded: " .. levelDesc)
	print("Maxplayers: " .. maxPlayers)
	print
	(
		"\niStartPoints = " .. iStartPoints ..
		"\n     iPoints = " ..      iPoints ..
		"\n    iSpheres = " ..     iSpheres ..
		"\n    iCameras = " ..     iCameras ..
		"\n  iSquadrons = " ..   iSquadrons ..
		"\n  iAsteroids = " ..   iAsteroids ..
		"\n    iSalvage = " ..     iSalvage ..
		"\n    iPebbles = " ..     iPebbles ..
		"\n     iClouds = " ..      iClouds ..
		"\n iDustClouds = " ..  iDustClouds ..
		"\n    iNebulas = " ..     iNebulas ..
		"\n  iDirLights = " ..   iDirLights ..
		"\niRvAsteroids = " .. iRvAsteroids ..
		"\niRvSquadrons = " .. iRvSquadrons ..
		"\n       total = " ..        total
	)
end
