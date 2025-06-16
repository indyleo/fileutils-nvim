-- lua/function/FileHelper.lua

local M = {}

-- Function to trim leading and trailing spaces
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- Cd into dir and open Oil in that dir
function M.OilDir(opts)
  local path = opts.args -- Get the path argument
  local dirpath = path:gsub("\\", "/") .. "/" -- Normalize path
  vim.cmd("cd " .. vim.fn.fnameescape(dirpath)) -- Change directory
  vim.cmd "Oil --float" -- Open Oil in float mode
end

-- Function to cd into a directory and open a file
function M.EditFile(opts)
  local args = vim.split(opts.args, " ") -- Split arguments into dirpath and filename
  if #args < 2 then
    vim.notify("Usage: :EditFile <dirpath> <filename>", vim.log.levels.WARN)
    return
  end

  local dirpath = args[1] -- First argument is the directory path
  local filename = args[2] -- Second argument is the file name
  local escaped_dirpath = dirpath:gsub("\\", "/") .. "/"
  local filepath = escaped_dirpath .. filename

  -- Change directory
  vim.cmd("cd " .. vim.fn.fnameescape(escaped_dirpath))

  -- Open the file
  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
end

return M
