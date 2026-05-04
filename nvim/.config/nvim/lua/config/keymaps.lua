local map = vim.keymap.set

-- Diagnostic navigation
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

map("n", "<leader>fs", vim.lsp.buf.document_symbol,  { desc = "Document symbols" })
map("n", "<leader>fS", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbols" })

-- LSP keymaps (applied per-buffer on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(args)
    local bufopts = { buffer = args.buf, silent = true }

    map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "Go to definition" }))
    map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "Go to declaration" }))
    map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "Go to references" }))
    map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "Go to implementation" }))
    map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "Hover" }))
    map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "Code action" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "Rename" }))
    map("n", "<leader>lr", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "List references" }))
  end,
})
