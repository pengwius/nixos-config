return {
    {
        "neovim/nvim-lspconfig",
        opts = function(_, opts)
            opts.servers = opts.servers or {}

            local vue_language_server_path = vim.fs.dirname(vim.fn.exepath("vue-language-server"))
                .. "/../lib/language-tools/packages/language-server/node_modules/@vue/typescript-plugin"

            opts.servers = vim.tbl_deep_extend("force", opts.servers, {
                lua_ls = {
                    settings = {
                        Lua = {
                            workspace = {
                                checkThirdParty = false,
                            },
                            codeLens = {
                                enable = true,
                            },
                            completion = {
                                callSnippet = "Replace",
                            },
                            doc = {
                                privateName = { "^_" },
                            },
                            hint = {
                                enable = true,
                                setType = false,
                                paramName = "Disable",
                                semicolon = "Disable",
                                arrayIndex = "Disable",
                            },
                        },
                    },
                },

                nixd = {
                    settings = {
                        nixd = {
                            formatting = {
                                command = { "nixfmt" },
                            },
                        },
                    },
                },

                vtsls = {
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "javascript.jsx",
                        "typescript",
                        "typescriptreact",
                        "typescript.tsx",
                        "vue",
                    },
                    settings = {
                        complete_function_calls = true,
                        vtsls = {
                            enableMoveToFileCodeAction = true,
                            autoUseWorkspaceTsdk = true,
                            experimental = {
                                completion = {
                                    enableServerSideFuzzyMatch = true,
                                },
                            },
                            tsserver = {
                                globalPlugins = {
                                    {
                                        name = "@vue/typescript-plugin",
                                        location = vue_language_server_path,
                                        languages = { "vue" },
                                        configNamespace = "typescript",
                                        enableForWorkspaceTypeScriptVersions = true,
                                    },
                                },
                            },
                        },
                        typescript = {
                            updateImportsOnFileMove = { enabled = "always" },
                            suggest = {
                                completeFunctionCalls = true,
                            },
                            inlayHints = {
                                enumMemberValues = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                parameterNames = { enabled = "literals" },
                                parameterTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                variableTypes = { enabled = false },
                            },
                        },
                    },
                },
                volar = {},

                marksman = {},

                elixirls = {},

                svelte = {},

                yamlls = {},
                jsonls = {},

                terraformls = {},
            })
        end,
    },
}
