-- init.lua

local M = {}

function M.setup()
  -- Files
  local Fheader = require "fileutils.functions.FileHeader"
  local Ffilehelper = require "fileutils.functions.FileHelper"
  local Fcodeblock = require "fileutils.functions.CodeBlockToFile"
  local FTerminal = require "fileutils.functions.Terminal"
  local FCword = require "fileutils.functions.Cword"
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

  mkcmd("AskNewFileName", function(args)
    Ffilehelper.AskNewFileName { filename = args.args }
  end, {
    nargs = 1,
    desc = "Create and open a new file in the current working directory",
  })

  mkcmd("NewHSplit", function(args)
    Ffilehelper.NewHSplit { path = args.args }
  end, {
    nargs = 1,
    complete = "file",
    desc = "Open a file in a new horizontal split",
  })

  mkcmd("NewVSplit", function(args)
    Ffilehelper.NewVSplit { path = args.args }
  end, {
    nargs = 1,
    complete = "file",
    desc = "Open a file in a new vertical split",
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

  mkcmd("SwapNext", function()
    FCword.replace(false)
  end, { desc = "Cycle replacement forward" })

  mkcmd("SwapPrev", function()
    FCword.replace(true)
  end, { desc = "Cycle replacement backward" })

  mkcmd("SwapAdd", function(args)
    FCword.add_swap_group(args)
  end, {
    nargs = "+",
    desc = "Add a new word swap group and save it",
  })

  mkcmd("SwapRm", function(opts)
    FCword.remove_swap_group(opts.args)
  end, {
    nargs = 1,
    desc = "Remove a swap group by index",
  })

  mkcmd("SwapList", function()
    FCword.list_swap_groups()
  end, { desc = "List active swap groups" })

  mkcmd("SwapReload", function()
    FCword.reload_swap_groups()
  end, { desc = "Reload swap groups from swaps.lua" })
end

return M
