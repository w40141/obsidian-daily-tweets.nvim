-- main module file
local module = require("plugin_name.module")

---@class Config
---@field opt string
---@field dir_path string Path to the directory where the daily tweets are stored
---@field file_name_pattern string Pattern of the file name
---@field heading_pattern string Keyword to search for in the file
local config = {
	opt = "default",
	dir_path = "~/obsidian-daily-tweets",
	fname_pattern = "%d%d%d%d%-%d%d%-%d%d%.md",
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
	return module.my_first_function(M.config.opt)
end

M.insert = function(insert_string)
	-- ファイル名のパターンと一致するかを確認
	local file_name = vim.fn.expand("%:t")
	if not file_name:match(M.con.file_name_pattern) then
		print("This file is not a markdown file.")
		return
	end

	-- 指定されたディレクトリパスがある場合、そのディレクトリ内のファイルのみを対象にする
	local directory_path = default_opts.directory_path
	if directory_path ~= "" and not vim.fn.isdirectory(directory_path) then
		print("Invalid directory path.")
		return
	end

	if directory_path ~= "" and not file_name:match(directory_path) then
		print("This file is not in the specified directory.")
		return
	end

	-- 挿入する文字列のフォーマットを作成 (例: "時刻: insert_string")
	local formatted_string = os.date("%H:%M") .. " " .. insert_string

	-- マークダウンファイル内で指定された見出し語を検索
	local line_num = vim.fn.line(".")
	while line_num > 1 do
		local line = vim.fn.getline(line_num)
		if line:match(M.config.heading_pattern) then
			-- 見出し語の下に挿入
			vim.fn.append(line_num, "- " .. formatted_string)
			return
		end
		line_num = line_num - 1
	end

	-- 見出し語が見つからなかった場合、新しい見出しを作成して挿入
	local new_heading = M.config.heading_pattern
	vim.fn.append("$", { new_heading, "- " .. formatted_string })
end

return M
