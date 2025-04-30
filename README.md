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
