-- Path of Building
--
-- Class: Item list
-- Unified build + shared item list control.
--
local pairs = pairs
local ipairs = ipairs
local t_insert = table.insert
local t_remove = table.remove

local ItemListClass = newClass("ItemListControl", "ListControl", function(self, anchor, rect, itemsTab, sharedList, forceTooltip)
	self.ListControl(anchor, rect, 16, "VERTICAL", false, {}, forceTooltip)
	self.itemsTab = itemsTab
	self.buildList = itemsTab.itemOrderList
	self.sharedList = sharedList
	self.searchText = ""
	self.defaultText = "^x7F7F7FThis is the list of items that have been added to this build\nand shared items available to all builds.\nDouble-click an item to edit it."
	self.dragTargetList = { }

	local listControl = self

	-- Search row (2 px above list body)
	self.controls.search = new("EditControl",
		{"BOTTOMLEFT", self, "TOPLEFT"}, {0, -2, 0, 20},
		"", "Search", "%c", 100,
		function(buf)
			self.searchText = buf
			self:Populate()
		end,
		nil, nil, true)
	self.controls.search.width = function()
		local w = listControl:GetSize()
		return w
	end

	-- Row B: transfer buttons (4 px above search)
	self.controls.shareItem = new("ButtonControl", {"BOTTOMLEFT",self.controls.search,"TOPLEFT"}, {0, -4, 0, 20}, "-> Shared", function()
		local entry = self.selValue
		if not entry or entry.kind ~= "BUILD" then return end
		local item = itemsTab.items[entry.id]
		local copy = new("Item", item:BuildRaw())
		t_insert(self.sharedList, copy)
		self:Populate()
	end)
	self.controls.shareItem.enabled = function()
		return self.selValue ~= nil and self.selValue.kind == "BUILD"
	end
	self.controls.shareItem.tooltipFunc = function(tooltip)
		tooltip:Clear()
		tooltip:AddLine(14, "^7Copy selected item to the Shared items section")
	end
	self.controls.shareItem.width = function()
		return math.floor((listControl:GetSize() - 4) / 2)
	end

	self.controls.moveToItem = new("ButtonControl", {"LEFT",self.controls.shareItem,"RIGHT"}, {4, 0, 0, 20}, "<- Build", function()
		local entry = self.selValue
		if not entry or entry.kind ~= "SHARED" then return end
		local copy = new("Item", entry.item:BuildRaw())
		copy:NormaliseQuality()
		itemsTab:AddItem(copy, true)
		itemsTab:PopulateSlots()
		itemsTab:AddUndoState()
	end)
	self.controls.moveToItem.enabled = function()
		return self.selValue ~= nil and self.selValue.kind == "SHARED"
	end
	self.controls.moveToItem.tooltipFunc = function(tooltip)
		tooltip:Clear()
		tooltip:AddLine(14, "^7Copy selected shared item into this build")
	end
	self.controls.moveToItem.width = function()
		return math.floor((listControl:GetSize() - 4) / 2)
	end

	-- Row A: action buttons (4 px above Row B)
	self.controls.sort = new("ButtonControl", {"BOTTOMLEFT",self.controls.shareItem,"TOPLEFT"}, {0, -4, 60, 18}, "Sort", function()
		itemsTab:SortItemList()
		self:Populate()
	end)

	self.controls.deleteUnused = new("ButtonControl", {"LEFT",self.controls.sort,"RIGHT"}, {4, 0, 100, 18}, "Delete Unused", function()
		local delList = {}
		for _, itemId in pairs(self.buildList) do
			if not itemsTab:GetEquippedSlotForItem(itemsTab.items[itemId]) and not self:FindEquippedItemSocket(itemId, false) and not self:FindSocketedJewel(itemId, false) then
				t_insert(delList, itemId)
			end
		end
		for i = #delList, 1, -1 do
			itemsTab:DeleteItem(itemsTab.items[delList[i]], true)
		end
		for _, spec in pairs(itemsTab.build.treeTab.specList) do
			spec:BuildClusterJewelGraphs()
		end
		itemsTab:PopulateSlots()
		itemsTab:AddUndoState()
		itemsTab.build.buildFlag = true
	end)
	self.controls.deleteUnused.enabled = function()
		return #self.buildList > 0
	end

	self.controls.deleteAll = new("ButtonControl", {"LEFT",self.controls.deleteUnused,"RIGHT"}, {4, 0, 70, 18}, "Delete All", function()
		main:OpenConfirmPopup("Delete All", "Are you sure you want to delete all items in this build?", "Delete", function()
			for _, slot in pairs(itemsTab.slots) do
				slot:SetSelItemId(0)
			end
			for _, spec in pairs(itemsTab.build.treeTab.specList) do
				for nodeId, itemId in pairs(spec.jewels) do
					spec.jewels[nodeId] = 0
				end
			end
			wipeTable(self.buildList)
			wipeTable(self.itemsTab.items)
			itemsTab:PopulateSlots()
			itemsTab:AddUndoState()
			itemsTab.build.buildFlag = true
			self.selIndex = nil
			self.selValue = nil
		end)
	end)
	self.controls.deleteAll.enabled = function()
		return #self.buildList > 0
	end

	self.controls.delete = new("ButtonControl", {"LEFT",self.controls.deleteAll,"RIGHT"}, {4, 0, 60, 18}, "Delete", function()
		self:OnSelDelete(self.selIndex, self.selValue)
	end)
	self.controls.delete.enabled = function()
		return self.selValue ~= nil and self.selValue.kind ~= "HEADER"
	end

	self:Populate()
end)

