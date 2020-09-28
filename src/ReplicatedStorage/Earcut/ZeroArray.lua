local module = {}

function module.new(array)
	local userdata = newproxy(true)
	local mt = getmetatable(userdata)
	
	mt.Array = array or {}

	function mt.__index(t, k)
		return mt.Array[k + 1]
	end

	function mt.__newindex(t, k, v)
		mt.Array[k + 1] = v
	end

	function mt.__len()
		return #mt.Array
	end

	return userdata
end

function module.getOneIndex(zeroArray)
	local mt = getmetatable(zeroArray)
	return mt.Array
end

function module.push(zeroArray, value)
	zeroArray[#zeroArray] = value
end

function module.sort(zeroArray, sortFunc)
	table.sort(module.getOneIndex(zeroArray), sortFunc)
end

function module.pop(zeroArray)
	local n = #zeroArray - 1
	local value = zeroArray[n]
	zeroArray[n] = nil
	return value
end

return module