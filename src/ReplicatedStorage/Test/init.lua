local Earcut = require(game.ReplicatedStorage.Earcut).Earcut

local triangles = Earcut({0,0, 100,0, 100,100, 0,100,  20,20, 80,20, 80,80, 20,80}, {4})

print(table.concat(triangles, ", "))

return true