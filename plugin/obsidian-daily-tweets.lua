vim.api.nvim_create_user_command("ObsidianTweet", function(opts)
	require("obsidian-daily-tweets").tweet(opts)
end, {
	nargs = 1,
})

vim.api.nvim_create_user_command("ObsidianHello", require("obsidian-daily-tweets").hello, {})
