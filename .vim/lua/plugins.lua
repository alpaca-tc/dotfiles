local M = {}

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local conf = {
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  local augroup = vim.api.nvim_create_augroup("PackerPlugins", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "plugins.lua",
    group = augroup,
    callback = function()
      vim.cmd('luafile %')
      vim.cmd('PackerSync')
    end,
  })

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system {
        "git",
        "clone",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
      }
      vim.cmd [[packadd packer.nvim]]
    end
    vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
  end

  -- Plugins
  local function plugins(use)
    use { "wbthomason/packer.nvim" }

    use { "tpope/vim-repeat" }

    use {
      "vim-jp/vital.vim",
      fn = { "vital#of", "vital#vital#new" },
      cmd = "Vitalize"
    }

    use {
      'cocopon/iceberg.vim'
    }

    use {
      'alpaca-tc/alpaca_deepl.vim',
      run = ':UpdateRemotePlugins',
      cmd = { "Deepl" },
      requires = { 'mattn/webapi-vim' },
    }

    use {
      'tyru/open-browser.vim',
      cmd    = { "OpenBrowserSearch", "OpenBrowser", "OpenBrowserSmartSearch" },
      keys    = { '<Plug>(openbrowser-open)' },
      fn = { "openbrowser#open" },
      setup = function()
        vim.keymap.set('n', ',o', '<Plug>(openbrowser-open)')
        vim.keymap.set('x', ',o', '<Plug>(openbrowser-open)')
      end
    }

    use {
      'mattn/webapi-vim',
      fn = { "webapi#json#encode", "webapi#json#decode" }
    }

    use {
      'kana/vim-arpeggio',
      event = { 'InsertEnter' },
      fn   = { "arpeggio#map" },
      config = function()
        local escape = '<Esc>:nohlsearch<CR>'
        vim.fn['arpeggio#map']('i', 's', 0, 'jk', escape)
        vim.fn['arpeggio#map']('v', 's', 0, 'jk', escape)
        vim.fn['arpeggio#map']('x', 's', 0, 'jk', escape)
        vim.fn['arpeggio#map']('c', 's', 0, 'jk', escape)
      end
    }

    use {
      'echasnovski/mini.nvim',
      branch = "stable",
      event = { 'BufEnter' },
      config = function()
        require('mini.comment').setup({
          -- Module mappings. Use `''` (empty string) to disable one.
          mappings = {
            -- Toggle comment (like `gcip` - comment inner paragraph) for both
            -- Normal and Visual modes
            comment = '<C-_>',

            -- Toggle comment on current line
            comment_line = '<C-_>',

            -- Define 'comment' textobject (like `dgc` - delete whole comment block)
            textobject = '',
          },
        })
      end
    }

    -- file types
    use {
      'cespare/vim-toml',
      ft = { 'toml' }
    }

    use {
      'slim-template/vim-slim',
      ft     = { "slim" }
    }

    use {
      'mutewinter/nginx.vim',
      ft     = { "nginx" }
    }

    use {
      'elixir-lang/vim-elixir',
      ft     = { "elixir" }
    }

    use {
      'mattreduce/vim-mix',
      ft     = { "elixir" }
    }

    use {
      'vim-scripts/sh.vim',
      ft  = 'sh'
    }

    -- -- Git
    -- use {
    --   "TimUntersberger/neogit",
    --   requires = "nvim-lua/plenary.nvim",
    --   config = function()
    --     require("config.neogit").setup()
    --   end,
    -- }

    if packer_bootstrap then
      print "Restart Neovim required after installation!"
      require("packer").sync()
    end
  end

  packer_init()

  local packer = require "packer"
  packer.init(conf)
  packer.startup(plugins)
end

M.setup()

return M
