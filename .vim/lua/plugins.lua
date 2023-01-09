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
      'thinca/vim-quickrun',
      cmd = { "QuickRun" },
      requires = {
        {
          'alpaca-tc/vim-quickrun-neovim-job',
          branch = "with_env",
          opt = false
        }
      },
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
      -- keys = { "<Plug>CamelCaseMotion_w", "<Plug>CamelCaseMotion_b", "<Plug>CamelCaseMotion_e", "<Plug>CamelCaseMotion_iw", "<Plug>CamelCaseMotion_ib", "<Plug>CamelCaseMotion_ie" },
      -- opt = not vim.g.packer_loaded,
      setup = function()
        vim.keymap.set({ 'n', 'v', 'o' }, 'w', '<Plug>CamelCaseMotion_w', { silent = true })
        vim.keymap.set({ 'n', 'v', 'o' }, 'b', '<Plug>CamelCaseMotion_b', { silent = true })
        vim.keymap.set({ 'n', 'v', 'o' }, 'e', '<Plug>CamelCaseMotion_e', { silent = true })
        vim.keymap.del({ 's' }, 'w')
        vim.keymap.del({ 's' }, 'b')
        vim.keymap.del({ 's' }, 'e')

        vim.keymap.set('o', 'iw', '<Plug>CamelCaseMotion_iw', { silent = true })
        vim.keymap.set('x', 'iw', '<Plug>CamelCaseMotion_iw', { silent = true })
        vim.keymap.set('o', 'ib', '<Plug>CamelCaseMotion_ib', { silent = true })
        vim.keymap.set('x', 'ib', '<Plug>CamelCaseMotion_ib', { silent = true })
        vim.keymap.set('o', 'ie', '<Plug>CamelCaseMotion_ie', { silent = true })
        vim.keymap.set('x', 'ie', '<Plug>CamelCaseMotion_ie', { silent = true })
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

    use {
      'neovim/nvim-lspconfig',
      event = { 'InsertEnter' },
      cmd = { 'LspInfo', 'LspStart', 'LspLog', 'LspStop' },
      setup = function()
        local group = vim.api.nvim_create_augroup("PackerNvimLspconfig", { clear = true })

        vim.api.nvim_create_autocmd('FileType', {
          group = group,
          pattern = { 'python', 'c', 'ruby', 'typescript', 'javascript', 'vue', 'javascript.jsx', 'typescript.tsx', 'go', 'rust', 'css', 'scss', 'sass', 'ruby', 'typescriptreact' },
          callback = function()
            vim.opt_local.signcolumn = 'no'

            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>', { silent = true})
            vim.keymap.set('n', 'ty', '<cmd>lua vim.lsp.buf.document_symbol()<CR>', { silent = true})
            vim.keymap.set('n', 'tt', '<cmd>lua vim.lsp.buf.definition()<CR>', { silent = true})
            vim.keymap.set('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', { silent = true})
            vim.keymap.set('n', 'ti', '<cmd>lua vim.lsp.buf.implementation()<CR>', { silent = true})
            vim.keymap.set('n', 'ts', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { silent = true})
            vim.keymap.set('n', 'ta', '<cmd>lua vim.lsp.buf.code_action()<CR>', { silent = true})
            vim.keymap.set('n', 'td', '<cmd>lua vim.lsp.buf.type_definition()<CR>', { silent = true})
            vim.keymap.set('n', 'tr', '<cmd>lua vim.lsp.buf.rename()<CR>', { silent = true})
            vim.keymap.set('n', 'tf', '<cmd>lua vim.lsp.buf.references()<CR>', { silent = true})
            vim.keymap.set('n', 'te', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', { silent = true})
            vim.keymap.set('n', 'tp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', { silent = true})
            vim.keymap.set('n', 'tn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', { silent = true})
            vim.keymap.set('n', 'tl', '<cmd>lua vim.diagnostic.setloclist()<CR>', { silent = true})
            vim.keymap.set('n', 'ff', ':lua vim.lsp.buf.format { async = true }<CR>', { silent = true})

            -- nnoremap <silent> <space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
            -- nnoremap <silent> <space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
            -- nnoremap <silent> <space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
          end
        })

        vim.api.nvim_create_autocmd('BufWritePre', {
          group = group,
          pattern = { '*.go', '*.ts' },
          callback = function()
            vim.lsp.buf.format { async = false }
          end
        })

        local function goimports(timeout_ms)
          local context = { only = { "source.organizeImports" } }
          vim.validate { context = { context, "t", true } }

          local params = vim.lsp.util.make_range_params()
          params.context = context

          -- See the implementation of the textDocument/codeAction callback
          -- (lua/vim/lsp/handler.lua) for how to do this properly.
          local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
          if not result or next(result) == nil then return end
          local actions = result[1].result
          if not actions then return end
          local action = actions[1]

          -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
          -- is a CodeAction, it can have either an edit, a command or both. Edits
          -- should be executed first.
          if action.edit or type(action.command) == "table" then
            if action.edit then
              vim.lsp.util.apply_workspace_edit(action.edit)
            end
            if type(action.command) == "table" then
              vim.lsp.buf.execute_command(action.command)
            end
          else
            vim.lsp.buf.execute_command(action)
          end
        end

        vim.api.nvim_create_autocmd('BufWritePre', {
          group = group,
          pattern = { '*.go' },
          callback = function()
            goimports(1000)
          end
        })

        -- vim.lsp.set_log_level("debug")
      end
    }

    use {
      'williamboman/mason.nvim',
      event = { 'InsertEnter' },
      requires = { 'williamboman/mason-lspconfig.nvim' },
      cmd = { 'Mason', 'MasonInstall', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
      run = function()
        vim.cmd("MasonInstall lua-language-server")
        vim.cmd("MasonInstall luacheck")
        vim.cmd("MasonInstall typescript-language-server")
        vim.cmd("MasonInstall deno")
      end,
      config = function()
        -- FIXME: How to load neovim/nvim-lspconfig before loading mason.nvim?
        vim.cmd('LspStop')

        require('mason').setup()

        local lsp_config = require('lspconfig')
        local mason_lspconfig = require('mason-lspconfig')

        local function lua_vim_lsp_config()
          local library = {}
          local path = vim.split(package.path, ";")

          -- this is the ONLY correct way to setup your path
          -- table.insert(path, "lua/?.lua")
          -- table.insert(path, "lua/?/init.lua")

          local function add(lib)
            for _, p in pairs(vim.fn.expand(lib, false, true)) do
              p = vim.loop.fs_realpath(p)
              library[p] = true
            end
          end

          -- add runtime
          add("$VIMRUNTIME")
          -- add your config
          add("~/.config/nvim")
          -- add plugins
          -- if you're not using packer, then you might need to change the paths below

          -- vim.call("alpaca#initialize#directory", { vim.fn.expand("~/.local/share/nvim/site/pack/packer/opt/"), vim.fn.expand("~/.local/share/nvim/site/pack/packer/start/") })
          -- add("~/.local/share/nvim/site/pack/packer/opt/*")
          -- add("~/.local/share/nvim/site/pack/packer/start/*")

          return {
            -- delete root from workspace to make sure we don't trigger duplicate warnings
            on_new_config = function(config, root)
              local libs = vim.tbl_deep_extend("force", {}, library)
              libs[root] = nil
              config.settings.Lua.workspace.library = libs
              return config
            end,
            settings = {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                  -- Setup your lua path
                  path = path
                },
                completion = { callSnippet = "Both" },
                diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { "vim" }
                },
                workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = library,
                  maxPreload = 2000,
                  preloadFileSize = 50000
                },
                -- Do not send telemetry data containing a randomized but unique identifier
                telemetry = { enable = false }
              }
            }
          }
        end

        mason_lspconfig.setup_handlers({ function(server_name)
          local opts = {}

          if server_name == 'denols' then
            opts = {
              autostart = false,
              init_options = {
                lint = true,
                unstable = true,
                suggest = {
                  imports = {
                    hosts = {
                      ["https://deno.land"] = true,
                      ["https://cdn.nest.land"] = true,
                      ["https://crux.land"] = true,
                    },
                  },
                },
              },
            }
          elseif server_name == 'tsserver' then
            opts = {
              autostart = false,
            }
          elseif server_name == 'sorbet' then
            opts = {
              autostart = false,
              cmd = {'bundle', 'exec', 'srb', 'tc', '--lsp', '--dir', '.'},
            }
          elseif server_name == 'sumneko_lua' then
            opts = lua_vim_lsp_config()
          end

          lsp_config[server_name].setup(opts)
        end })

        local function file_match_str(path, pattern)
          if vim.fn['filereadable'](path) == 1 then
            local lines = vim.fn['readfile'](path)

            for _, line in pairs(lines) do
              if string.len(vim.fn["matchstr"](line, pattern)) > 0 then
                return true
              end
            end
          end

          return false
        end

        local function start_lsp()
          local filetype = nil

          for ft, _ in string.gmatch(vim.bo.filetype, '([^\\.]+)') do
            filetype = filetype or ft
          end

          local root = vim.fn['alpaca#current_root'](vim.fn['getcwd']())
          local isTsJs = filetype == 'typescript' or filetype == 'javascript' or filetype == 'typescriptreact'
          local currentFile = vim.fn['expand']("%:p")

          if filetype == 'ruby' and file_match_str(root .. '/Gemfile', 'sorbet') then
            vim.cmd('LspStart sorbet')
          elseif isTsJs and (vim.fn['filereadable'](root .. '/deno.json') or file_match_str(root .. '/vercel.json', 'vercel-deno') or file_match_str(currentFile, 'https://deno.land/')) then
            vim.cmd('LspStart denols')
          elseif isTsJs and file_match_str(root .. '/package.json', 'typescript') then
            vim.cmd('LspStart typescript-language-server')
          end
        end

        start_lsp()

        local group = vim.api.nvim_create_augroup("PackerMason", { clear = true })

        vim.api.nvim_create_autocmd('FileType', {
          group = group,
          pattern = { "ruby", "javascript", "typescript", "typescriptreact", "typescript.jsx" },
          callback = start_lsp
        })
      end
    }

    use {
      'Shougo/neosnippet.vim',
      cmd = { "NeoSnippetEdit", "NeoSnippetSource", "NeoSnippetClearMarkers" },
      event = { 'InsertEnter' },
      ft = { "snippet" },
      fn = { "neosnippet#get_snippets", "neosnippet#expandable_or_jumpable", "neosnippet#mappings#jump_or_expand_impl" },
      requires = { 'Shougo/context_filetype.vim' },
      setup = function()
        vim.g['neosnippet#disable_runtime_snippets'] = { ruby = 1 }
        vim.g['neosnippet#enable_preview'] = 1
        vim.g['neosnippet#snippets_directory'] = vim.g.my.dir.snippets

        vim.keymap.set('i', '<C-F>', '<Plug>(neosnippet_expand_or_jump)', { silent = true })
        vim.keymap.set('s', '<C-F>', '<Plug>(neosnippet_expand_or_jump)', { silent = true })
        vim.keymap.set('i', '<C-Space>', "ddc#map#manual_complete(['neosnippet'])", { expr = true, noremap = true, replace_keycodes = false })
        vim.keymap.set('n', '<Space>e', ':NeoSnippetEdit -split<CR>', { silent = true, noremap = true })
      end,
      config = function()
        local group = vim.api.nvim_create_augroup("PackerNeosnippet", { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = group,
          pattern = "*",
          callback = function()
            if vim.bo.modifiable and not vim.bo.readonly then
              vim.fn['neosnippet#commands#_clear_markers']()
            end
          end
        })
      end
    }

    use {
      'Shougo/ddc.vim',
      requires = {
        'vim-denops/denops.vim',
        'Shougo/pum.vim',
        'LumaKernel/ddc-file',
        'Shougo/ddc-matcher_head',
        'Shougo/ddc-sorter_rank',
        'Shougo/ddc-converter_remove_overlap',
        'Shougo/ddc-ui-native',
        'Shougo/neco-vim',
        'Shougo/ddc-source-nvim-lsp',
        'matsui54/ddc-buffer',
        'matsui54/ddc-dictionary',
        'Shougo/neosnippet.vim',
      },
      event = { 'InsertEnter' },
      config = function()
        vim.fn['ddc#custom#patch_global']({
          ui = 'native',
          completionMenu = 'pum.vim',
          sources = {
            'neosnippet',
            'nvim-lsp',
            'buffer',
            'file',
            'dictionary',
          },
          backspaceCompletion = true,
          sourceOptions = {
            _ = {
              matchers = { 'matcher_head'},
              sorters = { 'sorter_rank'},
              converters = { 'converter_remove_overlap'},
            },
            neosnippet = {
              mark = 'snip',
            },
            buffer = {
              mark = 'buffer',
              minAutoCompleteLength = 2,
            },
            dictionary = {
              mark = 'dict'
            },
            necovim = {
              mark = 'neco'
            },
            ['nvim-lsp'] = {
              mark = 'lsp',
              forceCompletionPattern = '\\.\\w*|:\\w*|->\\w*',
              minAutoCompleteLength = 0,
            },
            file = {
              mark = 'file',
              isVolatile = true,
              forceCompletionPattern = '\\S/\\S*',
              minAutoCompleteLength = 1,
            }
          },
          sourceParams = {
            file = {
              displayCwd = false,
              bufAsRoot = true,
              cwdMaxItems = 0,
              projFromCwdMaxItems = {},
              projFromBufMaxItems = {},
            },
            ['nvim-lsp'] = {
              kindLabels = {
                Class = 'c'
              }
            },
            buffer = {
              requireSameFiletype = false,
              limitBytes = 5000000,
              fromAltBuf = true,
              forceCollect = true,
            },
          },
        })

        vim.fn['ddc#custom#patch_filetype']({ 'vim' }, {
          keywordPattern = '[a-zA-Z_:]\\w*',
          sources = { 'buffer', 'necovim', 'dictionary' },
        })

        vim.fn['ddc#enable']()

        -- vim.keymap.set('i', '<Tab>', '<Cmd>call pum#map#insert_relative(+1)<CR>', { noremap = true, replace_keycodes = false })
        -- vim.keymap.set('i', '<S-Tab>', '<Cmd>call pum#map#insert_relative(-1)<CR>', { noremap = true, replace_keycodes = false })

        vim.keymap.set(
          'i',
          '<TAB>',
          function()
            local col = vim.fn['col']('.')
            local line = vim.fn['getline']('.')
            local checked_backspace = col == 1 or string.sub(line, col - 1, col - 1) == ' '

            if vim.fn.pumvisible() ~= 0 then
              return '<C-N>'
            elseif vim.fn['neosnippet#expandable_or_jumpable']() ~= 0 then
              return vim.fn['neosnippet#mappings#jump_or_expand_impl']()
            elseif checked_backspace then
              return '<TAB>'
            else
              return vim.fn['pum#map#insert_relative'](1)
            end
          end,
          { expr = true, noremap = false }
        )

        vim.keymap.set('i', '<C-X><C-F>', "ddc#map#manual_complete('file')", { expr = true })
        vim.keymap.set('i', '<C-X><C-O>', "ddc#map#manual_complete('lsp')", { expr = true })
      end
    }

    use {
      'Shougo/neco-vim',
      ft = { "vim" }
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
      -- cmd = { "RemoveDustDisable", "RemoveDustEnable", "RemoveDust", "RemoveDustForce" },
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

    use {
      'alpaca-tc/switch.vim',
      cmd = { "Switch" },
      event = { 'InsertEnter' },
      setup = function()
        vim.g.switch_no_builtins = false
      end,
      config = function()
        local switch_definition = {
          _ = {
            { ['\\Cenable'] = '\\Cdisable' },
            { ['\\CEnable'] = '\\CDisable' },
            { ['\\Ctrue'] = 'false' },
            { ['\\CTrue'] = 'False' },
            { ['\\Cfalse'] = 'true' },
            { ['\\CFalse'] = 'True' },
            { 'left', 'right' },
            { 'top', 'bottom' },
            { 'north', 'south' },
            { 'east', 'west' },
            { 'start', 'stop' },
            { 'up', 'down' },
            { 'next', 'previous' },
            { 'read', 'write' },
            { 'old', 'new' },
            { 'open', 'close' },
            { 'enable', 'disable' },
            { 'first', 'last' },
            { 'minminimun', 'maxmaxinum' },
            { 'yes', 'no' },
            { 'head', 'tail' },
            { 'push', 'pull' },
            { 'good', 'bad' },
            { 'prefix', 'suffix' },
          },
          coffee = {
            { 'if', 'unless' },
            { 'is', 'isnt' },
            { ['^\\(.*\\)->'] = '\\1=>' },
            { ['^\\(.*\\)=>'] = '\\1->' },
          },
          liquid = {
            { 'if', 'unless' },
            { 'endif', 'endunless' },
          },
          ['Rakefile,Gemfile,ruby,ruby.rspec,eruby,haml,slim'] = {
            { 'if', 'unless' },
            { 'while', 'until' },
            { '.blank?', '.present?' },
            { 'include', 'extend', 'prepend' },
            { 'class', 'module' },
            { '.inject', '.delete_if' },
            { 'attr_accessor', 'attr_reader', 'attr_writer' },
            { ['%r\\({[^}]\\+\\)}'] = '/\\1/' },
            { [':\\(\\k\\+\\)\\s*=>\\s*'] ='\\1: ' },
            { ['\\<\\(\\k\\+\\): '] =     ':\\1 => ' },
            { ['\\.\\%(tap\\)\\@!\\(\\k\\+\\)'] =  '.tap { |o| puts o.inspect }.\\1' },
            { ['\\.tap { |o| \\%(.\\{-}\\) }'] ='' },
            { ['\\(\\k\\+\\)(&:\\(\\S\\+\\))'] ='\\1 { |x| x\\.\\2 }' },
            { ['\\(\\k\\+\\)\\s\\={ |\\(\\k\\+\\)| \\2.\\(\\S\\+\\) }'] ='\\1(&:\\3)' },
          },
          ['ruby.rspec'] = {
            { 'it_has_behavior', 'it_should_behave_like' },
            { 'describe', 'context', 'specific', 'example' },
            { 'before', 'after' },
            { 'be_true', 'be_false' },
            { 'be_truthy', 'be_falsy' },
            { '==', 'eql', 'equal' },
            { ['\\.should_not'] = '\\.should' },
            { '\\.to_not', '\\.to' },
            { ['\\([^. ]\\+\\)\\.should\\(_not\\|\\)'] = 'expect(\\1)\\.to\\2' },
            { ['expect(\\([^. ]\\+\\))\\.to\\(_not\\|\\)'] = '\\1.should\\2' },
          },
          ['rails,slim,ruby'] = {
            { 100, ':continue', ':information' },
            { 101, ':switching_protocols' },
            { 102, ':processing' },
            { 200, ':ok', ':success' },
            { 201, ':created' },
            { 202, ':accepted' },
            { 203, ':non_authoritative_information' },
            { 204, ':no_content' },
            { 205, ':reset_content' },
            { 206, ':partial_content' },
            { 207, ':multi_status' },
            { 208, ':already_reported' },
            { 226, ':im_used' },
            { 300, ':multiple_choices' },
            { 301, ':moved_permanently' },
            { 302, ':found' },
            { 303, ':see_other' },
            { 304, ':not_modified' },
            { 305, ':use_proxy' },
            { 306, ':reserved' },
            { 307, ':temporary_redirect' },
            { 308, ':permanent_redirect' },
            { 400, ':bad_request' },
            { 401, ':unauthorized' },
            { 402, ':payment_required' },
            { 403, ':forbidden' },
            { 404, ':not_found' },
            { 405, ':method_not_allowed' },
            { 406, ':not_acceptable' },
            { 407, ':proxy_authentication_required' },
            { 408, ':request_timeout' },
            { 409, ':conflict' },
            { 410, ':gone' },
            { 411, ':length_required' },
            { 412, ':precondition_failed' },
            { 413, ':request_entity_too_large' },
            { 414, ':request_uri_too_long' },
            { 415, ':unsupported_media_type' },
            { 416, ':requested_range_not_satisfiable' },
            { 417, ':expectation_failed' },
            { 422, ':unprocessable_entity' },
            { 423, ':precondition_required' },
            { 424, ':too_many_requests' },
            { 426, ':request_header_fields_too_large' },
            { 500, ':internal_server_error' },
            { 501, ':not_implemented' },
            { 502, ':bad_gateway' },
            { 503, ':service_unavailable' },
            { 504, ':gateway_timeout' },
            { 505, ':http_version_not_supported' },
            { 506, ':variant_also_negotiates' },
            { 507, ':insufficient_storage' },
            { 508, ':loop_detected' },
            { 510, ':not_extended' },
            { 511, ':network_authentication_required' },
          },
          c = {
            { 'signed', 'unsigned' },
          },
          ['lua,vim'] = {
            { ['let\\s\\+\\([gstb]\\):\\(\\a\\+\\|\\a\\+\\)\\s*\\(.\\|+\\|-\\|*\\|\\\\\\)\\{,1}=\\s*\\(\\a\\+\\)\\s*.*$'] = 'vim.\\1.\\2 = \\3' },
          },
          markdown = {
            { '[ ]', '[x]' },
            { '#', '##', '###', '####', '#####' },
            { ['\\(\\*\\*\\|__\\)\\(.*\\)\\1'] = '_\\2_' },
            { ['\\(\\*\\|_\\)\\(.*\\)\\1'] = '__\\2__' },
          },
          ['typescript,javascript'] = {
            { ['const \\(.\\+\\)\\s\\+=\\s\\+require(\\(.\\+\\))'] = 'import \\1 from \\2' },
            { ['import \\(.\\+\\) from \\(.\\+\\)'] = 'const \\1 = require(\\2)' },
          }
        }

        switch_definition = vim.fn['alpaca#initialize#redefine_dict_to_each_filetype'](switch_definition, {})

        local function get_switch_mappings()
          local definitions = vim.empty_dict()
          local ft = vim.bo.filetype

          local function merge(t1, t2)
            for _, v in pairs(t2) do
              table.insert(t1, v)
            end

            return t1
          end

          if ft ~= "" then
            local filetypes = {}
            for filetype, _ in string.gmatch(ft, '([^,]+)') do
              table.insert(filetypes, filetype)
              local filetype_name = table.concat(filetypes, '.')

              if switch_definition[filetype_name] ~= nil then
                definitions = merge(definitions, switch_definition[filetype_name])
              end
            end
          end

          if vim.fn.exists('b:rails_root') == 0 and switch_definition['rails'] ~= nil then
            definitions = merge(definitions, switch_definition['rails'])
          end

          if switch_definition['_'] ~= nil then
            definitions = merge(definitions, switch_definition['_'])
          end

          return definitions
        end

        local switch_definition_cache = {}

        local function define_switch_mappings()
          if vim.fn.exists('b:switch_custom_definitions') ~= 0 then
            vim.cmd('unlet b:switch_custom_definitions')
          end

          local ft = vim.fn.empty(vim.bo.filetype) == 1 and '*' or vim.bo.filetype

          if switch_definition_cache[ft] == nil then
            switch_definition_cache[ft] = get_switch_mappings()
          end

          vim.b.switch_custom_definitions = switch_definition_cache[ft]
        end

        local group = vim.api.nvim_create_augroup("PackerSwitchVim", { clear = true })
        vim.api.nvim_create_autocmd("Filetype", {
          pattern = "*",
          group = group,
          callback = define_switch_mappings
        })

        define_switch_mappings()
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
