local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RecoilController = {}
RecoilController.__index = RecoilController

local constType = require(ReplicatedStorage.Shared.Hero.Types.WeaponConstantType)

function RecoilController.new(constant: constType.Constant)
	local self = {
		constant = constant,
	}

	setmetatable(self, RecoilController)
	return self
end

function RecoilController:Remove()
	setmetatable(self, nil)
end

function RecoilController:GetBulletAccuracy(camera: Camera): Vector3
	local accuracy_X: number = math.random(-self.constant.accuracy * 10, self.constant.accuracy * 10)
	local accuracy_Y: number = math.random(-self.constant.accuracy * 10, self.constant.accuracy * 10)
	local accuracy_Z: number = math.random(-self.constant.accuracy * 10, self.constant.accuracy * 10)

	local direction: Vector3 = camera.CFrame.LookVector
	direction = RotateX(direction, accuracy_X / 10)
	direction = RotateY(direction, accuracy_Y / 10)
	direction = RotateZ(direction, accuracy_Z / 10)
	return direction
end

function RotateX(vec, angle)
	local radians = math.rad(angle)
	local cosAngle = math.cos(radians)
	local sinAngle = math.sin(radians)
	return Vector3.new(vec.X, vec.Y * cosAngle - vec.Z * sinAngle, vec.Y * sinAngle + vec.Z * cosAngle)
end

function RotateY(vec, angle)
	local radians = math.rad(angle)
	local cosAngle = math.cos(radians)
	local sinAngle = math.sin(radians)
	return Vector3.new(vec.X * cosAngle + vec.Z * sinAngle, vec.Y, -vec.X * sinAngle + vec.Z * cosAngle)
end

function RotateZ(vec, angle)
	local radians = math.rad(angle)
	local cosAngle = math.cos(radians)
	local sinAngle = math.sin(radians)
	return Vector3.new(vec.X * cosAngle - vec.Y * sinAngle, vec.X * sinAngle + vec.Y * cosAngle, vec.Z)
end

return RecoilController