function ItemListClass:Populate()
	local prevKind = self.selValue and self.selValue.kind
	local prevId   = self.selValue and self.selValue.id
	local prevItem = self.selValue and self.selValue.item

	wipeTable(self.list)
	local s = self.searchText:lower()

	t_insert(self.list, {kind="HEADER", label="^7All items:"})
	for _, itemId in ipairs(self.buildList) do
		local item = self.itemsTab.items[itemId]
		if item and (s == "" or item.name:lower():find(s, 1, true)) then
			t_insert(self.list, {kind="BUILD", id=itemId})
		end
	end

	t_insert(self.list, {kind="HEADER", label="^7Shared items:"})
	for _, item in ipairs(self.sharedList) do
		if s == "" or item.name:lower():find(s, 1, true) then
			t_insert(self.list, {kind="SHARED", item=item})
		end
	end

	self.selIndex = nil
	self.selValue = nil
	if prevKind then
		for i, entry in ipairs(self.list) do
			if prevKind == "BUILD" and entry.kind == "BUILD" and entry.id == prevId then
				self.selIndex = i
				self.selValue = entry
				break
			elseif prevKind == "SHARED" and entry.kind == "SHARED" and entry.item == prevItem then
				self.selIndex = i
				self.selValue = entry
				break
			end
		end
	end
end

function ItemListClass:OverrideSelectIndex(index)
	return self.list[index] and self.list[index].kind == "HEADER"
end

function ItemListClass:FindSocketedJewel(jewelId, excludeActiveSpec)
	if not self.itemsTab.items[jewelId] or self.itemsTab.items[jewelId].type ~= "Jewel" then
		return nil
	end
	local treeTab = self.itemsTab.build.treeTab
	local equipTree = nil
	local matchActive = false
	for specId = #treeTab.specList, 1, -1 do
		local spec = treeTab.specList[specId]
		for nodeId, itemId in pairs(spec.jewels) do
			if itemId == jewelId and spec.nodes[nodeId] and spec.nodes[nodeId].alloc then
				if excludeActiveSpec and (specId == treeTab.activeSpec or matchActive) then
					equipTree = nil
					matchActive = true
				else
					equipTree = spec.title or "Default"
				end
			end
		end
	end
	return equipTree
end

function ItemListClass:FindEquippedItemSocket(socketId, excludeActiveSet)
	if not self.itemsTab.items[socketId] then
		return nil
	end
	local equipSet = nil
	local matchActive = false
	for _, itemSet in pairs(self.itemsTab.itemSets) do
		for slotName, slot in pairs(itemSet) do
			if type(slot) == "table" and slot.selItemId == socketId then
				if excludeActiveSet and (itemSet == self.itemsTab.activeItemSet or matchActive) then
					equipSet = nil
					matchActive = true
				else
					equipSet = itemSet.title or "Default"
				end
			end
		end
	end
	return equipSet
end

function ItemListClass:GetRowValue(column, index, entry)
	if column ~= 1 then return end
	if entry.kind == "HEADER" then
		return entry.label
	elseif entry.kind == "BUILD" then
		local item = self.itemsTab.items[entry.id]
		if not item then return "" end
		local used = self:FindEquippedItemSocket(entry.id, true) or self:FindSocketedJewel(entry.id, true) or ""
		if used == "" then
			local slot, itemSet = self.itemsTab:GetEquippedSlotForItem(item)
			if not slot then
				used = "  ^9(Unused)"
			elseif itemSet then
				used = "  ^9(Used in '" .. (itemSet.title or "Default") .. "')"
			end
		else
			used = "  ^9(Used in '" .. used .. "')"
		end
		return colorCodes[item.rarity] .. item.name .. used
	elseif entry.kind == "SHARED" then
		local item = entry.item
		return colorCodes[item.rarity] .. item.name
	end
end

function ItemListClass:AddValueTooltip(tooltip, index, entry)
	if entry.kind == "HEADER" then
		tooltip:Clear()
		return
	end
	if main.popups[1] then
		tooltip:Clear()
		return
	end
	local item = entry.kind == "BUILD" and self.itemsTab.items[entry.id] or entry.item
	if item and tooltip:CheckForUpdate(item, IsKeyDown("SHIFT"), launch.devModeAlt, self.itemsTab.build.outputRevision) then
		self.itemsTab:AddItemTooltip(tooltip, item)
	end
