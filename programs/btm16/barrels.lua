local component = require("component")

barrels = {}
emitters = {}

local i = 0
local j = 0
for k,v in component.list() do
	if v == "yot_barrel" then
		barrels[i] = component.get(v)
		i = i + 1
	elseif v == "redstone" then
		emitters[j] = component.get(v)
		j = j + 1
	end
end

while true do
	for i=0,2 do
		if barrels[i].getFluidAmount() >= 40000 then
			emitters[i].setOutput(south, 15)
		else
			emitters[i].setOutput(south, 0)
		end
	end
	os.sleep(2)
end
