local ServerScriptService = game:GetService("ServerScriptService")
local EnemyClass = require(ServerScriptService.Server.Enemies.Enemy.EnemyClass)
local enemySpawnPointFolder: Part = workspace:WaitForChild("EnemySpawnPoints")

local enemySpawnModule = {}

function enemySpawnModule.SpawnEnemies(amount: number)
	print("Start Spawn: ", amount)
	local enemiesLeft = amount
	local spawnPoints = enemySpawnPointFolder:GetChildren()

	for spawn_i = 1, #spawnPoints do
		if enemiesLeft > 0 then
			if spawnPoints[spawn_i] and spawnPoints[spawn_i]:IsA("Part") then
				local groupAmount = math.random(1, enemiesLeft)
				print("Spawning: ", groupAmount)
				enemiesLeft -= groupAmount

				for group_i = 1, groupAmount do
					EnemyClass.new(spawnPoints[spawn_i].Position)
					wait(0.25)
				end
			end
		end
	end
end

return enemySpawnModule
