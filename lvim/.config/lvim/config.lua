-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   {
--     name = "stylua",
--     filetypes = { "lua" },
--     args = { "--line-width", "80"}
--   },
-- }

lvim.plugins = {
  {
    "github/copilot.vim",
    event = "InsertEnter"
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },    -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}

-- -- Below config is required to prevent copilot overriding Tab with a suggestion
-- -- when you're just trying to indent!
-- local has_words_before = function()
--   if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
--   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--   return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
-- end
-- local on_tab = vim.schedule_wrap(function(fallback)
--   local cmp = require("cmp")
--   if cmp.visible() and has_words_before() then
--     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
--   else
--     fallback()
--   end
-- end)
-- lvim.builtin.cmp.mapping["<Tab>"] = on_tab


lvim.format_on_save.enabled = true
lvim.keys.normal_mode["<leader>fr"] = ":FlutterRun<CR>"
lvim.keys.normal_mode["<leader>fq"] = ":FlutterQuit<CR>"
lvim.keys.normal_mode["<leader>fR"] = ":FlutterRestart<CR>"
-- lvim.keys.normal_mode["<leader>ccp"] = ":CopilotChatToggle<CR>"

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "dartls" })
lvim.format_on_save.pattern = { "*.dart", "*.lua", "*.ts", "*.js", "*.kt" }
