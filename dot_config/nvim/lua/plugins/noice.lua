return {
    {
        "folke/noice.nvim",
        cond = not vim.g.vscode,
        opts = {
            lsp = {
                progress = { enabled = false },

                -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            -- you can enable a preset for easier configuration
            presets = {
                bottom_search = true,
                long_message_to_split = true,
                lsp_doc_border = true,
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            {
                "rcarriga/nvim-notify",
                opts = {
                    background_colour = require("catppuccin.palettes").get_palette("mocha").base,
                    render = "minimal",
                    top_down = false,
                },
            },
        },
    },
}
