return {
	-- Installer for language servers
	{ "mason-org/mason.nvim", opts = {} },

	-- Bridges Mason and the LSP client
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = { "gopls", "jdtls" },
			automatic_enable = { exclude = { "jdtls" } },
		},
	},

	-- Default server configs + our settings
	{
		"neovim/nvim-lspconfig",
		config = function()
			local root = require("config.root")

			-- Go
			vim.lsp.config("gopls", {
				filetypes = { "go", "gomod", "gowork" },
				root_dir = function(bufnr, on_dir)
					on_dir(root.find(bufnr, { "go.work", "go.mod", ".git" }))
				end,
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
						analyses = { unusedparams = true },
					},
				},
			})

			-- Rust (installed via rustup, so enabled manually)
			vim.lsp.config("rust_analyzer", {
				root_dir = function(bufnr, on_dir)
					on_dir(root.find(bufnr, { "Cargo.toml", "rust-project.json", ".git" }))
				end,
			})
			vim.lsp.enable("rust_analyzer")

			-- Diagnostics display
			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
				float = { border = "rounded" },
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(ev)
					local tb = require("telescope.builtin")
					local function m(keys, fn, desc)
						vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
					end

					-- Go to / find
					m("gd", tb.lsp_definitions, "Go to definition")
					m("gD", vim.lsp.buf.declaration, "Go to declaration")
					m("gI", tb.lsp_implementations, "Go to implementation")
					m("gR", tb.lsp_references, "Find usages")
					m("gy", tb.lsp_type_definitions, "Go to type definition")

					-- Call hierarchy
					m("<leader>ci", tb.lsp_incoming_calls, "Who calls this (incoming)")
					m("<leader>co", tb.lsp_outgoing_calls, "What this calls (outgoing)")

					-- Symbols
					m("<leader>ss", tb.lsp_document_symbols, "Symbols in this file")
					m("<leader>sw", tb.lsp_dynamic_workspace_symbols, "Symbols in project")

					-- Existing keys
					m("<leader>d", vim.diagnostic.open_float, "Show diagnostic")
					m("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format file")
				end,
			})
		end,
	},
	-- Java: loaded only for Java files
	{ "mfussenegger/nvim-jdtls", ft = "java" },
}
