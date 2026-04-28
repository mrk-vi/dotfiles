return {
  -- Mason: Install and manage LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true,
  },

  -- nvim-lspconfig: For non-Java LSP servers (e.g. lua_ls, bashls)
  {
    "neovim/nvim-lspconfig",
  },

  -- nvim-jdtls: Java LSP with lombok
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
      local jdtls = require("jdtls")
      local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages/jdtls"

      local config = {
        name = "jdtls",
        cmd = {
          mason_pkg .. "/bin/jdtls",
          "--jvm-arg=-javaagent:" .. mason_pkg .. "/lombok.jar",
        },
        root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
        filetypes = { "java" },
        settings = {
          java = {},
        },
        init_options = {
          bundles = {},
        },
      }

      jdtls.start_or_attach(config)

      local augroup = vim.api.nvim_create_augroup("JdtlsConfig", { clear = true })
      vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "jdtls" then
            local buf = args.buf
            vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, { buffer = buf, desc = "Organize imports" })
            vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, { buffer = buf, desc = "Extract variable" })
            vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, { buffer = buf, desc = "Extract constant" })
            vim.keymap.set("v", "<leader>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], { desc = "Extract method" })
          end
        end,
      })
    end,
  },

  -- Telescope: Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>fH", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find files (incl. hidden)" },
    },
    config = function()
      require("telescope").setup({
        pickers = {
          find_files = {
            hidden = true,
          },
        },
      })
    end,
  },

  -- Treesitter: Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "java", "lua", "vim", "vimdoc" },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- which-key: Show keybinding hints on <leader>
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Tmux pane navigation
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Tmux left" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Tmux down" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Tmux up" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Tmux right" },
    },
  },
}
