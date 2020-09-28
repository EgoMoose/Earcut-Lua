local Earcut = require(game.ReplicatedStorage.Earcut)
local Screen = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")

local Maid = require(script:WaitForChild("Maid")).new()
local Dragger = require(script:WaitForChild("Dragger"))
local Draw = require(script:WaitForChild("Draw"))

local polygonFrames = {Screen.Container.Polygon1}

local HEIGHT = Vector2.new(0, 36)
local VPF = Draw.MakeVPF(Screen.Background.BackgroundColor3)
VPF.Parent = Screen.Render

local function render()
	Maid:Sweep()

	local polygons = {}

	for k, polyFrame in pairs(polygonFrames) do
		local n = #polyFrame:GetChildren()
		local vertices = {}
		for i = 1, n do
			local framei = polyFrame[i]
			local framej = polyFrame[i % n + 1]
			local posi = framei.AbsolutePosition + framei.AbsoluteSize / 2 + HEIGHT
			local posj = framej.AbsolutePosition + framej.AbsoluteSize / 2 + HEIGHT

			table.insert(vertices, posi.x)
			table.insert(vertices, posi.y)
			
			local line = Draw.Line(posi, posj)
			line.BackgroundColor3 = polyFrame.BackgroundColor3
			line.ZIndex = 2
			line.Parent = Screen.Render
			Maid:Mark(line)
		end

		local triangles = Earcut(vertices)

		for i = 1, #triangles, 3 do
			local ai = (triangles[i] * 2) + 1
			local bi = (triangles[i + 1] * 2) + 1
			local ci = (triangles[i + 2] * 2) + 1

			local a = Vector2.new(vertices[ai], vertices[ai + 1])
			local b = Vector2.new(vertices[bi], vertices[bi + 1])
			local c = Vector2.new(vertices[ci], vertices[ci + 1])

			Maid:Mark(Draw.Triangle(VPF, a, b, c, polyFrame.BackgroundColor3))
		end
	end

end

for _, polygon in pairs(polygonFrames) do
	for _, handle in pairs(polygon:GetChildren()) do
		local drag = Dragger.new(handle)
		drag.DragChanged:Connect(function(element, input, delta)
			local size = polygon.Parent.AbsoluteSize
			local pos = Vector2.new(input.Position.x, input.Position.y)
			pos = pos - polygon.Parent.AbsolutePosition

			pos = Vector2.new(
				math.clamp(pos.x, 0, size.x),
				math.clamp(pos.y, 0, size.y)
			)

			element.Position = UDim2.new(0, pos.x, 0, pos.y)
			render()
		end)
	end
end

render()

return true