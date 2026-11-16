local M = {}

-- Folder where `nvim` was started (evaluated once)
M.launch_dir = vim.fn.getcwd()

-- Name of the explicit marker file
M.marker = ".nvimroot"

-- Priority: 1) explicit marker  2) normal markers  3) launch folder
function M.find(bufnr, markers)
	return vim.fs.root(bufnr, { M.marker })
		or vim.fs.root(bufnr, markers)
		or M.launch_dir
end

-- Read the marker file: one entry per line, blank lines and # comments ignored
function M.read_marker(root)
	local path = root .. "/" .. M.marker
	if vim.fn.filereadable(path) == 0 then
		return {}
	end
	local entries = {}
	for _, line in ipairs(vim.fn.readfile(path)) do
		line = vim.trim(line)
		if line ~= "" and not line:match("^#") then
			table.insert(entries, line)
		end
	end
	return entries
end

-- :MarkRoot creates the marker in the current working directory
vim.api.nvim_create_user_command("MarkRoot", function()
	local path = vim.fn.getcwd() .. "/" .. M.marker
	if vim.fn.filereadable(path) == 0 then
		vim.fn.writefile({ "# Java source folders, one per line (relative to this folder)", "# src" }, path)
	end
	vim.notify("Root marked: " .. vim.fn.getcwd())
end, {})

return M
