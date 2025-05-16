-- lua/fileutils/functions/Terminal.lua
local M = {}

local termstate = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local lazystate = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local cmdstate = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local cmdforeverstate = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function is_git_repo()
  local output = vim.fn.systemlist { "sh", "-c", "git rev-parse --is-inside-work-tree" }
  return vim.v.shell_error == 0 and output[1] == "true"
end

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

M.toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(termstate.floating.win) then
    termstate.floating = create_floating_window { buf = termstate.floating.buf }
    if vim.bo[termstate.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
    vim.cmd "startinsert"
  else
    vim.api.nvim_win_hide(termstate.floating.win)
  end
end

M.toggle_lazygit = function()
  if not is_git_repo() then
    vim.notify("Not in a git repo", vim.log.levels.WARN)
    return
  end
  if not vim.api.nvim_win_is_valid(lazystate.floating.win) then
    lazystate.floating = create_floating_window { buf = lazystate.floating.buf }
    if vim.bo[lazystate.floating.buf].buftype ~= "terminal" then
      vim.fn.termopen { "sh", "-c", "lazygit" }
    end
    vim.cmd "startinsert"
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(lazystate.floating.win) then
        vim.api.nvim_set_current_win(lazystate.floating.win)
        vim.cmd "startinsert"
      end
    end, 50)
  else
    vim.api.nvim_win_hide(lazystate.floating.win)
  end
end

M.command_run = function(command)
  if not vim.api.nvim_win_is_valid(cmdstate.floating.win) then
    cmdstate.floating = create_floating_window { buf = cmdstate.floating.buf }
    if vim.bo[cmdstate.floating.buf].buftype ~= "terminal" then
      vim.fn.termopen { "sh", "-c", command }
    end
    vim.cmd "startinsert"
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(cmdstate.floating.win) then
        vim.api.nvim_set_current_win(cmdstate.floating.win)
        vim.cmd "startinsert"
      end
    end, 50)
  end
end

M.command_run_forever = function(forevercmd)
  if not vim.api.nvim_win_is_valid(cmdforeverstate.floating.win) then
    cmdforeverstate.floating = create_floating_window { buf = cmdforeverstate.floating.buf }
    if vim.bo[cmdforeverstate.floating.buf].buftype ~= "terminal" then
      vim.fn.termopen { "sh", "-c", forevercmd }
    end
    vim.cmd "startinsert"
    vim.defer_fn(function()
      if vim.api.nvim_win_is_valid(cmdforeverstate.floating.win) then
        vim.api.nvim_set_current_win(cmdforeverstate.floating.win)
        vim.cmd "startinsert"
      end
    end, 50)
  else
    vim.api.nvim_win_hide(cmdforeverstate.floating.win)
  end
end

return M
