return {
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        ilazy = false,
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
            })
            vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>")
        end,
    },
}
