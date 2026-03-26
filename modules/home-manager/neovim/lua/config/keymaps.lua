local map = vim.keymap.set

map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

map("n", "<C-p>", function() Snacks.picker.files() end, { desc = "Find Files" })

map({ "n", "t" }, "<C-`>", function() Snacks.terminal() end, { desc = "Toggle Terminal" })

map("n", "<M-Down>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<M-Up>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<M-Down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<M-Up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<M-Down>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<M-Up>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

map("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat" })
map("v", "<leader>cc", "<cmd>CopilotChatToggle<cr>", { desc = "Copilot Chat" })
map("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain Code" })
map("v", "<leader>cf", "<cmd>CopilotChatFix<cr>", { desc = "Fix Code" })
map("v", "<leader>cr", "<cmd>CopilotChatReview<cr>", { desc = "Review Code" })
map("v", "<leader>co", "<cmd>CopilotChatOptimize<cr>", { desc = "Optimize Code" })

map("n", "<leader>wt", "<cmd>WakaTimeToday<cr>", { desc = "WakaTime Today" })
