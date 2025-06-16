-- init.lua

local M = {}

function M.setup()
  -- Files
  local Fheader = require "fileutils.functions.FileHeader"
  local Ffilehelper = require "fileutils.functions.FileHelper"
  local Fcodeblock = require "fileutils.functions.CodeBlockToFile"
  local FTerminal = require "fileutils.functions.Terminal"
  local mkcmd = vim.api.nvim_create_user_command

  -- Commands

  -- Markdown
  mkcmd("MarkdownCode", function()
    Fcodeblock.extract_code_blocks()
  end, { nargs = 0 })

  -- File
  mkcmd("OilDir", function(opts)
    Ffilehelper.OilDir(opts)
  end, {
    nargs = 1,
    complete = "file",
  })

  mkcmd("EditFile", function(opts)
    Ffilehelper.EditFile(opts)
  end, {
    nargs = "+",
    complete = "file",
  })

  -- Header
  mkcmd("FileHeader", function()
    Fheader.InsertFileHeader()
  end, { nargs = 0 })

  -- Terminal
  mkcmd("ToggleTerminal", function()
    FTerminal.toggle_terminal()
  end, {
    nargs = 0,
    desc = "Toggle terminal",
  })

  mkcmd("ToggleLazygit", function()
    FTerminal.toggle_lazygit()
  end, {
    nargs = 0,
    desc = "Toggle lazygit terminal",
  })

  mkcmd("CommandRun", function(args)
    FTerminal.command_run(args.args)
  end, {
    nargs = "+",
    complete = "shellcmd",
    desc = "Run command in terminal",
  })

  mkcmd("CommandRunForever", function(args)
    FTerminal.command_run_forever(args.args)
  end, {
    nargs = "+",
    complete = "shellcmd",
    desc = "Run command in terminal forever",
  })
end

return M
