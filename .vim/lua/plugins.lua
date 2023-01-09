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
    max_jobs = 5
  }

  local augroup = vim.api.nvim_create_augroup("PackerPlugins", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "plugins.lua",
    group = augroup,
    callback = function()
      vim.cmd('luafile <afile>')
      vim.cmd('PackerSync')

      vim.cmd('source <afile>')
      vim.cmd('PackerCompile')
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
  end

  -- Plugins
  local function plugins(use)
    -- Keep
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
      'alpaca-tc/vim-quickrun-neovim-job',
      branch = "with_env",
      opt = true
    }

    use {
      'thinca/vim-quickrun',
      cmd = { "QuickRun" },
      requires = { 'alpaca-tc/vim-quickrun-neovim-job' },
      config = function()
        vim.g.quickrun_no_default_key_mappings = 1

        vim.g.quickrun_config = {
          _ = { runner = 'neovim_job' },
        }

        vim.g.quickrun_config['ruby.rspec'] = {
          type = 'ruby.rspec',
          command = 'rspec',
          exec = 'bundle exec %c %o %s'
        }

        vim.g.quickrun_config['typescript/deno/test'] = {
          command = 'deno',
          cmdopt = '--unstable --allow-all',
          tempfile = '%{tempname()}.ts',
          exec = { '%c test %o %s' },
        }

        -- function! s:set_ruby_command()
        -- let v = vital#quickrun#new().load('Prelude')
        -- let root = v.import('Prelude').path2project_directory(getcwd())
        --
        -- if filereadable(root . '/Gemfile')
        --   vim.g.quickrun_config['ruby'] = {
        --     \ 'command': 'ruby',
        --     \ 'exec': 'bundle exec %c %o %s',
        --     \ }
        --   else
        --     vim.g.quickrun_config['ruby'] = {
        --       \   'command': 'ruby',
        --       \   'tempfile': '%{tempname()}.rb',
        --       \ }
        --       endif
        --       endfunction
        --
        --       augroup QuickRunAutoCmd
        --       autocmd!
        --       autocmd FileType quickrun call alpaca_window#set_smart_close()
        --       autocmd FileType ruby call s:set_ruby_command()
        --       augroup END
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

    use {
      'osyo-manga/vim-over',
      cmd    = { "OverCommandLine", "OverCommandLineNoremap" },
      setup = function()
        vim.keymap.set('n', 're', ':OverCommandLine<CR>%s!!!g<Left><Left><Left>')
        vim.keymap.set('x', ':s', ':OverCommandLine<CR>s!!!g<Left><Left><Left>')
        vim.keymap.set('x', 're', '"zy:OverCommandLine<CR>%s!<C-R>=substitute(@z, \'!\', \'\\!\', \'g\')<CR>!!gI<Left><Left><Left>')
        vim.keymap.set('x', 're', '"zy:OverCommandLine<CR>%s!<C-R>=substitute(@z, \'!\', \'\\!\', \'g\')<CR>!!gI<Left><Left><Left>')
        vim.keymap.set('x', 'rr', '"zy:OverCommandLine<CR>%s!<C-R>=substitute(@z, \'!\', \'\\!\', \'g\')<CR>!<C-R>=substitute(@z, \'!\', \'\\!\', \'g\')<CR>!gI<Left><Left><Left>')

        vim.g.over_command_line_key_mappings = { ["\\<C-L>"] = "\\<C-F>" }
      end,
      config = function()
        vim.cmd("OverCommandLineNoremap <C-J> <Plug>(over-cmdline-substitute-jump-pattern)")
        vim.cmd("OverCommandLineNoremap <C-K> <Plug>(over-cmdline-substitute-jump-string)")
      end
    }

    use {
      'vim-scripts/camelcasemotion',
      keys = { "<Plug>CamelCaseMotion_w", "<Plug>CamelCaseMotion_b", "<Plug>CamelCaseMotion_e", "<Plug>CamelCaseMotion_iw", "<Plug>CamelCaseMotion_ib", "<Plug>CamelCaseMotion_ie" },
      setup = function()
        vim.keymap.set({ 'n', 'v', 'o' }, 'w', '<Plug>CamelCaseMotion_w', { silent = true })
        vim.keymap.set({ 'n', 'v', 'o' }, 'b', '<Plug>CamelCaseMotion_b', { silent = true })
        vim.keymap.set({ 'n', 'v', 'o' }, 'e', '<Plug>CamelCaseMotion_e', { silent = true })
        vim.keymap.del({ 's' }, 'w')
        vim.keymap.del({ 's' }, 'b')
        vim.keymap.del({ 's' }, 'e')
      end
    }

    -- completion / LSP
    use {
      'jose-elias-alvarez/null-ls.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      event = { 'InsertEnter' },
      config = function()
        require('null-ls').setup({
          -- capabilities = capabilities,
          sources = {
            require('null-ls').builtins.formatting.stylua,
            require('null-ls').builtins.diagnostics.rubocop.with({
              command = "bundle",
              args = { "exec", "rubocop", "-f", "json", "--force-exclusion", "--stdin", "$FILENAME" },
              prefer_local = "bundle_bin",
              condition = function(utils)
                return utils.root_has_file({".rubocop.yml", "Gemfile"})
              end
            }),
            require('null-ls').builtins.diagnostics.eslint.with({
              prefer_local = "node_modules/.bin",
              condition = function(utils)
                return utils.root_has_file({ "node_modules/.bin/eslint" })
              end
            }),
            require('null-ls').builtins.formatting.eslint.with({
              prefer_local = "node_modules/.bin",
              condition = function(utils)
                return utils.root_has_file({ "node_modules/.bin/eslint" })
              end
            }),
            -- require('null-ls').builtins.diagnostics.luacheck.with({
            --   extra_args = {"--globals", "vim", "--globals", "awesome"},
            -- }),
            require('null-ls').builtins.diagnostics.yamllint,
            require('null-ls').builtins.formatting.gofmt,
            require('null-ls').builtins.formatting.rustfmt,
            require('null-ls').builtins.formatting.rubocop.with({
              command = "bundle",
              args = { "exec", "rubocop", "--auto-correct-all", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
              prefer_local = "bundle_bin",
              condition = function(utils)
                return utils.root_has_file({".rubocop.yml", "Gemfile"})
              end
            }),
          },
        })

        vim.api.nvim_create_user_command(
          'NullLsToggle',
          function()
            require('null-ls').toggle('')
          end,
          {}
        )
      end
    }

    -- optional
    use {
      'alpaca-tc/alpaca_github.vim',
      cmd = { 'GhFile', 'GhPullRequestCurrentLine', 'GhPullRequest' },
      requires = { 'tyru/open-browser.vim' },
      setup = function()
        vim.g['alpaca_github#host'] = 'github'
        vim.keymap.set('n', ',go', ':GhFile<CR>')
        vim.keymap.set('x', ',go', ':GhFile<CR>')
        vim.keymap.set('n', ',gp', ':GhPullRequestCurrentLine<CR>')
      end
    }

    use {
      'liuchengxu/vista.vim',
      cmd = { 'Vista', 'Vista!', 'Vista!!' },
      config = function()
        vim.g.vista_default_executive = 'nvim_lsp'
        vim.g['vista#renderer#enable_icon'] = 1
        vim.g.vista_sidebar_width = 40
        vim.g.vista_icon_indent = { '', '' }
        vim.g.vista_fold_toggle_icons = vim.g.vista_fold_toggle_icons or { '▼', '▶' }
        -- let g:vista#renderer#enable_icon = 0

        vim.g.vista_executive_for = {
          c= 'nvim_lsp',
          cpp= 'nvim_lsp',
          typescript= 'nvim_lsp',
          javascript= 'nvim_lsp',
          ruby= 'ctags',
          vim= 'ctags',
        }
      end
    }

    use {
      'alpaca-tc/nvim-miniyank',
      branch = 'loop_cycle',
      keymap = { '<Plug>(miniyank-autoput)', '<Plug>(miniyank-autoPut)' },
      -- on_map = [['nx', '<Plug>(miniyank-autoput)'], ['nx', '<Plug>(miniyank-autoPut)']]
      setup = function()
        vim.g.miniyank_maxitems = 100
        vim.g.miniyank_loop_cycle = true
        vim.g.miniyank_echo_position = true

        vim.keymap.set('n', 'p', '<Plug>(miniyank-autoput)')
        vim.keymap.set('n', 'P', '<Plug>(miniyank-autoPut)')
      end,
      config = function()
        vim.keymap.set('n', '<C-P>', '<Plug>(miniyank-cycle)')
        vim.keymap.set('n', '<C-N>', '<Plug>(miniyank-cycleback)')
      end
    }

    use {
      'alpaca-tc/alpaca-switch-file.vim',
      fn = { 'switch_file#next', 'switch_file#prev' },
      setup = function()
        vim.g.switch_file_rules = {
          vim = { { 'autoload/%\\.vim', 'plugin/%\\.vim' } },
          ruby = {
            { 'spec/requests/%_spec\\.rb', 'app/controllers/%_controller\\.rb' },
            { 'spec/%_spec\\.rb', 'app/%\\.rb' },
            { 'spec/%_spec\\.rb', 'lib/%\\.rb' },
            { '%.rb', '%.rbs' },
            { 'lib/%\\.rb', 'sig/%\\.rbs', 'spec/%_spec\\.rb' },
          },
          rbs = {
            { '%.rbs', '%.rb' },
          },
          typescript = {
            { '%\\.ts', '__tests__/%.test.ts' },
            { '%\\.ts', '__tests__/%-test.ts' }
          }
        }

        vim.keymap.set('n', '<Space>a', ':call switch_file#next()<CR>')
        vim.keymap.set('n', '<Space>A', ':call switch_file#prev()<CR>')
      end
    }

    use {
      'alpaca-tc/alpaca_remove_dust.vim',
      cmd = { "RemoveDustDisable", "RemoveDustEnable", "RemoveDust", "RemoveDustForce" },
      setup = function()
        vim.g.remove_dust_enable = 1

        local group = vim.api.nvim_create_augroup("PackerAlpacaRemoveDust", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = group,
          pattern = "*",
          callback = function()
            vim.cmd('RemoveDust')
          end
        })

        vim.api.nvim_create_autocmd('FileType', {
          group = group,
          pattern = { "ts", "go", "c", "make", "markdown" },
          callback = function()
            vim.cmd('RemoveDustDisable')
          end
        })
      end
    }

    use {
      'alpaca-tc/alpaca_window.vim',
      fn = { "alpaca_window#set_smart_close", "alpaca_window#smart_close", "alpaca_window#open_buffer", "alpaca_window#util#fold_buffer_automatically" },
      keys = { '<Plug>(alpaca_window_tabnew)', '<Plug>(alpaca_window_move_buffer_into_last_tab)', '<Plug>(alpaca_window_smart_new)' },
      setup = function()
        vim.g.alpaca_window_default_filetype = 'ruby'
        vim.g.alpaca_window_max_height = vim.fn.winheight(0)
        vim.g.alpaca_window_max_width = vim.fn.winwidth(0)

        vim.keymap.set('n', '<C-W>n', '<Plug>(alpaca_window_smart_new)')
        vim.keymap.set('n', '<C-W><C-N>', '<Plug>(alpaca_window_smart_new)')
        vim.keymap.set('n', 'tc', '<Plug>(alpaca_window_tabnew)', { silent = true })
        vim.keymap.set('n', 'tw', '<Plug>(alpaca_window_move_buffer_into_last_tab)')

        local group = vim.api.nvim_create_augroup("PackerAlpacaWindow", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "qf",
          group = group,
          callback = function()
            vim.cmd('call alpaca_window#set_smart_close()')
          end
        })
      end
    }

    use {
      'RRethy/nvim-treesitter-endwise',
      requires = { 'nvim-treesitter/nvim-treesitter' }
    }

    use {
      'windwp/nvim-autopairs',
      requires = { 'RRethy/nvim-treesitter-endwise' },
      event = { 'InsertEnter' },
      config = function()
        local Rule = require('nvim-autopairs.rule')
        local npairs = require('nvim-autopairs')

        npairs.setup({
          map_c_h = true,
          map_cr = false,
        })

        npairs.add_rules(require('nvim-autopairs.rules.endwise-ruby'))
        npairs.add_rule(Rule('|', '|', { 'ruby', 'eruby' }))
        npairs.add_rule(Rule('\'\'\'', '\'\'\'', { 'toml' }))

        _G.MUtils = {}

        MUtils.CR = function()
          if vim.fn.pumvisible() ~= 0 then
            if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
              return npairs.esc('<c-y>') .. npairs.autopairs_cr()
            else
              return npairs.esc('<c-e>') .. npairs.autopairs_cr()
            end
          else
            return npairs.autopairs_cr()
          end
        end
        vim.api.nvim_set_keymap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true })
      end
    }

    use {
      'thinca/vim-qfreplace',
      cmd = { "Qfreplace" },
      ft = { "unite", "quickfix", "vimfiler" },
      fn = { "qfreplace#start" }
    }

    use {
      'kana/vim-niceblock',
      keys = { "<Plug>(niceblock-I)", "<Plug>(niceblock-A)" },
      setup = function()
        vim.keymap.set('x', 'I', '<Plug>(niceblock-I)')
        vim.keymap.set('x', 'A', '<Plug>(niceblock-A)')
      end
    }

    use {
      'alpaca-tc/beautify.vim',
      cmd    = { "Beautify" },
      run = function()
        vim.fn.system { "npm", "install", "-g", "js-beautify" }
        vim.fn.system { "npm", "install", "-g", "jq" }
        vim.fn.system { "pip", "install", "sqlparse" }
      end,
      setup = function()
        vim.g['beautify#beautifier#html2haml#ruby19_attributes'] = 1
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

    use {
      'keith/swift.vim',
      ft = { 'swift' },
      rtp = 'vim'
    }

    use {
      'hashivim/vim-terraform',
      ft = { 'terraform' },
      config = function()
        vim.g.terraform_fmt_on_save = 1
      end
    }

    use {
      'rust-lang/rust.vim',
      ft = { 'rust' },
      config = function()
        vim.g.rustfmt_autosave = 1
      end
    }

    use {
      'jlcrochet/vim-rbs',
      ft = { "rbs" }
    }

    -- -- Git
    -- use {
    --   "TimUntersberger/neogit",
    --   requires = "nvim-lua/plenary.nvim",
    --   config = function()
    --     require("config.neogit").setup()
    --   end,
    -- }
    use {
      'tpope/vim-fugitive',
      cmd = { "Git" },
      fn = { "fugitive#head" },
      setup = function()
        vim.keymap.set('n', 'gM', ':Git commit --amend<CR>', { silent = true })
        vim.keymap.set('n', 'gb', ':Git blame<CR>', { silent = true })
        vim.keymap.set('n', 'gm', ':Git commit<CR>', { silent = true })
        vim.keymap.set('n', 'gp', ':<C-U>Git push<Space>')
      end,
      config = function()
        local vgroup = vim.api.nvim_create_augroup("PackerVimFugitive", { clear = true })
        vim.api.nvim_create_autocmd('FileType', {
          group = vgroup,
          pattern = "fugitiveblame",
          command = 'vertical resize 25'
        })

        vim.api.nvim_create_autocmd('FileType', {
          group = vgroup,
          pattern = { "gitcommit", "git-diff" },
          callback = function()
            vim.keymap.set('n', 'q', ':q<CR>', { buffer = true })
          end
        })

        vim.g.fugitive_git_executable = vim.g.my.bin.git
      end
    }

    use {
      'alpaca-tc/git-vim',
      cmd = { "GitDiff", "GitVimDiff", "GitCheckout", "GitAdd", "GitLog", "GitCommit", "GitBlame", "GitPush" },
      fn = { "git#get_current_branch" },
      setup = function()
        vim.keymap.set("n", "gA", ":<C-U>GitAdd<Space>")
        vim.keymap.set('n', 'ga', ':<C-U>GitAdd<CR>', { silent = true })
        vim.keymap.set('n', 'gD', ':<C-U>GitDiff<Space>')
        vim.keymap.set('n', 'gDD', ':<C-U>GitDiff HEAD<CR>')

        vim.g.git_bin = vim.g.my.bin.git
        vim.g.git_command_edit = 'vnew'
        vim.g.git_no_default_mappings = 1
      end
    }

    -- never use
    use {
      'Shougo/vinarise.vim',
      cmd = { "Vinarise" },
      requires = { "s-yukikaze/vinarise-plugin-peanalysis" }
    }

    use {
      's-yukikaze/vinarise-plugin-peanalysis',
      opt = true,
      run = 'brew install binutils'
    }



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
