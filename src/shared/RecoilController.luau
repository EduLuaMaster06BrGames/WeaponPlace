local RecoilController = {}
RecoilController.__index = RecoilController

export type Constant = {
	damage: number,
	speed: number,
	ammo: {
		current_ammo: number,
		mag_size: number,
		reserve_ammo: number,
	},
	accuracy: {
		min_accuracy: number,
		max_accuracy: number,
		recovery_rate: number,
		recoil_rate: number,
	},
	reload_time: number,
	mode: string,
	type: string,
	multiplier: {
		head: number,
		body: number,
	},
}

function RecoilController.new(constant: Constant)
	local self = {
		constant = constant,
		recovery_task = nil,
		current_accuracy = constant.accuracy.min_accuracy,
	}

	setmetatable(self, RecoilController)
	self.recovery_task = task.spawn(function()
		self:NewRecoveryTask()
	end)
	return self
end

function RecoilController:Remove()
	if self.recovery_task ~= nil then
		task.cancel(self.recovery_task)
	end
	setmetatable(self, nil)
end

function RecoilController:AddRecoil()
	self.current_accuracy =
		math.min(self.current_accuracy + self.constant.accuracy.recoil_rate, self.constant.accuracy.max_accuracy)
end

function RecoilController:NewRecoveryTask()
	while wait() do
		self.current_accuracy =
			math.max(self.current_accuracy - self.constant.accuracy.recovery_rate, self.constant.accuracy.min_accuracy)
		print(self.current_accuracy)
	end
end

return RecoilController
