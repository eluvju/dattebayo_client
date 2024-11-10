main = function()
	iiFiles = {
		"System/iteminfo_ptbr.lub",
		"System/itemInfo_EN.lub",
		"System/iteminfo.lub",
	}

	_TempItems = {}
	_Num = 0

	function add_id(item_id)
		local ID = "ID do Item: <URL>[" .. tostring(item_id) .. "]<INFO>https://www.divine-pride.net/database/item/" .. tostring(item_id) .. "</INFO></URL>"
		return ID
	end

	function add_tracinho()
		local T = "--------------------------"
		return T
	end

	-- check existing item
	function CheckItem(ItemID, DESC)
		if not (_TempItems[ItemID]) then
			_TempItems[ItemID] = DESC
			_Num = _Num + 1
		else
			myTbl = {}
			for pos,val in pairs(_TempItems[ItemID]) do
				myTbl[pos] = val
			end

			for pos,val in pairs(DESC) do
				if not (myTbl[pos]) or myTbl[pos] == "" then
					myTbl[pos] = val
				end

			end

			_TempItems[ItemID] = myTbl
		end

	end
	-- end check

	-- Read all files
	for i,iiFile in pairs(iiFiles) do
		d = dofile(iiFile)
	end
	-- Read all files


	-- process _TempItems
	for ItemID,DESC in pairs(_TempItems) do
		--print("ItemID",ItemID,"Name",DESC.identifiedDisplayName)
		result, msg = AddItem(ItemID, DESC.unidentifiedDisplayName, DESC.unidentifiedResourceName, DESC.identifiedDisplayName, DESC.identifiedResourceName, DESC.slotCount, DESC.ClassNum)
		if not result then
			return false, msg
		end
		for k,v in pairs(DESC.unidentifiedDescriptionName) do
			result, msg = AddItemUnidentifiedDesc(ItemID, v)
			if not result then
				return false, msg
			end
		end
		AddItemIdentifiedDesc(ItemID, add_id(ItemID))
		AddItemIdentifiedDesc(ItemID, add_tracinho(ItemID))
		if nil ~= DESC.EffectID then
			result, msg = AddItemEffectInfo(ItemID, DESC.EffectID)
		end
		if not result == true then
			return false, msg
		end
		for k,v in pairs(DESC.identifiedDescriptionName) do
			result, msg = AddItemIdentifiedDesc(ItemID, v)
			if not result then
				return false, msg
			end
		end
		if nil ~= DESC.costume then
			result, msg = AddItemIsCostume(ItemID, DESC.costume)
		end
		if not result == true then
			return false, msg
		end
	end
	-- process _TempItems

	_TempItems = nil

    return true, "good"
end