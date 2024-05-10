---@class CustomModule
local M = {}

---@return string
M.my_first_function = function(greeting)
	return greeting
end

M.extract_headings = function(markdown_file, keyword)
	local f = io.open(markdown_file, "r")
	if f == nil then
		print("Invalid directory path.")
		return
	end
	local lines = f:read("*all")
	f:close()

	local in_keyword = false
	local found = false
	local lines_upper_heading = {}
	local lines_in_heading = {}
	local lines_downer_heading = {}

	for line in lines:gmatch("[^\n]+") do
		local _, _, level, text = line:find("^(#+)%s+(.+)")
		if level then
			if string.find(text, keyword, 1, true) then
				found = true
				in_keyword = true
			elseif in_keyword and found then
				in_keyword = false
			end
		end

		if not in_keyword and not found then
			table.insert(lines_upper_heading, line)
		elseif in_keyword and found then
			table.insert(lines_in_heading, line)
		elseif not in_keyword and found then
			table.insert(lines_downer_heading, line)
		end
	end

	return lines_upper_heading, lines_in_heading, lines_downer_heading
end

M.insert_word = function(lines_in_heading, add_word)
	local reversed_lines_in_heading = {}
	for i = #lines_in_heading, 1, -1 do
		table.insert(reversed_lines_in_heading, lines_in_heading[i])
	end

	local skip_lines = {}
	local start_lines = {}
	for i, line in ipairs(reversed_lines_in_heading) do
		if line == "" then
			table.insert(skip_lines, line)
		else
			start_lines = { table.unpack(lines_in_heading, 1, #lines_in_heading - i) }
			break
		end
	end

	local add_tweet = "- " .. os.date("%H:%M:%S") .. " " .. add_word .. "\n"
	local new_lines = {}
	for _, line in ipairs(start_lines) do
		table.insert(new_lines, line)
	end
	table.insert(new_lines, add_tweet)
	for _, line in ipairs(skip_lines) do
		table.insert(new_lines, line)
	end

	return new_lines
end

M.write_markdown_file = function(markdown_file, lines_upper_heading, lines_in_heading, lines_downer_heading)
	local f = io.open(markdown_file, "w")
	if f == nil then
		print("Invalid directory path.")
		return
	end
	for _, line in ipairs(lines_upper_heading) do
		f:write(line, "\n")
	end
	for _, line in ipairs(lines_in_heading) do
		f:write(line, "\n")
	end
	for _, line in ipairs(lines_downer_heading) do
		f:write(line, "\n")
	end
	f:close()
end

return M
