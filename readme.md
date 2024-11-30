# popclock.nvim

I really enjoy distraction-free coding in [folke/zen-mode](https://github.com/folke/zen-mode.nvim), but every now and then, I need to make sure I'm not late for my next meeting (…sigh). With this simple plugin, I can toggle a small, minimalistic clock without exiting zen-mode—and without having the entire screen move around, breaking my focus on the code I'm working on.

## Features
- Display a real-time clock in a floating window.
- Customize position: center, top, bottom, corners, or relative to the cursor.
- Set foreground and background colors.
- Toggle the clock with a keybinding.

## Installation

Using **Lazy.nvim**:
```lua
{
  "hellgrenj/popclock.nvim",
  config = function()
    require("popclock").setup({
      key_binding = "<leader>cl", -- Default: <leader>cl
      position = "center",       -- Default: 'center'
      fgcolor = "#FFFFFF",       -- Default: 'magenta'
      bgcolor = "#000000",       -- Default: nil (transparent)
    })
  end,
}
