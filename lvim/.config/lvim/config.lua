-- LunarVim configuration
-- Read the docs: https://www.lunarvim.org/docs/configuration

-- Plugins
lvim.plugins = {
	-- Color scheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
	},
	-- Copilot integration with completion framework
	{
		"zbirenbaum/copilot-cmp",
		event = "InsertEnter",
		dependencies = {
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				config = function()
					require("copilot").setup({
						suggestion = { enabled = false },
						panel = { enabled = false },
					})
				end,
			},
		},
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	-- Neotest for testing support
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"sidlatau/neotest-dart",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-dart")({
						command = "flutter",
						use_lsp = true,
					}),
				},
			})
		end,
	},
	-- Flutter tools
	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim", -- Optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup({
				flutter_path = "/home/plaugh/fvm/default/bin/flutter",
				ui = {
					border = "rounded",
					notification_style = "plugin",
				},
				decorations = {
					statusline = {
						app_version = true,
						device = true,
					},
				},
				outline = {
					open_cmd = "30vnew",
					auto_open = false,
				},
				debugger = {
					enabled = true,
					run_via_dap = true,
					register_configurations = function()
						local dap = require("dap")
						dap.configurations.dart = {
							{
								type = "dart",
								request = "launch",
								name = "Launch Flutter",
								program = "${workspaceFolder}/lib/main.dart",
								cwd = "${workspaceFolder}",
							},
						}
						require("dap.ext.vscode").load_launchjs()
					end,
				},
				dev_log = {
					enabled = true,
					open_cmd = "tabedit",
				},
				lsp = {
					color = {
						enabled = true,
						background = false,
						foreground = false,
						virtual_text = true,
						virtual_text_str = "■",
					},
					on_attach = require("lvim.lsp").common_on_attach,
					capabilities = require("lvim.lsp").common_capabilities(),
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						renameFilesWithClasses = "prompt",
						enableSnippets = true,
					},
				},
			})
		end,
	},
}

-- Disable automatic configuration for dartls to prevent conflicts with flutter-tools
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "dartls" })

-- Format on save for specific file types
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.dart", "*.lua", "*.ts", "*.js", "*.kt", "*.py", "*.tsx", "*.jsx" }
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ name = "stylua" },
})

-- Set colorscheme
lvim.colorscheme = "catppuccin"

-- Disable virtual text for diagnostics
vim.diagnostic.config({
	virtual_text = false,
})

-- Show diagnostics in a floating window on hover
vim.cmd([[
  autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})
]])

-- Key mappings for Flutter commands
lvim.keys.normal_mode["<leader>hs"] = ":FlutterRun<CR>"
lvim.keys.normal_mode["<leader>hq"] = ":FlutterQuit<CR>"
lvim.keys.normal_mode["<leader>hr"] = ":FlutterReload<CR>"
lvim.keys.normal_mode["<leader>hR"] = ":FlutterRestart<CR>"

-- Key mappings for DAP
vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "", linehl = "", numhl = "" })
vim.api.nvim_set_keymap("n", "<F5>", ':lua require"dap".continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F10>", ':lua require"dap".step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F11>", ':lua require"dap".step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F12>", ':lua require"dap".step_out()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<leader>dt",
	':lua require"dap".toggle_breakpoint()<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>Y",
	':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>lp",
	':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
	{ noremap = true, silent = true }
)
vim.api.nvim_set_keymap("n", "<leader>dr", ':lua require"dap".repl.open()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dl", ':lua require"dap".run_last()<CR>', { noremap = true, silent = true })

-- Key mappings for Neotest
lvim.keys.normal_mode["<leader>tn"] = "<cmd>lua require('neotest').run.run()<CR>"
lvim.keys.normal_mode["<leader>tf"] = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>"
lvim.keys.normal_mode["<leader>td"] = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>"
lvim.keys.normal_mode["<leader>to"] = "<cmd>lua require('neotest').summary.toggle()<CR>"
