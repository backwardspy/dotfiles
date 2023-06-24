vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader><leader>", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
vim.keymap.set("n", "<leader>fr", ":Telescope resume<CR>")
vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>sk", ":Telescope keymaps<CR>")
vim.keymap.set("n", "<leader>sh", ":Telescope help_tags<CR>")

vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>")
vim.keymap.set("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>")
vim.keymap.set("n", "<leader>lS", ":Telescope lsp_workspace_symbols<CR>")
vim.keymap.set("n", "<leader>ld", ":Telescope diagnostics<CR>")

require("telescope").setup({
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown()
        }
    }
})

require("telescope").load_extension("fzf")       -- native sorter
require("telescope").load_extension("ui-select") -- use telescope for code actions etc
