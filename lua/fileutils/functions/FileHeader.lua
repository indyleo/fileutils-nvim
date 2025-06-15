-- lua/function/FileHeader.lua

local M = {}

function M.InsertFileHeader()
  -- Only proceed if the buffer is modifiable
  if not vim.bo.modifiable then
    vim.notify("Buffer is not modifiable", vim.log.levels.WARN)
    return
  end

  -- Get system username, date/time, and file type
  local user = os.getenv "USER" or os.getenv "USERNAME" or "unknown"
  local date_time = os.date "%A %B %d, %Y, %I:%M %p"
  local file_type = vim.bo.filetype or "unknown"

  -- Define a table mapping file types to comment styles
  local comment_styles = {
    -- "#" Comments
    python = "#",
    bash = "#",
    zsh = "#",
    fish = "#",
    sh = "#",
    ps1 = "#",
    jsonc = "#",
    yaml = "#",
    toml = "#",
    make = "#",
    dockerfile = "#",
    ini = "#",
    perl = "#",

    -- "//" Comments
    javascript = "//",
    typescript = "//",
    c = "//",
    cpp = "//",
    rust = "//",
    java = "//",
    kotlin = "//",
    r = "//",
    swift = "//",
    scala = "//",
    groovy = "//",
    glsl = "//",

    -- "Wrap Around" Comments
    html = { "<!--", "-->" },
    xml = { "<!--", "-->" },
    markdown = { "<!--", "-->" },
    css = { "/*", "*/" },
    scss = { "/*", "*/" },
    less = { "/*", "*/" },

    -- "Other" styles
    lua = "--",
    vim = '"',
    autohotkey = ";",
    assembly = ";",
    lisp = ";",
    scheme = ";",
    clojure = ";",
    elisp = ";",
    tcl = "#",
    sql = "--",
    haskell = "--",
    ada = "--",
    rebol = ";",
    fortran = "!",
    erlang = "%",
    prolog = "%",
    fsharp = "//",
    ocaml = { "(*", "*)" },
    coq = { "(*", "*)" },
    sml = { "(*", "*)" },
  }

  -- Fallback to "#" if unknown
  local comment_symbol = comment_styles[file_type] or "#"

  -- Construct the comment header
  local header
  if type(comment_symbol) == "table" then
    header = string.format("%s By: %s | %s | %s %s", comment_symbol[1], user, date_time, file_type, comment_symbol[2])
  else
    header = string.format("%s By: %s | %s | %s", comment_symbol, user, date_time, file_type)
  end

  -- Insert header at the top of the buffer
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { header })
end

return M
