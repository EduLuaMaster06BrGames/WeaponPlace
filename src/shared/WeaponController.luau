local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ViewmodelController: {} = require(script.Parent.ViewmodelController)
local player: Player = Players.LocalPlayer
local camera: Camera = workspace.CurrentCamera

local events = ReplicatedStorage.Shared.Events
local damageEvent: RemoteFunction = events.OnDamage
local hitEvent: RemoteFunction = events.OnHit
local reloadEvent: RemoteFunction = events.OnReload

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
		viewmodel_module = {},
	}

	setmetatable(self, WeaponController)
	self:Inicialize()
	return self
end

function WeaponController:Inicialize()
	if self:IsAlive() then
		self.enabled = true

		print(self.constant)
		print(self.constant.type)
		self.viewmodel_module = ViewmodelController.new(self.constant.type)
	end
end

function WeaponController:Remove()
	self.enabled = false
	self.viewmodel_module:Remove()
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
	damageEvent:InvokeServer(humanoidInstance, damageDealt)
	print("---")
	print("DamageDealt: " .. tostring(damageDealt))
	print("headShot: " .. tostring(headShot))
end

function WeaponController:Reload()
	print("PreviousAmmo: ", self.constant.ammo.current_ammo)

	if self:CanReload() then
		print("CanReload")
		self.constant.ammo.current_ammo = self:AmmoCost()
		reloadEvent:InvokeServer()
	end
end

function WeaponController:CanReload(): boolean
	local ammoData = self.constant.ammo

	if ammoData.current_ammo < ammoData.ammo.mag_size and ammoData.reserve_ammo > 0 then
		return true
	else
		return false
	end
end

function WeaponController:AmmoCost(): number
	local ammoData = self.constant.ammo
	local ammoNeeded = ammoData.mag_size - ammoData.current_ammo

	if ammoNeeded <= ammoData.reserve_ammo then
		ammoData.reserve_ammo -= ammoNeeded
		print("ReceivedAmmo: ", ammoNeeded)
		return ammoNeeded
	else
		if ammoData.reserve_ammo ~= 0 then
			local ammoLeft = ammoData.reserve_ammo
			ammoData.reserve_ammo = 0
			print("ReceivedAmmo: ", ammoLeft)
			return ammoLeft
		else
			print("No ammo")
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

function WeaponController:CanShoot(): boolean
	if self:IsAlive() and self:HasAmmo() then
		return true
	else
		return false
	end
end

function WeaponController:Shoot()
	if self:CanShoot() then
		self.constant.ammo.current_ammo -= 1
		print("Ammo: ", self.constant.ammo.current_ammo)
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
				print("Ground Hit")
				hitEvent:InvokeServer()
			end
		end
	end
end

return WeaponController
