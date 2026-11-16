local map = vim.keymap.set

-- Disable arrow keys (forces hjkl)
for _, key in ipairs({ "<Up>", "<Down>", "<Left>", "<Right>" }) do
	map({ "n", "i", "v" }, key, function()
		vim.notify("Use h j k l", vim.log.levels.WARN)
	end, { desc = "Arrow key disabled" })
end

-- Esc Key Configurations
map('i', "jj", "<Esc>", { noremap = false, desc = "Switch to Normal mode"})


-- Telescope
map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Telescope find files" })
map("n", "<leader>fg", function() require("telescope.builtin").live_grep() end, { desc = "Telescope live grep" })
map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Telescope buffers" })
map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Telescope help tags" })

-- File explorer
map("n", "<leader>oe", ":Neotree filesystem reveal left<CR>", { desc = "Opens Neo-Tree" })

-- Indentation (<leader>i prefix)
map("n", "<leader>ii", "==", { desc = "Indent current line" })
map("v", "<leader>ii", "=", { desc = "Indent selection" })
map("n", "<leader>i{", "mz=i{`z", { desc = "Indent inside { } block" })
map("n", "<leader>ip", "mz=ap`z", { desc = "Indent paragraph/block" })
map("n", "<leader>iG", "mzgg=G`z", { desc = "Indent whole file" })
