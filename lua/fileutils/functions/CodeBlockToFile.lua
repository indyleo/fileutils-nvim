-- lua/function/CodeBlockToFile.lua
local M = {}

-- Map language to metadata
local lang_metadata = {
  -- Scripting Languages
  python = {
    ext = "py",
    comment = "#",
    shebang = "#!/usr/bin/env python3",
  },
  bash = {
    ext = "sh",
    comment = "#",
    shebang = "#!/usr/bin/env bash",
  },
  sh = {
    ext = "sh",
    comment = "#",
    shebang = "#!/usr/bin/env sh",
  },
  zsh = {
    ext = "zsh",
    comment = "#",
    shebang = "#!/usr/bin/env zsh",
  },
  fish = {
    ext = "fish",
    comment = "#",
    shebang = "#!/usr/bin/env fish",
  },
  perl = {
    ext = "pl",
    comment = "#",
    shebang = "#!/usr/bin/env perl",
  },
  ruby = {
    ext = "rb",
    comment = "#",
    shebang = "#!/usr/bin/env ruby",
  },
  r = {
    ext = "R",
    comment = "#",
    shebang = "#!/usr/bin/env R",
  },

  -- Web / JS Ecosystem
  javascript = {
    ext = "js",
    comment = "//",
    shebang = "#!/usr/bin/env node",
  },
  js = {
    ext = "js",
    comment = "//",
    shebang = "#!/usr/bin/env node",
  },
  typescript = {
    ext = "ts",
    comment = "//",
    shebang = "#!/usr/bin/env ts-node",
  },
  ts = {
    ext = "ts",
    comment = "//",
    shebang = "#!/usr/bin/env ts-node",
  },
  jsx = {
    ext = "jsx",
    comment = "//",
    shebang = nil,
  },
  tsx = {
    ext = "tsx",
    comment = "//",
    shebang = nil,
  },
  php = {
    ext = "php",
    comment = "//",
    shebang = "#!/usr/bin/env php",
  },
  html = {
    ext = "html",
    comment = "<!--",
    shebang = nil,
  },
  css = {
    ext = "css",
    comment = "/*",
    shebang = nil,
  },

  -- Systems Languages
  c = {
    ext = "c",
    comment = "//",
    boilerplate_start = "#include <stdio.h>\nint main() {",
    boilerplate_end = "return 0;\n}",
  },
  cpp = {
    ext = "cpp",
    comment = "//",
    boilerplate_start = "#include <iostream>\nint main() {",
    boilerplate_end = "return 0;\n}",
  },
  go = {
    ext = "go",
    comment = "//",
    boilerplate_start = 'package main\n\nimport "fmt"\n\nfunc main() {',
    boilerplate_end = "}",
  },
  rust = {
    ext = "rs",
    comment = "//",
    boilerplate_start = "fn main() {",
    boilerplate_end = "}",
  },
  zig = {
    ext = "zig",
    comment = "//",
    boilerplate_start = 'const std = @import("std");\npub fn main() void {',
    boilerplate_end = "}",
  },

  -- JVM Ecosystem
  java = {
    ext = "java",
    comment = "//",
    boilerplate_start = "public class Main {\n    public static void main(String[] args) {",
    boilerplate_end = "    }\n}",
  },
  kotlin = {
    ext = "kt",
    comment = "//",
    boilerplate_start = "fun main() {",
    boilerplate_end = "}",
  },
  scala = {
    ext = "scala",
    comment = "//",
    boilerplate_start = "object Main extends App {",
    boilerplate_end = "}",
  },
  groovy = {
    ext = "groovy",
    comment = "//",
    shebang = "#!/usr/bin/env groovy",
  },

  -- Functional
  elixir = {
    ext = "ex",
    comment = "#",
    shebang = "#!/usr/bin/env elixir",
  },
  erlang = {
    ext = "erl",
    comment = "%",
    shebang = nil,
  },
  ocaml = {
    ext = "ml",
    comment = "(*",
    shebang = nil,
  },
  haskell = {
    ext = "hs",
    comment = "--",
    boilerplate_start = "main = do",
    boilerplate_end = "",
  },

  -- Data & Markup
  yaml = { ext = "yaml", comment = "#" },
  yml = { ext = "yml", comment = "#" },
  json = { ext = "json" },
  toml = { ext = "toml", comment = "#" },
  ini = { ext = "ini", comment = ";" },
  xml = { ext = "xml", comment = "<!--" },

  -- Misc
  lua = { ext = "lua", comment = "--" },
  make = { ext = "Makefile", comment = "#" },
  dockerfile = { ext = "Dockerfile", comment = "#" },
  markdown = { ext = "md", comment = "<!--" },
  tex = { ext = "tex", comment = "%" },
}

function M.extract_code_blocks()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local header = nil
  local inside_code_block = false
  local code_buffer = {}
  local combined_code = {}
  local current_lang = nil
  local first_lang = nil
  local comment_symbol = "#"

  for _, line in ipairs(lines) do
    if not header and line:match "^#%s+(.+)" then
      header = line:match("^#%s+(.+)"):gsub('[/:\\%*%?"<>|]', ""):gsub("^%s*(.-)%s*$", "%1")
    end

    local start_lang = line:match "^```(%S+)"
    if line:match "^```" then
      if inside_code_block then
        -- Close current block
        inside_code_block = false
        if current_lang then
          local meta = lang_metadata[current_lang] or {}
          if meta.std_imports and #meta.std_imports > 0 then
            vim.list_extend(combined_code, meta.std_imports)
          end
          if meta.boilerplate_start then
            table.insert(combined_code, meta.boilerplate_start)
          end
          vim.list_extend(combined_code, code_buffer)
          if meta.boilerplate_end then
            table.insert(combined_code, meta.boilerplate_end)
          end
          table.insert(combined_code, "")
        end
        current_lang = nil
        code_buffer = {}
      elseif start_lang then
        -- Start new block
        inside_code_block = true
        current_lang = start_lang
        if not first_lang then
          first_lang = current_lang
        end
        comment_symbol = lang_metadata[current_lang] and lang_metadata[current_lang].comment or "#"
        table.insert(combined_code, comment_symbol .. " --- From block: " .. current_lang .. " ---")
      end
    elseif inside_code_block then
      table.insert(code_buffer, line)
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

  local meta = lang_metadata[first_lang] or {}
  local shebang = meta.shebang
  if shebang then
    table.insert(combined_code, 1, shebang)
  end

  local filepath = vim.fn.expand "%:p:h" .. "/" .. header
  local file, err = io.open(filepath, "w")
  if not file then
    vim.notify("Failed to write file: " .. err, vim.log.levels.ERROR)
    return
  end

  file:write(table.concat(combined_code, "\n"))
  file:close()

  local sysname = vim.loop.os_uname().sysname
  if sysname ~= "Windows_NT" then
    os.execute("chmod a+x " .. vim.fn.shellescape(filepath))
  end

  vim.notify("Wrote & made executable combined code to: " .. filepath, vim.log.levels.INFO)
end

return M
