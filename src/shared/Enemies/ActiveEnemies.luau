local activeEnemiesData = {
	counter = 0,
	enemies = {},
}

function activeEnemiesData.AddEnemy(enemy: Model)
	table.insert(activeEnemiesData.enemies, enemy)
	activeEnemiesData.counter += 1
end

function activeEnemiesData.RemoveEnemy(enemy: Model)
	local enemiesList = activeEnemiesData.enemies

	for i, activeEnemy in pairs(enemiesList) do
		if activeEnemy == enemy then
			table.remove(enemiesList, i)
			break
		end
	end
end

return activeEnemiesData
