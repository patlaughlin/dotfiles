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
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({})
    end
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false }
      })
    end
  },
  {
    "akinsho/flutter-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup {
        flutter_path = "/home/plaugh/fvm/default/bin/flutter",
        ui = {
          border = "rounded",
          notification_style = "plugin",
        }, debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
          require("dap").configurations.dart = {}
          require("dap.ext.vscode").load_launchjs()
        end,
      },
        dev_log = {
          enabled = true,
          open_cmd = "tabedit",
        },
        widget_guides = {
          enabled = true,
          debug = true,
        },
        lsp = {
          color = {
            enabled = true,
            background = false,
            background_color = { r = 220, g = 223, b = 228 },
            foreground = false,
            virtual_text = true,
            virtual_text_str = '■',
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            enableSdkFormatter = true,
          },
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        }
      }
    end,
  }
}

-- Below config is required to prevent copilot overriding Tab with a suggestion
-- when you're just trying to indent!
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
local on_tab = vim.schedule_wrap(function(fallback)
  local cmp = require("cmp")
  if cmp.visible() and has_words_before() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
  else
    fallback()
  end
end)
lvim.builtin.cmp.mapping["<Tab>"] = on_tab


lvim.format_on_save.enabled = true
lvim.keys.normal_mode["<leader>fr"] = ":FlutterRun<CR>"
lvim.keys.normal_mode["<leader>fq"] = ":FlutterQuit<CR>"
lvim.keys.normal_mode["<leader>fR"] = ":FlutterRestart<CR>"

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "dartls" })
lvim.format_on_save.pattern = { "*.dart", "*.lua", "*.ts", "*.js", "*.kt" }
