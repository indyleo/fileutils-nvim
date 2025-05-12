-- init.lua
local M = {}

function M.setup()
  -- Files
  local Fheader = require "fileutils.functions.FileHeader"
  local Ffilehelper = require "fileutils.functions.FileHelper"
  local Fcodeblock = require "fileutils.functions.CodeBlockToFile"
  local FTerminal = require "fileutils.functions.Terminal"

  -- Commands

  -- Markdown
  vim.api.nvim_create_user_command("MarkdownCode", function()
    Fcodeblock.extract_code_blocks()
  end, { nargs = 0 })

  -- File
  vim.api.nvim_create_user_command("OilDir", function(opts)
    Ffilehelper.OilDir(opts)
  end, {
    nargs = 1,
    complete = "file",
  })

  vim.api.nvim_create_user_command("EditFile", function(opts)
    Ffilehelper.EditFile(opts)
  end, {
    nargs = "+",
    complete = "file",
  })

  vim.api.nvim_create_user_command("AskNewFileName", function(args)
    Ffilehelper.AskNewFileName { filename = args.args }
  end, {
    nargs = 1,
    desc = "Create and open a new file in the current working directory",
  })

  vim.api.nvim_create_user_command("NewHSplit", function(args)
    Ffilehelper.NewHSplit { path = args.args }
  end, {
    nargs = 1,
    complete = "file",
    desc = "Open a file in a new horizontal split",
  })

  vim.api.nvim_create_user_command("NewVSplit", function(args)
    Ffilehelper.NewVSplit { path = args.args }
  end, {
    nargs = 1,
    complete = "file",
    desc = "Open a file in a new vertical split",
  })

  -- Header
  vim.api.nvim_create_user_command("FileHeader", function()
    Fheader.InsertFileHeader()
  end, { nargs = 0 })

  -- Terminal
  vim.api.nvim_create_user_command("ToggleTerminal", function()
    FTerminal.toggle_terminal()
  end, {
    nargs = 0,
    desc = "Toggle terminal",
  })

  vim.api.nvim_create_user_command("ToggleLazygit", function()
    FTerminal.toggle_lazygit()
  end, {
    nargs = 0,
    desc = "Toggle lazygit terminal",
  })
end

return M
