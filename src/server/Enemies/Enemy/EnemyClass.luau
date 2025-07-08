local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local PhysicsService = game:GetService("PhysicsService")

local enemyModelFolder = ServerStorage.EnemyFolder
local enemyBaseModel = enemyModelFolder.Enemy
local activeEnemiesData = require(ReplicatedStorage.Shared.Enemies.ActiveEnemies)
local activeEnemiesFolder = workspace:WaitForChild("Enemies")
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
local updateWIL_Event: RemoteEvent = eventsFolder:FindFirstChild("UpdateWeaponIgnoreList")

local collisionGroup = "NoEnemyCollision"

local Enemy = {}
Enemy.__index = Enemy

function Enemy.new(newOrigin: Vector3)
	local self = {
		origin = newOrigin,
		model = nil,
		humanoid = nil,
		haltEnemyBind = nil,
		startEnemyBind = nil,
	}

	setmetatable(self, Enemy)
	self:Inicialize()
end

function Enemy:Inicialize()
	self:CreateModel()

	self:SetOrigin()

	self:SetCollisionGroup()

	self:SetClosures()
end

function Enemy:CreateModel()
	local newEnemyModel: Model = enemyBaseModel:Clone()
	activeEnemiesData.AddEnemy(newEnemyModel)
	newEnemyModel.Name = "Enemy" .. tostring(activeEnemiesData.counter)
	newEnemyModel.Parent = enemyModelFolder

	local pathfindingFolder = newEnemyModel:WaitForChild("Pathfinding")
	local haltEnemyBind: BindableFunction = pathfindingFolder:WaitForChild("HaltEnemy")
	local startEnemyBind: BindableFunction = pathfindingFolder:WaitForChild("StartEnemy")

	self.haltEnemyBind = haltEnemyBind
	self.startEnemyBind = startEnemyBind
	self.model = newEnemyModel
end

function Enemy:SetCollisionGroup()
	local enemyModel: Model = self.model

	if not PhysicsService:IsCollisionGroupRegistered(collisionGroup) then
		PhysicsService:RegisterCollisionGroup(collisionGroup)
	end

	ContentProvider:PreloadAsync(enemyModel:GetDescendants(), function()
		for _, descendant in pairs({ enemyModel }) do
			if descendant:IsA("BasePart") and descendant:IsDescendantOf(workspace) then
				descendant.CollisionGroup = collisionGroup
				descendant:SetNetworkOwner(nil)
			end
		end
	end)
end

function Enemy:SetClosures()
	local enemyModel: Model = self.model
	local enemyHumanoid = enemyModel:WaitForChild("Humanoid")

	if enemyHumanoid:IsA("Humanoid") then
		enemyHumanoid.Died:Connect(function()
			task.delay(3, function()
				self:OnDeath()
			end)
		end)
		enemyHumanoid:GetPropertyChangedSignal("Health"):Connect(function()
			self:OnHit()
		end)

		self.humanoid = enemyHumanoid
	end
end

function Enemy:OnDeath()
	self.haltEnemyBind:Invoke()
	if self.model then
		Enemy.RemoveFromEnemyList(self.model)
		self.model:Destroy()
	end
end

function Enemy.RemoveFromEnemyList(enemy: Model)
	local activeEnemies = activeEnemiesData.enemies

	for i = 1, #activeEnemies do
		if activeEnemies[i] == enemy then
			table.remove(activeEnemies, i)
			print(activeEnemies)
			return
		end
	end
end

function Enemy:OnHit()
	print(self.model.Name .. " was hit")
end

function Enemy:SetOrigin()
	local enemyModel: Model = self.model
	local originCFrame = CFrame.new(self.origin)
	enemyModel:PivotTo(originCFrame)
	enemyModel.Parent = activeEnemiesFolder
	updateWIL_Event:FireAllClients(enemyModel, "SeparationHitbox", true)
end

return Enemy
