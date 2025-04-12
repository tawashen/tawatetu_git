--find_max

function find_max(t)
	local result = 10000
	for _, num in pairs(t) do
		if result > num then
		result = num
		end
	end
		return result
end

local test = {1,2,3,4,5,100,6}
print(find_max(test))