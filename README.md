# fileutils-nvim

File utils I decided to put in a plugin

```lua
return {
  "indyleo/fileutils-nvim",
  dependencies = {
    {
      "stevearc/oil.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons",
      },
      lazy = false,
    },
  },
}

```

## Commands

- `:MarkdownCode` — Extract code blocks from Markdown
- `:OilDir {path}` — Open a directory in oil.nvim
- `:EditFile {file}` — Edit one or more files
- `:AskNewFileName` — Prompt for a new filename
- `:NewHSplit` — Open file in a horizontal split
- `:NewVSplit` — Open file in a vertical split
- `:FileHeader` — Insert a file header

Add this to your lazy config, hopefully as a separate file.
