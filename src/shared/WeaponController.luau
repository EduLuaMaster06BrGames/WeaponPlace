local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ViewmodelController: {} = require(script.Parent.ViewmodelController)
local UIController: {} = require(script.Parent.UIController)
local RecoilController = require(script.Parent.RecoilController)

local constType = require(ReplicatedStorage.Shared.Constants.ConstantType)

local viewmodels = ReplicatedStorage.Viewmodels
local viewmodel_Primary = viewmodels.Viewmodel_Primary
local viewmodel_Secondary = viewmodels.Viewmodel_Secondary

local player: Player = Players.LocalPlayer
local camera: Camera = workspace.CurrentCamera

local events = ReplicatedStorage.Events
local damageEvent: RemoteFunction = events.OnDamage
-- local hitEvent: RemoteFunction = events.OnHit
-- local reloadEvent: RemoteFunction = events.OnReload

local GLOBAL_Range: number = 1000

local WeaponController = {}
WeaponController.__index = WeaponController

type RaycastInfo = {
	result: RaycastResult,
	current_direction: Vector3,
}

function WeaponController.new(constant: constType.Constant)
	local self = {
		constant = constant,
		character = player.Character,
		on_reload = false,
		on_cooldown = false,
		on_draw = false,
		enabled = false,
		reload_task = nil,
		viewmodel_module = {},
		ui_module = {},
		recoil_module = {},
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
		self.recoil_module = RecoilController.new(self.constant)
		self:DrawWeapon()
	end
end

function WeaponController:Remove()
	self.enabled = false
	self.viewmodel_module:Remove()
	self.recoil_module:Remove()

	if self.reload_task ~= nil then
		print("reload cancelled")
		task.cancel(self.reload_task)
	end

	setmetatable(self.ui_module, nil)
	setmetatable(self, nil)
end

function WeaponController:DrawWeapon()
	print("Draw Started")
	self.on_draw = true
	wait(self.constant.draw_time)
	self.on_draw = false
	print("Draw Ended")
end

function WeaponController:IsAlive(): boolean
	if self.character.Humanoid.Health > 0 then
		return true
	else
		return false
	end
end

function WeaponController:CastRay(origin: Vector3, direction, ignorePrevious: {}): RaycastInfo
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = {
		self.character,
		workspace.TestParts,
		viewmodel_Primary,
		viewmodel_Primary,
		viewmodel_Secondary,
		ignorePrevious,
	}

	if not direction then
		direction = self.recoil_module:GetBulletAccuracy(camera)
	end

	return {
		result = workspace:Raycast(origin, direction * GLOBAL_Range, params),
		current_direction = direction,
	}
end

function WeaponController:DamageTarget(headShot: boolean, humanoidInstance: Humanoid, enemiesPiersed: number)
	local damageDealt = self.constant.damage

	for i = 1, enemiesPiersed do
		damageDealt -= damageDealt * self.constant.piersing.strength_loss
	end

	if headShot then
		damageDealt *= self.constant.multiplier.head
	else
		damageDealt *= self.constant.multiplier.body
	end

	damageEvent:InvokeServer(humanoidInstance, damageDealt, self.constant)
end

function WeaponController:Reload()
	if self:CanReload() then
		self.on_reload = true
		local ammoReceived = self:AmmoCost()

		self.reload_task = task.delay(self.constant.reload_time, function()
			if self.constant.type == "Primary" then
				self.constant.ammo.reserve_ammo -= ammoReceived
			end

			self.constant.ammo.current_ammo += ammoReceived
			self.on_reload = false
			self.ui_module:UpdateAmmoDisplay()
			self.reload_task = nil
		end)
	end
end

function WeaponController:CanReload(): boolean
	local ammoData = self.constant.ammo

	print(self.reload_task)

	if
		ammoData.current_ammo < ammoData.mag_size
		and ammoData.reserve_ammo > 0
		and self.reload_task == nil
		and not self.on_draw
	then
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
	if self:IsAlive() and self:HasAmmo() and not self:OnCooldown() and not self.on_reload and not self.on_draw then
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

		for i = 1, self.constant.pellets do
			local piersingLeft = self.constant.piersing.amount
			local currentOrigin = camera.CFrame.Position
			local currentDirection = nil
			local ignorePrevious = {}

			repeat
				local rayInfo: RaycastInfo = self:CastRay(currentOrigin, currentDirection, ignorePrevious)

				if rayInfo.result and rayInfo.result.Instance ~= nil then
					self:DEBUG_PART(rayInfo.result.Position)

					local target = rayInfo.result.Instance.Parent
					local targetHumanoid: Humanoid = target:FindFirstChild("Humanoid")

					if targetHumanoid then
						local enemiesPiersed = self.constant.piersing.amount - piersingLeft
						currentOrigin = rayInfo.result.Position
						table.insert(ignorePrevious, target)

						if rayInfo.result.Instance.Name == "Head" then
							self:DamageTarget(true, targetHumanoid, enemiesPiersed)
							piersingLeft -= 1
						else
							self:DamageTarget(false, targetHumanoid, enemiesPiersed)
							piersingLeft -= 1
						end
					else
						piersingLeft = 0
					end
				else
					piersingLeft = 0
				end
			until piersingLeft <= 0
		end

		return true
	end

	return false
end

function WeaponController:DEBUG_PART(pos: Vector3)
	local testPart = Instance.new("Part", workspace:WaitForChild("TestParts"))
	testPart.Size = Vector3.new(0.5, 0.5, 0.5)
	testPart.Anchored = true
	testPart.Color = Color3.fromRGB(255, 0, 0)
	testPart.Position = pos
end

function WeaponController:SetCooldown()
	self.on_cooldown = true
	task.delay(self.constant.speed, function()
		self.on_cooldown = false
	end)
end

return WeaponController
