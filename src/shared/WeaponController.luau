local Players = game:GetService("Players")
--local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ViewmodelController: {} = require(script.Parent.ViewmodelController)
local UIController: {} = require(script.Parent.UIController)
local player: Player = Players.LocalPlayer
local camera: Camera = workspace.CurrentCamera

--local events = ReplicatedStorage.Events
-- local damageEvent: RemoteFunction = events.OnDamage
-- local hitEvent: RemoteFunction = events.OnHit
-- local reloadEvent: RemoteFunction = events.OnReload

local GLOBAL_Range: number = 1000

local WeaponController = {}
WeaponController.__index = WeaponController

export type Constant = {
	damage: number,
	speed: number,
	ammo: {
		current_ammo: number,
		mag_size: number,
		reserve_ammo: number,
	},
	reload_time: number,
	mode: string,
	type: string,
	multiplier: {
		head: number,
		body: number,
	},
}

function WeaponController.new(constant: Constant)
	local self = {
		constant = constant,
		character = player.Character,
		on_cooldown = false,
		on_draw = false,
		enabled = false,
		reload_task = nil,
		viewmodel_module = {},
		ui_module = {},
	}

	setmetatable(self, WeaponController)
	self:Inicialize()
	return self
end

function WeaponController:Inicialize()
	if self:IsAlive() then
		self.enabled = true
		self.viewmodel_module = ViewmodelController.new(self.constant.type)
		self.ui_module = UIController.new(self.constant)
	end
end

function WeaponController:Remove()
	self.enabled = false
	self.viewmodel_module:Remove()

	if self.reload_task ~= nil then
		print("reload cancelled")
		task.cancel(self.reload_task)
	end

	setmetatable(self.ui_module, nil)
	setmetatable(self, nil)
end

function WeaponController:IsAlive(): boolean
	if self.character.Humanoid.Health > 0 then
		return true
	else
		return false
	end
end

function WeaponController:CastRay(): RaycastResult
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { self.character }
	return workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * GLOBAL_Range)
end

function WeaponController:DamageTarget(headShot: boolean, humanoidInstance: Humanoid)
	local damageDealt = self.constant.damage
	if headShot then
		damageDealt *= self.constant.multiplier.head
	else
		damageDealt *= self.constant.multiplier.body
	end
	--damageEvent:InvokeServer(humanoidInstance, damageDealt)
	print("---")
	print("DamageDealt: " .. tostring(damageDealt))
	print("headShot: " .. tostring(headShot))
end

function WeaponController:Reload()
	if self:CanReload() then
		local ammoReceived = self:AmmoCost()

		self.reload_task = task.delay(self.constant.reload_time, function()
			if self.constant.type == "Primary" then
				self.constant.ammo.reserve_ammo -= ammoReceived
			end

			self.constant.ammo.current_ammo += ammoReceived
			self.ui_module:UpdateAmmoDisplay()
			return nil
		end)
		--reloadEvent:InvokeServer()
	end
end

function WeaponController:CanReload(): boolean
	local ammoData = self.constant.ammo

	if ammoData.current_ammo < ammoData.mag_size and ammoData.reserve_ammo > 0 then
		return true
	else
		return false
	end
end

function WeaponController:AmmoCost(): number
	local ammoData = self.constant.ammo
	local ammoNeeded = ammoData.mag_size - ammoData.current_ammo

	if ammoNeeded <= ammoData.reserve_ammo then
		return ammoNeeded
	else
		if ammoData.reserve_ammo ~= 0 then
			local ammoLeft = ammoData.reserve_ammo
			return ammoLeft
		else
			return 0
		end
	end
end

function WeaponController:HasAmmo(): boolean
	local ammoData = self.constant.ammo

	if ammoData.current_ammo > 0 then
		return true
	else
		return false
	end
end

function WeaponController:OnCooldown(): boolean
	if self.on_cooldown then
		return true
	else
		return false
	end
end

function WeaponController:CanShoot(): boolean
	if self:IsAlive() and self:HasAmmo() and not self:OnCooldown() then
		return true
	else
		return false
	end
end

function WeaponController:WasteAmmo()
	self.constant.ammo.current_ammo -= 1
end

function WeaponController:Shoot(): boolean
	if self:CanShoot() then
		self:SetCooldown()
		self:WasteAmmo()
		self.ui_module:UpdateAmmoDisplay()

		local rayResult: RaycastResult = self:CastRay()

		if rayResult and rayResult.Instance ~= nil then
			local target = rayResult.Instance.Parent
			local targetHumanoid: Humanoid = target:FindFirstChild("Humanoid")

			if targetHumanoid then
				if rayResult.Instance.Name == "Head" then
					self:DamageTarget(true, targetHumanoid)
				else
					self:DamageTarget(false, targetHumanoid)
				end
			else
				--hitEvent:InvokeServer()
			end
		end

		return true
	end

	return false
end

function WeaponController:SetCooldown()
	self.on_cooldown = true
	task.delay(self.constant.speed, function()
		self.on_cooldown = false
	end)
end

return WeaponController
