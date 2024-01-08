# cmp-go-pkgs

nvim-cmp source for golang packages path.

Loads once on LspAttach event.

Shows only incide import block.

https://github.com/Snikimonkd/cmp-go-pkgs/assets/72211350/4bf7b149-4f72-4f24-a529-794a9201dcf5

## Setup

Setup with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "Snikimonkd/cmp-go-pkgs",
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            sources = {
                { name = "go_pkgs" },
            },
        })
    end,
},
```

## Lspkind

You can use it with [lspkind](https://github.com/onsails/lspkind.nvim):

```lua
return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "Snikimonkd/cmp-go-pkgs",
    },
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")

        cmp.setup({
            sources = {
                { name = "go_pkgs" },
            },
            formatting = {
                format = lspkind.cmp_format({
                    with_text = true,
                    menu = {
                        go_pkgs = "[pkgs]",
                    },
                }),
            },
        })
    end,
},
```

## Inspiration

(where i stole some code)

https://github.com/ray-x/go.nvim
https://github.com/hrsh7th/cmp-buffer
https://github.com/onsails/lspkind.nvim
