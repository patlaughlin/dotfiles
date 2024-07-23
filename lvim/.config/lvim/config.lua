-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny


lvim.plugins = {
  { "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
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
require('telescope').load_extension('flutter')

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
lvim.colorscheme = "gruvbox"
vim.diagnostic.config({
  virtual_text = false,
})

vim.cmd [[
    autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})
]]
