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

Add this to your lazy config, hopefully as a separate file.

## Commands

- `:MarkdownCode` — Extract code blocks from Markdown (uses first header as file name) like an org document 
- `:OilDir {path}` — Open a directory in oil.nvim and nvim change directory's into that dir 
- `:EditFile {directory} {file}` — Edit one or more files edit a file and cd into that dir
- `:AskNewFileName` — Prompt for a new filename
- `:NewHSplit` — Open file in a horizontal split
- `:NewVSplit` — Open file in a vertical split
- `:FileHeader` — Insert a file header

