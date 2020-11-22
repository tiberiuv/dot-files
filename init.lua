require'nvim-treesitter.configs'.setup {
    -- Modules and its options go here
    ensure_installed = {
        "rust",
        "typescript",
        "python",
        "json",
        "jsdoc",
        "javascript",
        "css",
        "yaml",
        "toml",
        "bash",
        "lua",
    },
    highlight = { enable = true },
    incremental_selection = { enable = true },
    refactor = {
        smart_rename = { enable = true },
        navigation = { enable = true },
    },
    textobjects = { enable = true },
}

local nvim_lsp = require('lspconfig')
  local configs = require('lspconfig/configs')
  vim.lsp.set_log_level("debug")

  local on_attach = function(_, bufnr)
    require'completion'.on_attach()
    -- Mappings.
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua vim.lsp.buf.list_workspace_folders()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  end

  configs.pyright = {
    default_config = {
      cmd = {"pyright-langserver", "--stdio"};
      filetypes = {"python"};
      root_dir = nvim_lsp.util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt");
      settings = {
        analysis = { autoSearchPaths = true; };
        pyright = { useLibraryCodeForTypes = true; };
      };
      -- The following before_init function can be removed once https://github.com/neovim/neovim/pull/12638 is merged
      before_init = function(initialize_params)
        initialize_params['workspaceFolders'] = {{
          name = 'workspace',
          uri = initialize_params['rootUri']
        }}
      end
      };
  }

  nvim_lsp['tsserver'].setup{
    on_attach=on_attach,
    filetypes={'typescript', 'typescriptreact', 'typescript.tsx' }
  }

  nvim_lsp['clangd'].setup{
    on_attach=on_attach,
    filetype={'c', 'ino', 'cpp', '.ino'}
  }

  local servers = {
    'rust_analyzer',
    'vimls',
    'jsonls',
    'html',
    'flow',
    'cssls',
    'terraformls',
    'dockerls',
    'texlab',
    'yamlls',
    'pyright',
    'sumneko_lua',
  }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end

  vim.lsp.callbacks['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
  vim.lsp.callbacks['textDocument/references'] = require'lsputil.locations'.references_handler
  vim.lsp.callbacks['textDocument/definition'] = require'lsputil.locations'.definition_handler
  vim.lsp.callbacks['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
  vim.lsp.callbacks['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
  vim.lsp.callbacks['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
  vim.lsp.callbacks['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
  vim.lsp.callbacks['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
    }
  )
