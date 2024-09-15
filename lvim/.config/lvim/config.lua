-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny


lvim.plugins = {
  -- { "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function() require("copilot_cmp").setup() end,
    dependencies = {
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
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "sidlatau/neotest-dart",
      "nvim-neotest/nvim-nio" 
    },
    config = function()
      require("neotest").setup {
        adapters = {
          require("neotest-dart") {
            command = 'flutter', -- Command to run tests, can be adjusted if using FVM or Dart only tests
            use_lsp = true -- Use LSP for Flutter outline information
          }
        }
      }
    end
  },
  -- {
  --   "github/copilot.vim",
  --   event = "InsertEnter"
  -- },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   branch = "canary",
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  --     { "github/copilot.vim" },    -- or github/copilot.vim
  --   },
  --   opts = {
  --     -- See Configuration section for rest
  --     debug = true, -- Enable debugging
  --   },
  --   -- See Commands section for default commands if you want to lazy load on them
  -- },
  -- pre-dap
  {
    lazy = false,
    'akinsho/flutter-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
    lsp = {
      on_attach = require("lvim.lsp").common_on_attach,
      capabilities = require("lvim.lsp").common_capabilities,
    },
  },
}

-- require("lspconfig").dartls.setup {
--   on_attach = require("lvim.lsp").common_on_attach,
--   capabilities = require("lvim.lsp").common_capabilities,
-- }

vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })

-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""
-- vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
--
lvim.format_on_save.enabled = true
lvim.keys.normal_mode["<leader>fr"] = ":FlutterRun<CR>"
lvim.keys.normal_mode["<leader>fq"] = ":FlutterQuit<CR>"
lvim.keys.normal_mode["<leader>fR"] = ":FlutterRestart<CR>"
lvim.keys.normal_mode["<leader>gh"] = ":CopilotChatToggle<CR>"

-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "dartls" })
lvim.format_on_save.pattern = { "*.dart", "*.lua", "*.ts", "*.js", "*.kt", "*.py", "*.tsx", "*.jsx" }
lvim.colorscheme = "catppuccin"
vim.diagnostic.config({
  virtual_text = false,
})

vim.cmd [[
    autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})
]]


-- flutter-tools configuration
require('flutter-tools').setup {
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
    settings = {
      showTodos = true,
      completeFunctionCalls = true,
      renameFilesWithClasses = "prompt",
      enableSnippets = true,
    },
  },
}

-- nvim-dap configuration
local dap = require('dap')
local dapui = require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


-- Add this to your LazyVim key mappings configuration file (e.g., keymaps.lua)

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }


-- Keybindings for nvim-dap
vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.api.nvim_set_keymap('n', '<F5>', ':lua require"dap".continue()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F10>', ':lua require"dap".step_over()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F11>', ':lua require"dap".step_into()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F12>', ':lua require"dap".step_out()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dt', ':lua require"dap".toggle_breakpoint()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>Y', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>lp',
  ':lua require"dap".set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dr', ':lua require"dap".repl.open()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>dl', ':lua require"dap".run_last()<CR>', { noremap = true, silent = true })

-- Test key mappings
lvim.keys.normal_mode["<leader>tn"] = "<cmd>lua require('neotest').run.run()<CR>"
lvim.keys.normal_mode["<leader>tf"] = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>"
lvim.keys.normal_mode["<leader>td"] = "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>"
lvim.keys.normal_mode["<leader>to"] = "<cmd>lua require('neotest').summary.toggle()<cr>"
