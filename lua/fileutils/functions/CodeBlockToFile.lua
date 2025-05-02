-- lua/function/CodeBlockToFile.lua
local M = {}

-- Map language to comment and shebang
local lang_metadata = {
	python = { ext = "py", comment = "#", shebang = "#!/usr/bin/env python3" },
	bash = { ext = "sh", comment = "#", shebang = "#!/usr/bin/env bash" },
	sh = { ext = "sh", comment = "#", shebang = "#!/usr/bin/env sh" },
	lua = { ext = "lua", comment = "--", shebang = nil },
	javascript = { ext = "js", comment = "//", shebang = "#!/usr/bin/env node" },
	js = { ext = "js", comment = "//", shebang = "#!/usr/bin/env node" },
	go = { ext = "go", comment = "//", shebang = nil },
	c = { ext = "c", comment = "//", shebang = nil },
	cpp = { ext = "cpp", comment = "//", shebang = nil },
	java = { ext = "java", comment = "//", shebang = nil },
	kotlin = { ext = "kt", comment = "//", shebang = nil },
	rust = { ext = "rs", comment = "//", shebang = nil },
	r = { ext = "R", comment = "#", shebang = "#!/usr/bin/env R" },
	ruby = { ext = "rb", comment = "#", shebang = "#!/usr/bin/env ruby" },
	php = { ext = "php", comment = "//", shebang = "#!/usr/bin/env php" },
}

function M.extract_code_blocks()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local header = nil
	local inside_code_block = false
	local combined_code = {}
	local current_lang = nil
	local first_lang = nil
	local comment_symbol = "#"

	for _, line in ipairs(lines) do
		if not header and line:match("^#%s+(.+)") then
			header = line:match("^#%s+(.+)"):gsub('[/:\\%*%?"<>|]', ""):gsub("^%s*(.-)%s*$", "%1")
		end

		local start_lang = line:match("^```(%S+)")
		if line:match("^```") then
			if inside_code_block then
				inside_code_block = false
				table.insert(combined_code, "") -- blank line between blocks
				current_lang = nil
			elseif start_lang then
				inside_code_block = true
				current_lang = start_lang
				if not first_lang then
					first_lang = current_lang
				end
				comment_symbol = lang_metadata[current_lang] and lang_metadata[current_lang].comment or "#"
				table.insert(combined_code, comment_symbol .. " --- From block: " .. current_lang .. " ---")
			end
		elseif inside_code_block then
			table.insert(combined_code, line)
		end
	end

	if not header then
		vim.notify("No header found.", vim.log.levels.ERROR)
		return
	end

	if #combined_code == 0 then
		vim.notify("No code blocks found.", vim.log.levels.WARN)
		return
	end

	-- Insert shebang if first_lang supports it
	local shebang = lang_metadata[first_lang] and lang_metadata[first_lang].shebang
	if shebang then
		table.insert(combined_code, 1, shebang)
	end

	local filepath = vim.fn.expand("%:p:h") .. "/" .. header
	local file, err = io.open(filepath, "w")
	if not file then
		vim.notify("Failed to write file: " .. err, vim.log.levels.ERROR)
		return
	end

	file:write(table.concat(combined_code, "\n"))
	file:close()

	-- Platform-specific execution permission handling
	local sysname = vim.loop.os_uname().sysname
	if sysname == "Windows_NT" then
		-- Attempt to unblock the file (works for PowerShell scripts or bat files)
		os.execute('powershell -Command "Try { Unblock-File -Path ' .. vim.fn.shellescape(filepath) .. ' } Catch {}"')
	else
		-- Unix-like: chmod a+x
		os.execute("chmod a+x " .. vim.fn.shellescape(filepath))
	end

	vim.notify("Wrote & made executable combined code to: " .. filepath, vim.log.levels.INFO)
end

return M
