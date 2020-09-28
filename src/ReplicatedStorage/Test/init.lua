local HTTP = game:GetService("HttpService")
local URL = "https://api.github.com/repos/mapbox/earcut/contents/test/fixtures"

local Earcut = require(game.ReplicatedStorage.Earcut)

local directory = HTTP:JSONDecode(HTTP:GetAsync(URL))
local expected = HTTP:JSONDecode(HTTP:GetAsync("https://raw.githubusercontent.com/mapbox/earcut/master/test/expected.json"))

for _, item in pairs(directory) do
	print(item.name)

	local json = HTTP:JSONDecode(HTTP:GetAsync(item.download_url))
	local data = Earcut.Flatten(json)

	local indices = Earcut(data.vertices, data.holes, data.dimensions)
	local deviation = Earcut.Deviation(data.vertices, data.holes, data.dimensions, indices)
	
	local id = item.name:sub(1, #item.name - 5)
	local expectedTriangles = expected.triangles[id]
	local expectedDeviation = expected.errors[id] or 0

	local numTriangles = #indices / 3

	print(("Triangles => calculated: %s, expected %s"):format(numTriangles, expectedTriangles))
	print(("Deviation => calculated: %s, expected %s"):format(deviation, expectedDeviation))
	print("")
end


return true