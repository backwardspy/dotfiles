vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- gui/neovide stuff
vim.opt.guifont = "Fantasque Sans Mono:h15"

if vim.g.neovide then
    vim.g.neovide_cursor_vfx_mode = "pixiedust"
    vim.g.neovide_cursor_vfx_particle_density = 50
end

-- pre-plugin binds
local m = { "n", "t", "i" }

-- quicker window movement
vim.keymap.set(m, "<C-h>", [[<cmd>wincmd h<cr>]])
vim.keymap.set(m, "<C-j>", [[<cmd>wincmd j<cr>]])
vim.keymap.set(m, "<C-k>", [[<cmd>wincmd k<cr>]])
vim.keymap.set(m, "<C-l>", [[<cmd>wincmd l<cr>]])

-- highlight yank
vim.api.nvim_create_augroup("highlight_yank", {})
vim.api.nvim_create_autocmd({"TextYankPost"}, {
    group = "highlight_yank",
    pattern = {"*"},
    callback = function()
        vim.highlight.on_yank({
            higroup = "Visual",
            timeout = 500,
        })
    end
})

-- easier terminal escape
vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

-- packer setup
local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- language server
    use({
        "VonHeikemen/lsp-zero.nvim",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
        },
    })

    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = {
            "nvim-lua/plenary.nvim",
        },
    })

    -- find stuff easier
    use({
        "nvim-telescope/telescope.nvim",
    })

    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            vim.g.neo_tree_remove_legacy_commands = 1
            require("neo-tree").setup({
                close_if_last_window = true,
                window = {
                    width = 30,
                },
            })
        end,
    })

    -- escape with jk
    use({
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup()
        end,
    })

    -- ez terminal splits
    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = "<C-`>",
            })

            local Terminal = require("toggleterm.terminal").Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true,
            })
            vim.api.nvim_create_user_command("Git", function(opts)
                lazygit:toggle()
            end, {})
        end,
    })

    -- best theme ever
    use({
        "catppuccin/nvim",
        as = "catppuccin",
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)

local lsp_ok, lsp = pcall(require, "lsp-zero")
local null_ok, null = pcall(require, "null-ls")
if lsp_ok and null_ok then
    lsp.preset("recommended")

    local configs = require("lspconfig/configs")
    local util = require("lspconfig/util")

    local path = util.path

    local function get_python_path(workspace)
        -- Use activated virtualenv.
        if vim.env.VIRTUAL_ENV then
            return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
        end

        -- Find and use virtualenv in workspace directory.
        for _, pattern in ipairs({ "*", ".*" }) do
            local match = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
            if match ~= "" then
                return path.join(path.dirname(match), "bin", "python")
            end
        end

        -- Fallback to system Python.
        return exepath("python3") or exepath("python") or "python"
    end

    lsp.configure("pyright", {
        before_init = function(_, config)
            config.settings.python.pythonPath = get_python_path(config.root_dir)
        end,
    })
    lsp.setup()

    local null_opts = lsp.build_options("null-ls", {})
    null.setup({
        on_attach = null_opts.on_attach,
        sources = {
            null.builtins.formatting.stylua.with({
                extra_args = { "--indent-type", "spaces" },
            }),
            null.builtins.formatting.black,
            null.builtins.formatting.isort.with({
                extra_args = { "--profile", "black" },
            }),
        },
    })

    vim.diagnostic.config({
        virtual_text = true,
    })
end

local ts = require("telescope.builtin")

-- plugin keybinds
-- ctrl+p       -> find files
-- ctrl+shift+o -> find symbols
-- ctrl+shift+f -> search
-- shift+alt+f  -> format file
-- ctrl+s       -> save
-- ctrl+b       -> file tree
-- ctrl+`       -> terminal
vim.keymap.set(m, "<C-P>", ts.find_files)
vim.keymap.set(m, "<C-S-O>", ts.lsp_document_symbols)
vim.keymap.set(m, "<C-S-F>", ts.live_grep)
vim.keymap.set(m, "<M-F>", vim.lsp.buf.format)
vim.keymap.set(m, "<C-S>", function()
    vim.api.nvim_command("write")
end)
vim.keymap.set(m, "<C-B>", [[<cmd>Neotree toggle<cr>]])
vim.keymap.set(m, "<C-`>", function() require("toggleterm").toggle() end)