end

function ItemListClass:GetDragValue(index, entry)
	if entry.kind == "HEADER" then return end
	local item = entry.kind == "BUILD" and self.itemsTab.items[entry.id] or entry.item
	if item then
		return "Item", item
	end
end

function ItemListClass:ReceiveDrag(type, value, source)
	if type == "Item" then
		local newItem = new("Item", value.raw)
		newItem:NormaliseQuality()
		self.itemsTab:AddItem(newItem, true)
		self.itemsTab:PopulateSlots()
		self.itemsTab:AddUndoState()
	end
end

function ItemListClass:OnOrderChange()
	self.itemsTab:AddUndoState()
end

function ItemListClass:OnSelClick(index, entry, doubleClick)
	if not entry or entry.kind == "HEADER" then return end
	if entry.kind == "BUILD" then
		local item = self.itemsTab.items[entry.id]
		if IsKeyDown("CTRL") then
			local slotName = item:GetPrimarySlot()
			if slotName and self.itemsTab.slots[slotName] then
				if self.itemsTab.slots[slotName].weaponSet == 1 and self.itemsTab.activeItemSet.useSecondWeaponSet then
					slotName = slotName .. " Swap"
				end
				if IsKeyDown("SHIFT") then
					local altSlot = slotName:gsub("1","2")
					if self.itemsTab:IsItemValidForSlot(item, altSlot) then
						slotName = altSlot
					end
				end
				if self.itemsTab.slots[slotName].selItemId == item.id then
					self.itemsTab.slots[slotName]:SetSelItemId(0)
				else
					self.itemsTab.slots[slotName]:SetSelItemId(item.id)
				end
				self.itemsTab:PopulateSlots()
				self.itemsTab:AddUndoState()
				self.itemsTab.build.buildFlag = true
			end
		elseif doubleClick then
			local newItem = new("Item", item:BuildRaw())
			newItem.id = item.id
			self.itemsTab:SetDisplayItem(newItem)
		end
	elseif entry.kind == "SHARED" then
		if doubleClick then
			self.itemsTab:CreateDisplayItemFromRaw(entry.item.raw, true)
			self.selDragging = false
		end
	end
end

function ItemListClass:OnSelCopy(index, entry)
	if not entry or entry.kind == "HEADER" then return end
	local item = entry.kind == "BUILD" and self.itemsTab.items[entry.id] or entry.item
	if item then
		Copy(item:BuildRaw():gsub("\n", "\r\n"))
	end
end

function ItemListClass:OnSelDelete(index, entry)
	if not entry or entry.kind == "HEADER" then return end
	if entry.kind == "BUILD" then
		local item = self.itemsTab.items[entry.id]
		local equipSlot, equipSet = self.itemsTab:GetEquippedSlotForItem(item)
		if equipSlot then
			local inSet = equipSet and (" in set '"..(equipSet.title or "Default").."'") or ""
			main:OpenConfirmPopup("Delete Item", item.name.." is currently equipped in "..equipSlot.label..inSet..".\nAre you sure you want to delete it?", "Delete", function()
				self.itemsTab:DeleteItem(item)
				self.selIndex = nil
				self.selValue = nil
			end)
		else
			local equipSet2 = self:FindEquippedItemSocket(entry.id, true)
			if equipSet2 then
				main:OpenConfirmPopup("Delete Item", item.name.." is currently equipped in a Socket in set '"..equipSet2.."'.\nAre you sure you want to delete it?", "Delete", function()
					self.itemsTab:DeleteItem(item)
					self.selIndex = nil
					self.selValue = nil
				end)
			else
				local equipTree = self:FindSocketedJewel(entry.id, true)
				if equipTree then
					main:OpenConfirmPopup("Delete Item", item.name.." is currently equipped in passive tree '"..equipTree.."'.\nAre you sure you want to delete it?", "Delete", function()
						self.itemsTab:DeleteItem(item)
						self.selIndex = nil
						self.selValue = nil
					end)
				else
					self.itemsTab:DeleteItem(item)
					self.selIndex = nil
					self.selValue = nil
				end
			end
		end
	elseif entry.kind == "SHARED" then
		main:OpenConfirmPopup("Delete Item", "Are you sure you want to remove '"..entry.item.name.."' from the shared item list?", "Delete", function()
			for i, item in ipairs(self.sharedList) do
				if item == entry.item then
					t_remove(self.sharedList, i)
					break
				end
			end
			self.selIndex = nil
			self.selValue = nil
			self:Populate()
		end)
	end
end

function ItemListClass:OnHoverKeyUp(key)
	if itemLib.wiki.matchesKey(key) then
		local entry = self.ListControl:GetHoverValue()
		if entry and entry.kind ~= "HEADER" then
			local item = entry.kind == "BUILD" and self.itemsTab.items[entry.id] or entry.item
			if item then
				itemLib.wiki.openItem(item)
			end
		end
	end
end
