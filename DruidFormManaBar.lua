function Print(msg, r, g, b)
	DEFAULT_CHAT_FRAME:AddMessage(msg, r, g, b)
end

function PrintRed(msg)
	Print(msg, 1.0, 0.2, 0.2)
end

function PrintWhite(msg)
	Print(msg, 1.0, 1.0, 1.0)
end

function DruidFormManaBar_OnLoad()
	this:SetWidth(PlayerFrameManaBar:GetWidth())
	this:SetHeight(PlayerFrameManaBar:GetHeight() - 2)
	DruidFormManaBarFrameBorder:SetHeight(PlayerFrameManaBar:GetHeight() + 4)
	DruidFormManaBarFrameBorder:SetWidth(PlayerFrameManaBar:GetWidth())

	this:RegisterEvent("UNIT_MANA")
	this:RegisterEvent("UNIT_DISPLAYPOWER")

	this.mana = UnitMana("player")
	this.maxMana = UnitManaMax("player")
	DruidFormManaBarFrameManaPercentage:SetWidth(this:GetWidth())
	DruidFormManaBarFrameManaPercentage:SetText(this.mana .. "/" .. this.maxMana .. "  " .. tostring( math.floor(tonumber(this.mana) / tonumber( this.maxMana) * 100) ) .. "%")

	if UnitManaMax("player") == 100 then
		this.isForm = true
	else
		this.isForm = false
	end
end

function DruidFormManaBar_OnEvent()
	if event == "UNIT_MANA" then
		if tonumber(UnitManaMax("player")) ~= 100 then
			this.mana = UnitMana("player")
			this.maxMana = UnitManaMax("player")
			DruidFormManaBarFrameManaPercentage:SetText(this.mana .. "/" .. this.maxMana .. "  " .. tostring( math.floor(tonumber(this.mana) / tonumber( this.maxMana) * 100) ) .. "%")
			return
		end

		if this.isForm then
			local _, spirit, _, _ = UnitStat("player", 5)
			local manaPerTick = 15 + (tonumber(spirit) / 5)
			this.mana = math.floor(this.mana + manaPerTick < this.maxMana and this.mana + manaPerTick or this.maxMana)
			DruidFormManaBarFrameManaPercentage:SetText(this.mana .. "/" .. this.maxMana .. "  " .. tostring( math.floor(tonumber(this.mana) / tonumber( this.maxMana) * 100) ) .. "%")
		else
			local intellect, _, intBuff, _ = UnitStat("player", 4);
			local someBlizzardConstant = 21.5
			local baseInt = intellect - intBuff
			local baseMana = ( math.min(someBlizzardConstant, baseInt) + 15 * (baseInt - math.min(someBlizzardConstant, baseInt) ) )
			
			-- shapeshift is 55% of base mana
			local shapeshiftCost = baseMana * 0.55
			this.mana = math.floor(this.mana - shapeshiftCost)
			DruidFormManaBarFrameManaPercentage:SetText(this.mana .. "/" .. this.maxMana .. "  " .. tostring( math.floor(tonumber(this.mana) / tonumber( this.maxMana) * 100) ) .. "%")
		end	
	end

	if event == "UNIT_DISPLAYPOWER" and this.isForm then
		this.isForm = false
		this.mana = UnitMana("player")
		this.maxMana = UnitManaMax("player")
		this:Hide()
	elseif event == "UNIT_DISPLAYPOWER" then
		this.isForm = true
		this:Show()
	end
end

function DruidFormManaBar_OnUpdate()
end