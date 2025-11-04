return {
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "lua_ls",
                    "rust_analyzer",
                    "ts_ls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        opts = {
            diagnostics = { float = { border = "rounded" } },
            servers = { bashls = {}, clangd = {}, lua_ls = {} },
        },
        config = function(_, opts)
            for server, config in pairs(opts.servers) do
                config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
                vim.lsp.config(server, config)
            end

            vim.diagnostic.config({ virtual_lines = true })

            vim.g.c_syntax_for_h = 1

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(e)
                    local bufopts = { buffer = e.buf }

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true }),
                        callback = function(args)
                            vim.lsp.buf.format({
                                async = false,
                                bufnr = args.buf,
                            })
                        end,
                    })

                    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
                    vim.keymap.set("n", "gd", vim.lsp.buf.definition)
                    vim.keymap.set("n", "<leader>f", function()
                        vim.lsp.buf.format({
                            async = false,
                        })
                    end)
                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.jump({ count = -1, float = true })
                    end)
                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.jump({ count = 1, float = true })
                    end)
                end,
            })
        end,
    },
}
