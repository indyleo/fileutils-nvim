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
	vim.cmd("Oil --float") -- Open Oil in float mode
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

-- Function to ask for a new file name
function M.AskNewFileName(opts)
	opts = opts or {}
	local filename = trim(opts.filename or "")

	if filename == "" then
		vim.notify("No file name provided.", vim.log.levels.WARN)
		return
	end

	local filepath = vim.fs.joinpath(vim.fn.getcwd(), filename)
	vim.cmd("edit " .. vim.fn.fnameescape(filepath))
	vim.cmd("startinsert")
end

-- Function to create a new horizontal split and open a file
function M.NewHSplit(opts)
	opts = opts or {}

	local path = trim(opts.path or "")
	if not path or path == "" then
		vim.notify("No file provided in opts.path.", vim.log.levels.WARN)
		return
	end

	local fullpath = vim.fs.joinpath(vim.fn.getcwd(), path)
	if vim.fn.filereadable(fullpath) == 1 then
		vim.cmd("split " .. vim.fn.fnameescape(fullpath))
	else
		vim.notify("File does not exist: " .. fullpath, vim.log.levels.ERROR)
	end
end

-- Function to create a new vertical split and open a file
function M.NewVSplit(opts)
	opts = opts or {}

	local path = trim(opts.path or "")
	if not path or path == "" then
		vim.notify("No file provided in opts.path.", vim.log.levels.WARN)
		return
	end

	local fullpath = vim.fs.joinpath(vim.fn.getcwd(), path)
	if vim.fn.filereadable(fullpath) == 1 then
		vim.cmd("vsplit " .. vim.fn.fnameescape(fullpath))
	else
		vim.notify("File does not exist: " .. fullpath, vim.log.levels.ERROR)
	end
end

return M
