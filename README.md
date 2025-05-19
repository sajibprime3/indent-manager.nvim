# indent-manager.nvim

A simple, dumb, persistent per-language indent manager for Neovim.


## ✨ Features

- Persists user preferences in a Lua config file.

- Supports Lazy, Packer, etc.

- Supports user commands:
  - `:SetIndentSize {n}` — sets indent size for current filetype.
  - `:ShowIndentSize` — shows current indent.
  - `:OpenIndentConfig` — opens the config file.
  - `:ShowIndentConfigPath` — prints config path.
- Automatically sets indentation size based on filetype on `BufEnter` event.
- Configurable default indent and keymap.
  

## 🛠️ Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)
Minimalistic installation.
```lua
{
  "sajibprime3/indent-manager.nvim",
  config = function()
    require("indentomatic").setup()
  end
}
```

you can change your editors default indentation and keymap like so 
```lua 
{
  "sajibprime3/indent-manager.nvim",
  config = function()
    require("indentomatic").setup({
      default_indent = 8, -- any number. BEWARE.
      keymap = "<leader>fi", -- other keymaps of the plugin will be concated to this.
    })
  end
}
```

## Keymaps

- Defaults
  - Use ```<leader>fic``` to open (c)onfig file.
  -  Use ```<leader>fiz``` to show current filetype's indentation si(z)e.

