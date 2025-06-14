# fileutils-nvim.lua

A small Neovim plugin containing utility commands for common file operations.

## Install

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
  lazy = false,
  config = function()
    require("fileutils").setup()
  end,
}
```

Add this snippet to your LazyVim plugin spec (ideally in its own file for better organization).

## Commands

- `:MarkdownCode`  
  Extracts all code blocks from a Markdown file and saves them as separate files, using the first header as the filename (similar to org-mode behavior).

- `:OilDir {path}`  
  Opens the specified directory in [oil.nvim](https://github.com/stevearc/oil.nvim) and sets it as the current working directory.

- `:EditFile {directory} {file}`  
  Opens the specified file and changes the working directory to its parent directory.

- `:AskNewFileName`  
  Prompts you to enter a new filename in the current working directory.

- `:NewHSplit`  
  Prompts you for a filename and opens it in a horizontal split within the current directory.

- `:NewVSplit`  
  Prompts you for a filename and opens it in a vertical split within the current directory.

- `:FileHeader`  
  Inserts a standardized file header at the top of the current buffer.
