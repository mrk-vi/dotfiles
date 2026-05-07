return {
  -- Mason: Install and manage LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = true,
  },

  -- nvim-lspconfig: For non-Java LSP servers
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
      -- Store jdtls workspaces under a stable path keyed by project root,
      -- not neovim's cwd (which changes per session).
      local workspace_base = vim.fn.stdpath("cache") .. "/jdtls"

      local function compute_root_dir(fname)
        -- Search strong markers first (.git, mvnw, gradlew) to avoid stopping
        -- at a submodule pom.xml (e.g. core/common/pom.xml instead of core/).
        local root = jdtls.setup.find_root({ ".git", "mvnw", "gradlew" }, fname)
        if root then return root end
        -- Fallback: module-level markers
        return jdtls.setup.find_root({ "pom.xml", "build.gradle" }, fname)
      end

      local function make_config(fname)
        local root_dir = compute_root_dir(fname)
        -- Hash the project root to get a stable, per-project workspace path.
        local project_hash = vim.fn.sha256(root_dir):sub(1, 12)
        local data_dir = workspace_base .. "/jdtls-" .. project_hash
        return {
          name = "jdtls",
          cmd = {
            mason_pkg .. "/bin/jdtls",
            "-data", data_dir,
            "--jvm-arg=-javaagent:" .. mason_pkg .. "/lombok.jar",
            -- Pass additional JVM args for JDK 21+ stability
            "--jvm-arg=-Xmx2G",
            "--jvm-arg=-XX:+UseG1GC",
            "--jvm-arg=-XX:+UseStringDeduplication",
          },
          root_dir = root_dir,
          filetypes = { "java" },
          settings = {
            java = {
              configuration = {
                updateBuildConfiguration = "automatic",
              },
              maven = {
                downloadSources = true,
              },
              eclipse = {
                downloadSources = true,
              },
              -- Limit imported projects to avoid scanning the whole filesystem
              import = {
                gradle = {
                  enabled = true,
                },
                maven = {
                  enabled = true,
                },
                exclusions = {
                  "**/node_modules/**",
                  "**/.metadata/**",
                  "**/build/**",
                  "**/target/**",
                  "**/.gradle/**",
                },
              },
            },
          },
          init_options = {
            bundles = {},
          },
        }
      end

      -- Attach jdtls to the current Java buffer.
      jdtls.start_or_attach(make_config(vim.api.nvim_buf_get_name(0)))

      -- Attach jdtls to subsequent Java buffers (needed for nvimdiff with two files).
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function(args)
          local fname = vim.api.nvim_buf_get_name(args.buf)
          jdtls.start_or_attach(make_config(fname))
        end,
      })

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

  -- fzf.vim: Fuzzy finder (uses system fzf binary)
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    keys = {
      { "<leader>ff", "<cmd>Files<cr>",    desc = "Find files" },
      { "<leader>fg", "<cmd>Rg<cr>",       desc = "Live grep" },
      { "<leader>fb", "<cmd>Buffers<cr>",  desc = "Buffers" },
      { "<leader>fh", "<cmd>Helptags<cr>", desc = "Help tags" },
    },
    init = function()
      vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --glob "!.git"'
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
