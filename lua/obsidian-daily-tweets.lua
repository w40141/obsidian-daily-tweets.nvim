-- main module file
local module = require("obsidian-daily-tweets.module")

---@class Config
---@field opt string
---@field dir_path string Path to the directory where the daily tweets are stored
---@field file_name_pattern string Pattern of the file name
---@field heading_pattern string Keyword to search for in the file
local config = {
	opt = "Hello",
	dir_path = "~/obsidian-daily-tweets",
	fname_pattern = "test.md",
	heading_pattern = "## tweet",
}

---@class MyModule
local M = {}

---@type Config
M.config = config

---@param args Config?
-- you can define your setup function here. Usually configurations can be merged, accepting outside params and
-- you can also put some validation here for those.
M.setup = function(args)
	M.config = vim.tbl_deep_extend("force", M.config, args or {})
end

M.hello = function()
	print(module.my_first_function(M.config.opt))
end

M.tweet = function(insert_string)
	print(insert_string)
	local fpath = M.config.dir_path .. M.config.fname_pattern
	local luh, lih, ldh = module.extract_headings(fpath, M.config.heading_pattern)
	local new_lines = module.insert_word(lih, insert_string)
	module.write_markdown_file(fpath, luh, new_lines, ldh)
end

return M
