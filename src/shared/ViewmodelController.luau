local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local viewmodels = ReplicatedStorage.Shared.Viewmodels

local ViewmodelController = {}
ViewmodelController.__index = ViewmodelController

function ViewmodelController.new(weaponType: string)
	local self = {
		model = nil,
		offset = Vector3.new(0, 0, 0),
		pivotTask = nil,
		enabled = false,
		weapon_type = weaponType,
	}

	setmetatable(self, ViewmodelController)
	self:Inicialize()
	return self
end

function ViewmodelController:Inicialize()
	self.enabled = true
	self.pivotTask = self:SetPivot()
	self.model = self:SetViewmodel()
	self.model.Parent = workspace
end

function ViewmodelController:SetViewmodel()
	return viewmodels:FindFirstChild("Viewmodel_" .. self.weapon_type)
end

function ViewmodelController:Remove()
	if self.pivotTask ~= nil then
		task.cancel(self.pivotTask)
	end

	self.enabled = false
	self.model.Parent = viewmodels
end

function ViewmodelController:SetPivot()
	return task.spawn(function()
		RunService.RenderStepped:Connect(function()
			self.model:PivotTo(camera.CFrame)
		end)
	end)
end

return ViewmodelController
