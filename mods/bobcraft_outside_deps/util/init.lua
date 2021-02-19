bobutil = {}

bobutil.titleize = function(str)
	str = str:gsub("_", " ")
	return str:gsub("^%l", string.upper)
end