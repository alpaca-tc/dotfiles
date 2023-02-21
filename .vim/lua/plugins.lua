local M = {}
local S = require('string_extend')

function M.file_match_str(path, pattern)
  if vim.fn["filereadable"](path) == 1 then
    local lines = vim.fn["readfile"](path)

    for _, line in pairs(lines) do
      if string.len(vim.fn["matchstr"](line, pattern)) > 0 then
        return true
      end
    end
  end

  return false
end

function M.setup()
  -- Indicate first time installation
  local packer_bootstrap = false

  -- packer.nvim configuration
  local augroup = vim.api.nvim_create_augroup("PackerPlugins", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "plugins.lua",
      group = augroup,
      callback = function()
        vim.cmd("luafile <afile>")
        -- vim.cmd('PackerInstall')
        vim.cmd("PackerCompile")
      end,
  })

  -- Check if packer.nvim is installed
  -- Run PackerCompile if there are changes in this file
  local function packer_init()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
      packer_bootstrap = fn.system({
              "git",
              "clone",
              "https://github.com/wbthomason/packer.nvim",
              install_path,
          })
      vim.cmd([[packadd packer.nvim]])
    end
  end

  -- Plugins
  local function plugins(use)
    -- Keep
    use({ "wbthomason/packer.nvim", opt = false })

    use({ "tpope/vim-repeat", opt = false })

    use({
        "Shougo/vimproc.vim",
        fn = { "vimproc#system", "vimproc#system_bg" },
        run = "make",
    })

    use({
        "vim-jp/vital.vim",
        fn = { "vital#of", "vital#vital#new" },
        cmd = "Vitalize",
    })

    use({
        "cocopon/iceberg.vim",
        opt = false,
    })

    use({
        "alpaca-tc/alpaca_deepl.vim",
        run = ":UpdateRemotePlugins",
        cmd = { "Deepl" },
        requires = { "mattn/webapi-vim" },
        wants = { "webapi-vim" },
    })

    use({
        "tyru/open-browser.vim",
        cmd = { "OpenBrowserSearch", "OpenBrowser", "OpenBrowserSmartSearch" },
        keys = { "<Plug>(openbrowser-open)" },
        fn = { "openbrowser#open" },
        setup = function()
          vim.keymap.set("n", ",o", "<Plug>(openbrowser-open)")
          vim.keymap.set("x", ",o", "<Plug>(openbrowser-open)")
        end,
    })

    use({
        "mattn/webapi-vim",
        fn = { "webapi#json#encode", "webapi#json#decode" },
    })

    use({
        "kana/vim-arpeggio",
        event = { "InsertEnter" },
        fn = { "arpeggio#map" },
        config = function()
          local escape = "<Esc>:nohlsearch<CR>"
          vim.fn["arpeggio#map"]("i", "s", 0, "jk", escape)
          vim.fn["arpeggio#map"]("v", "s", 0, "jk", escape)
          vim.fn["arpeggio#map"]("x", "s", 0, "jk", escape)
          vim.fn["arpeggio#map"]("c", "s", 0, "jk", escape)
        end,
    })

    use({
        "thinca/vim-quickrun",
        cmd = { "QuickRun" },
        requires = { { "alpaca-tc/vim-quickrun-neovim-job", branch = "with_env" } },
        wants = { "vim-quickrun-neovim-job", "alpaca_window.vim" },
        setup = function()
          vim.keymap.set("n", ",r", ":QuickRun<CR>", { silent = true, noremap = true })
        end,
        config = function()
          vim.g.quickrun_no_default_key_mappings = 1

          vim.g.quickrun_config = {
              _ = { runner = "neovim_job" },
          }

          vim.g.quickrun_config["ruby.rspec"] = {
              type = "ruby.rspec",
              command = "rspec",
              exec = "bundle exec %c %o %s",
          }

          vim.g.quickrun_config["typescript/deno/test"] = {
              command = "deno",
              cmdopt = "--unstable --allow-all",
              tempfile = "%{tempname()}.ts",
              exec = { "%c test %o %s" },
          }

          local group = vim.api.nvim_create_augroup("PackerSwitchVim", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "quickrun",
              callback = function()
                vim.fn["alpaca_window#set_smart_close"]()
              end,
          })

          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "ruby",
              callback = function()
                local root = vim.fn["alpaca#current_root"](vim.fn["getcwd"]())

                if vim.fn.filereadable(root .. "/Gemfile") == 1 then
                  vim.g.quickrun_config["ruby"] = {
                      command = "ruby",
                      exec = "bundle exec %c %o %s",
                  }
                else
                  vim.g.quickrun_config["ruby"] = {
                      command = "ruby",
                      tempfile = "%{tempname()}.rb",
                  }
                end
              end,
          })
        end,
    })

    use({
        "echasnovski/mini.nvim",
        branch = "stable",
        event = { "BufEnter" },
        config = function()
          require("mini.comment").setup({
              -- Module mappings. Use `''` (empty string) to disable one.
              mappings = {
                  -- Toggle comment (like `gcip` - comment inner paragraph) for both
                  -- Normal and Visual modes
                  comment = "<C-_>",

                  -- Toggle comment on current line
                  comment_line = "<C-_>",

                  -- Define 'comment' textobject (like `dgc` - delete whole comment block)
                  textobject = "",
              },
          })
        end,
    })

    use({
        "osyo-manga/vim-over",
        cmd = { "OverCommandLine", "OverCommandLineNoremap" },
        setup = function()
          vim.keymap.set("n", "re", ":OverCommandLine<CR>%s!!!g<Left><Left><Left>")
          vim.keymap.set("x", ":s", ":OverCommandLine<CR>s!!!g<Left><Left><Left>")
          vim.keymap.set(
              "x",
              "re",
              "\"zy:OverCommandLine<CR>%s!<C-R>=substitute(@z, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>"
          )
          vim.keymap.set(
              "x",
              "re",
              "\"zy:OverCommandLine<CR>%s!<C-R>=substitute(@z, '!', '\\!', 'g')<CR>!!gI<Left><Left><Left>"
          )
          vim.keymap.set(
              "x",
              "rr",
              "\"zy:OverCommandLine<CR>%s!<C-R>=substitute(@z, '!', '\\!', 'g')<CR>!<C-R>=substitute(@z, '!', '\\!', 'g')<CR>!gI<Left><Left><Left>"
          )

          vim.g.over_command_line_key_mappings = { ["\\<C-L>"] = "\\<C-F>" }
        end,
        config = function()
          vim.cmd("OverCommandLineNoremap <C-J> <Plug>(over-cmdline-substitute-jump-pattern)")
          vim.cmd("OverCommandLineNoremap <C-K> <Plug>(over-cmdline-substitute-jump-string)")
        end,
    })

    use({
        "itchyny/lightline.vim",
        wants = { "git-vim" },
        event = { "InsertEnter" },
        fn = { "lightline#update", "lightline#highlight" },
        setup = function()
          local function reltime()
            return vim.fn.str2float(vim.fn.reltimestr(vim.fn.reltime()))
          end

          local Lightline = {}
          Lightline.new = function(update_time, func)
            local me = vim.empty_dict()

            me.func = function()
              return func()
            end
            me.update_time = update_time
            me.update = function()
              local now = reltime()
              me.initialized = false
              me.updatedtime = me.updatedtime or reltime()

              if not me.initialized or (now - me.updatedtime >= me.updatetime) then
                me.initialized = true
                me.updatedtime = now

                return true
              else
                return false
              end
            end

            me.statusline = function()
              me.update()
              me.cache = me.update() and me.func() or me.cache or ""
              return me.cache
            end

            return me
          end

          vim.g["lightline#functions#git_branch"] = Lightline.new(5, function()
                return vim.fn["git#get_current_branch"]()
              end)

          vim.g["lightline#functions#plugin_information"] = Lightline.new(0.5, function()
                local root = vim.fn["alpaca#current_root"](vim.fn["getcwd"]())

                if vim.fn.empty(vim.fn.bufname("%")) == 1 then
                  return ""
                elseif vim.fn.empty(root) == 0 then
                  return "%" .. string.sub(vim.fn.expand("%:p"), string.len(root) + 1, -1)
                else
                  return vim.fn.expand("%:p:~")
                end
              end)

          vim.g.lightline = {
              enable = {
                  statusline = 1,
              },
              colorscheme = "wombat",
              active = {
                  left = {
                      { "mode" },
                      { "information" },
                      { "git_branch", "modified" },
                  },
                  right = {
                      { "lineinfo",   "file_size" },
                      { "percent" },
                      { "fileformat", "fileencoding", "filetype" },
                  },
              },
              component_function = {
                  information = "g:lightline#functions#plugin_information.statusline",
              },
              component_expand = {
                  git_branch = "g:lightline#functions#git_branch.statusline",
              },
          }
        end,
        config = function()
          vim.fn["lightline#update"]()
        end,
    })

    use({
        "vim-scripts/camelcasemotion",
        keys = {
            "<Plug>CamelCaseMotion_w",
            "<Plug>CamelCaseMotion_b",
            "<Plug>CamelCaseMotion_e",
            "<Plug>CamelCaseMotion_iw",
            "<Plug>CamelCaseMotion_ib",
            "<Plug>CamelCaseMotion_ie",
        },
        setup = function()
          vim.keymap.set({ "n", "v", "o" }, "w", "<Plug>CamelCaseMotion_w", { silent = true })
          vim.keymap.set({ "n", "v", "o" }, "b", "<Plug>CamelCaseMotion_b", { silent = true })
          vim.keymap.set({ "n", "v", "o" }, "e", "<Plug>CamelCaseMotion_e", { silent = true })
          vim.keymap.del({ "s" }, "w")
          vim.keymap.del({ "s" }, "b")
          vim.keymap.del({ "s" }, "e")

          vim.keymap.set("o", "iw", "<Plug>CamelCaseMotion_iw", { silent = true })
          vim.keymap.set("x", "iw", "<Plug>CamelCaseMotion_iw", { silent = true })
          vim.keymap.set("o", "ib", "<Plug>CamelCaseMotion_ib", { silent = true })
          vim.keymap.set("x", "ib", "<Plug>CamelCaseMotion_ib", { silent = true })
          vim.keymap.set("o", "ie", "<Plug>CamelCaseMotion_ie", { silent = true })
          vim.keymap.set("x", "ie", "<Plug>CamelCaseMotion_ie", { silent = true })
        end,
    })

    use({
        "tpope/vim-surround",
        keys = {
            "<Plug>Dsurround",
            "<Plug>Csurround",
            "<Plug>Ysurround",
            "<Plug>YSurround",
            "<Plug>Yssurround",
            "<Plug>YSsurround",
            "<Plug>YSsurround",
            "<Plug>VgSurround",
            "<Plug>VSurround",
        },
        setup = function()
          vim.g.surround_no_mappings = 1

          vim.keymap.set("n", "cs", "<Plug>Csurround", { remap = true })
          vim.keymap.set("n", "ds", "<Plug>Dsurround", { remap = true })
          vim.keymap.set("n", "ySS", "<Plug>YSsurround", { remap = true })
          vim.keymap.set("n", "ySs", "<Plug>YSsurround", { remap = true })
          vim.keymap.set("n", "ys", "<Plug>Ysurround", { remap = true })
          vim.keymap.set("n", "yss", "<Plug>Yssurround", { remap = true })

          vim.keymap.set("x", "S", "<Plug>VSurround", { remap = true })
          vim.keymap.set("x", "gS", "<Plug>VgSurround", { remap = true })
          vim.keymap.set("x", "s", "<Plug>VSurround", { remap = true })
        end,
        config = function()
          local surround_definitions = {
              _ = {
                  ["("] = "(\r)",
                  ["["] = "[\r]",
                  ["<"] = "<\r>",
                  ["{"] = "{ \r }",
                  ["#"] = "#{\r}",
              },
              [vim.fn["join"](vim.g.my.ft.ruby_files, ",")] = {
                  ["#"] = "#{\r}",
                  ["%"] = "<% \r %>",
                  ["-"] = "<% \r -%>",
                  ["="] = "<%= \r %>",
                  ["w"] = "%w(\r)",
                  ["W"] = "%W(\r)",
                  ["q"] = "%q(\r)",
                  ["Q"] = "%Q(\r)",
                  ["r"] = "%r{\r}",
                  ["R"] = "%R{\r}",
                  ['"'] = '"\r"',
                  ["'"] = "'\r'",
                  ["{"] = "{ \r }",
              },
              terraform = {
                  ["$"] = "${\r}",
              },
              ["snippet,neosnippet"] = {
                  ["$"] = "${\r}",
              },
              go = {
                  ["$"] = "${\r}",
                  ["("] = "(\r)",
                  ["["] = "[\r]",
                  ["<"] = "<\r>",
              },
              ["javascript,typescript,vue,typescriptreact"] = {
                  ["("] = "(\r)",
                  ["["] = "[\r]",
                  ["$"] = "${\r}",
              },
          }

          surround_definitions =
              vim.fn["alpaca#initialize#redefine_dict_to_each_filetype"](surround_definitions, vim.empty_dict())

          local function define_variable_for_surround(key, mapping)
            local var_name = "surround_" .. vim.fn["char2nr"](key)
            vim.b[var_name] = mapping
          end

          local function get_definition(filetype)
            local memo = surround_definitions._ or {}
            local filetypes = {}

            for ft, _ in string.gmatch(filetype, "([^\\.]+)") do
              table.insert(filetypes, ft)
              local ft_name = table.concat(filetypes, ".")

              if surround_definitions[ft_name] ~= nil then
                local definition = surround_definitions[ft_name]
                memo = vim.tbl_deep_extend("force", memo, definition)
              end
            end

            return memo
          end

          local function define_variables_for_surround()
            if vim.bo.filetype == "" then
              return
            end

            local definition = get_definition(vim.bo.filetype)

            for k, v in pairs(definition) do
              define_variable_for_surround(k, v)
            end
          end

          local group = vim.api.nvim_create_augroup("PackerSurround", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "*",
              callback = define_variables_for_surround,
          })
          define_variables_for_surround()
        end,
    })

    -- Git
    use({
        "tpope/vim-fugitive",
        cmd = { "Git" },
        fn = { "fugitive#head" },
        setup = function()
          vim.keymap.set("n", "gM", ":Git commit --amend<CR>", { silent = true })
          vim.keymap.set("n", "gb", ":Git blame<CR>", { silent = true })
          vim.keymap.set("n", "gm", ":Git commit<CR>", { silent = true })
          vim.keymap.set("n", "gp", ":<C-U>Git push<Space>")
        end,
        config = function()
          local vgroup = vim.api.nvim_create_augroup("PackerVimFugitive", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
              group = vgroup,
              pattern = "fugitiveblame",
              command = "vertical resize 25",
          })

          vim.api.nvim_create_autocmd("FileType", {
              group = vgroup,
              pattern = { "gitcommit", "git-diff" },
              callback = function()
                vim.keymap.set("n", "q", ":q<CR>", { buffer = true })
              end,
          })
        end,
    })

    use({
        "alpaca-tc/git-vim",
        cmd = { "GitDiff", "GitVimDiff", "GitCheckout", "GitAdd", "GitLog", "GitCommit", "GitBlame", "GitPush" },
        fn = { "git#get_current_branch", "git#add", "git#diff" },
        setup = function()
          vim.keymap.set("n", "ga", ":<C-U>GitAdd<CR>")
          vim.keymap.set("n", "gD", ":<C-U>GitDiff<Space>")
          vim.keymap.set("n", "gDD", ":<C-U>GitDiff HEAD<CR>")

          vim.g.git_command_edit = "vnew"
          vim.g.git_no_default_mappings = 1
          vim.g.git_use_vimproc = 1
        end,
    })

    -- ddu
    use({
        "Shougo/ddu.vim",
        requires = {
            "vim-denops/denops.vim",
        },
        after = {
            "ddu-source-action",
        },
        wants = {
            "denops.vim",
        },
        fn = {
            "ddu#start",
            "ddu#custom#get_local",
            "ddu#custom#patch_global",
            "ddu#custom#patch_local",
            "ddu#custom#action",
        },
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              sourceOptions = {
                  _ = {
                      matchers = { "matcher_regexp" },
                      ignoreCase = true,
                  },
              },
          })
        end,
    })

    use({
        "Shougo/ddu-kind-file",
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              kindOptions = {
                  file = {
                      defaultAction = "open",
                  },
              },
          })

          vim.fn["ddu#custom#action"]("kind", "file", "grep", function(args)
            local paths = {}

            for _, item in pairs(args.items) do
              table.insert(paths, item.action.path)
            end

            local input = vim.fn["input"]("Pattern: ")

            vim.fn["ddu#start"]({
                name = "rg",
                push = true,
                sources = {
                    {
                        name = "rg",
                        params = {
                            input = input,
                            paths = paths,
                        },
                    },
                },
            })
          end)

          -- vim.fn['ddu#custom#action']('kind', 'file', 'quickfix', function(args)
          --   local qflist = {}
          --
          --   for _, item in pairs(args.items) do
          --     if item.action ~= nil and item.action. then
          --       let filename = s:get_filename(candidate)
          --       call add(qflist, {
          --             \ 'filename' : filename,
          --             \ 'lnum' : candidate.action__line,
          --             \ 'text' : candidate.action__text,
          --             \ })
          --     end
          --   end
          --
          --   if !empty(qflist)
          --     call setqflist(qflist)
          --     call qfreplace#start('')
          --   endif
          -- end)
        end,
    })

    use({
        "Shougo/ddu-ui-ff",
        wants = { "lightline.vim" },
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              ui = "ff",
              uiParams = {
                  ff = {
                      filterFloatingPosition = "top",
                      filterSplitDirection = "topleft",
                      startFilter = true,
                      splitDirection = "topleft",
                      previewHeight = 40,
                      previewRow = 40,
                      previewVertical = true,
                      previewWidth = 50,
                  },
              },
          })

          local function find_ddu_buffer(ft)
            for n = 1, vim.fn.winnr("$") do
              local win_ft = vim.fn.getwinvar(n, "&ft")

              if win_ft == ft then
                return n
              end
            end
          end

          local function move_to_ddu_buffer(ft)
            local winnr = find_ddu_buffer(ft)

            if winnr then
              local id = vim.fn.win_getid(winnr)
              vim.fn.win_gotoid(id)
            end
          end

          local function move_to_up_or_ddu_ui_filter()
            if vim.fn["line"](".") == 1 then
              move_to_ddu_buffer("ddu-ff-filter")
            else
              vim.fn.cursor(vim.fn.line(".") - 1, vim.fn.col("."))
            end
          end

          local function disable_lightline_on_ddu_filter_ui()
            local last = vim.fn.winnr("$")
            for n = 1, last do
              local ft = vim.fn.getwinvar(n, "&ft")

              if ft == "ddu-ff-filter" then
                local width = vim.fn.winwidth(n)
                local statusline = vim.fn["repeat"]("-", width)
                vim.fn.setwinvar(n, "&statusline", statusline)
              end
            end
          end

          local function move_to_ddu_ff_and_cr()
            move_to_ddu_buffer("ddu-ff")
            vim.fn["ddu#ui#ff#do_action"]("itemAction")
            -- vim.fn['ddu#ui#ff#close']()
          end

          local function move_ddu_ui_filter_and_call(cmd)
            move_to_ddu_buffer("ddu-ff")
            vim.cmd("normal! " .. cmd)
          end

          local function ddu_ui_ff_shared()
            local group = vim.api.nvim_create_augroup("PackerDduBufferUi", { clear = true })

            local function close_ddu_ui_ff_and_ddu_ui_ff_filter()
              vim.api.nvim_del_augroup_by_id(group)

              local last = vim.fn.winnr("$")

              for n = 1, last do
                local ft = vim.fn.getwinvar(n, "&ft")

                if ft == "ddu-ff" or ft == "ddu-ff-filter" then
                  vim.fn["ddu#ui#ff#do_action"]("quit")
                end
              end

              local winnr = find_ddu_buffer("ddu-ff-filter")

              if winnr then
                vim.fn.win_gotoid(vim.fn.win_getid(winnr))
                vim.cmd("quit!")
              end

              winnr = find_ddu_buffer("ddu-ff")

              if winnr then
                vim.fn.win_gotoid(vim.fn.win_getid(winnr))
                vim.cmd("quit!")
              end
            end

            vim.api.nvim_create_autocmd({ "BufLeave", "BufEnter" }, {
                group = group,
                pattern = "*",
                callback = function()
                  local only_ddu_ff = true
                  local ddu_ff_found = false
                  local ddu_ff_filter_found = false

                  local last = vim.fn.winnr("$")

                  for n = 1, last do
                    local ft = vim.fn.getwinvar(n, "&ft")

                    ddu_ff_found = ddu_ff_found or ft == "ddu-ff"
                    ddu_ff_filter_found = ddu_ff_filter_found or ft == "ddu-ff-filter"

                    only_ddu_ff = only_ddu_ff and (ft == "ddu-ff" or ft == "ddu-ff-filter")
                  end

                  if only_ddu_ff or (ddu_ff_filter_found and not ddu_ff_found) then
                    close_ddu_ui_ff_and_ddu_ui_ff_filter()
                  end
                end,
            })

            vim.keymap.set(
                "n",
                "q",
                close_ddu_ui_ff_and_ddu_ui_ff_filter,
                { noremap = true, buffer = true, silent = true }
            )

            vim.keymap.set(
                "n",
                "<Space>q",
                close_ddu_ui_ff_and_ddu_ui_ff_filter,
                { noremap = true, buffer = true, silent = true }
            )
          end

          local function close_filter_window_and_do_item_action()
            vim.fn["ddu#ui#ff#do_action"]("itemAction")
          end

          local function close_preview_window()
            local ddu_ff = "ddu-ff:/"

            for n = 1, vim.fn.winnr("$") do
              local bufnr = vim.fn.winbufnr(n)
              local bufname = vim.fn.bufname(bufnr)

              local is_ddu_ff = string.sub(bufname, 1, string.len(ddu_ff)) == ddu_ff

              if vim.fn.getwinvar(n, "&l:buftype") == "nofile" and is_ddu_ff then
                vim.cmd(n .. "wincmd c")
                return
              end
            end
          end

          local function ddu_toggle_preview()
            local enabled = vim.bo.ddu_preview_enabled or false
            vim.bo.ddu_preview_enabled = enabled

            local group = vim.api.nvim_create_augroup("DduBufferPreview", { clear = true })
            if enabled then
              vim.api.nvim_create_autocmd("CursorMoved", {
                  group = group,
                  pattern = "<buffer>",
                  callback = function()
                    vim.fn["ddu#ui#ff#do_action"]("preview")
                  end,
              })
            else
              close_preview_window()
            end
          end

          local function ddu_replace()
            vim.fn["ddu#ui#ff#do_action"]("itemAction", { name = "quickfix" })
            vim.fn["ddu#ui#ff#close"]()
            vim.cmd("cclose")
            vim.fn["qfreplace#start"]("")
          end

          local function get_ddu_ff_winnr()
            local last = tonumber(vim.fn["winnr"]("$"))
            for n = 1, last do
              if vim.fn.getwinvar(n, "&ft") == "ddu-ff" then
                return n
              end
            end

            return nil
          end

          local ddu_window_size = {}

          local group = vim.api.nvim_create_augroup("PackerDduUiFf", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "ddu-ff-filter",
              callback = disable_lightline_on_ddu_filter_ui,
          })

          vim.api.nvim_create_autocmd(
              { "BufLeave", "WinLeave", "WinEnter", "BufEnter", "SessionLoadPost", "FileChangedShellPost" },
              {
                  group = group,
                  pattern = "*",
                  callback = disable_lightline_on_ddu_filter_ui,
              }
          )

          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "ddu-ff",
              callback = function()
                -- autocmd! * <buffer>
                vim.api.nvim_create_augroup("DduBufferPreview", { clear = true })

                vim.opt_local.cursorline = true
                ddu_ui_ff_shared()

                vim.keymap.set(
                    "n",
                    "<CR>",
                    close_filter_window_and_do_item_action,
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "<Space>",
                    ":call ddu#ui#ff#do_action('toggleSelectItem')<CR>j",
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "f",
                    ":call ddu#ui#ff#do_action('toggleSelectItem')<CR>j",
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "x",
                    "<Space>",
                    ":call ddu#ui#ff#do_action('toggleSelectItem')<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "<Tab>",
                    ":call ddu#ui#ff#do_action('chooseAction')<CR>",
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "a",
                    ":call ddu#ui#ff#do_action('chooseAction')<CR>",
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "*",
                    ":call ddu#ui#ff#do_action('toggleAllItems')<CR>",
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "k",
                    move_to_up_or_ddu_ui_filter,
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "i",
                    ":call ddu#ui#ff#do_action('openFilterWindow')<CR>",
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "A",
                    ":call ddu#ui#ff#do_action('openFilterWindow')<CR>",
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set("n", "p", ddu_toggle_preview, { noremap = true, buffer = true, silent = true })
                vim.keymap.set("n", "re", ddu_replace, { noremap = true, buffer = true, silent = true })
              end,
          })

          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "ddu-ff-filter",
              callback = function()
                ddu_ui_ff_shared()
                vim.keymap.set("n", "j", function()
                  move_to_ddu_buffer("ddu-ff")
                end, { noremap = true, buffer = true, silent = true })
                vim.keymap.set(
                    "n",
                    "<CR>",
                    move_to_ddu_ff_and_cr,
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set(
                    "i",
                    "<CR>",
                    move_to_ddu_ff_and_cr,
                    { noremap = true, buffer = true, silent = true }
                )
                vim.keymap.set("n", "G", function()
                  move_ddu_ui_filter_and_call("G")
                end, { noremap = true, buffer = true, silent = true })

                vim.keymap.set("n", "<C-W>j", "<C-W>j<C-W>j", { noremap = true, buffer = true, silent = true })
                vim.cmd("hi! link StatusLine Normal")
              end,
          })

          vim.api.nvim_create_autocmd("WinEnter", {
              group = group,
              pattern = "*",
              callback = function()
                local win_enter = vim.bo.ft == "ddu-ff" or vim.bo.ft == "ddu-ff-filter"
                local ddu_ff_winnr = get_ddu_ff_winnr()

                if ddu_ff_winnr == nil then
                  -- ddu is closed
                  return
                end

                if win_enter then
                  if ddu_window_size[ddu_ff_winnr] ~= nil then
                    vim.cmd(ddu_ff_winnr .. "resize " .. ddu_window_size[ddu_ff_winnr][0])
                    vim.cmd("vertical " .. ddu_ff_winnr .. " resize " .. ddu_window_size[ddu_ff_winnr][1])

                    ddu_window_size[ddu_ff_winnr] = nil
                  end
                else
                  if ddu_window_size[ddu_ff_winnr] == nil then
                    ddu_window_size[ddu_ff_winnr] =
                    { [0] = vim.fn.winheight(ddu_ff_winnr),[1] = vim.fn.winwidth(ddu_ff_winnr) }
                  end

                  vim.cmd(ddu_ff_winnr .. "resize 1")
                end
              end,
          })
        end,
    })

    use({
        "Shougo/ddu-ui-filer",
        run = "brew install desktop-file-utils",
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              uiParams = {
                  filer = {
                      filterFloatingPosition = "top",
                      filterSplitDirection = "topleft",
                      splitDirection = "topleft",
                  },
              },
          })

          local function ddu_ui_filer_cr()
            if vim.fn["ddu#ui#filer#is_tree"]() then
              vim.fn["ddu#ui#filer#do_action"]("itemAction", { name = "narrow" })
            else
              vim.fn["ddu#ui#filer#do_action"](
                  "itemAction",
                  { name = "open", params = { command = "vsplit" } }
              )
            end
          end

          local group = vim.api.nvim_create_augroup("PackerUiFiler", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "ddu-filer",
              callback = function()
                -- nnoremap <buffer><expr>p vimfiler#do_action('preview')
                vim.keymap.set("n", "<CR>", ddu_ui_filer_cr, { noremap = true, silent = true, buffer = true })
                vim.keymap.set("n", "l", ddu_ui_filer_cr, { noremap = true, silent = true, buffer = true })
                vim.keymap.set(
                    "n",
                    "h",
                    "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'narrow', 'params': {'path': '..'}})<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "<Space>",
                    ":call ddu#ui#filer#do_action('toggleSelectItem')<CR>j",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "f",
                    ":call ddu#ui#filer#do_action('toggleSelectItem')<CR>j",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "<Tab>",
                    ":call ddu#ui#filer#do_action('chooseAction')<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "a",
                    ":call ddu#ui#filer#do_action('chooseAction')<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "*",
                    ":call ddu#ui#filer#do_action('toggleAllItems')<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "<C-l>",
                    ":call ddu#ui#filer#do_action('checkItems')<CR>",
                    { noremap = true, buffer = true }
                )

                vim.keymap.set("n", ".", function()
                  local function has_value(tab, val)
                    for _, value in ipairs(tab) do
                      if value == val then
                        return true
                      end
                    end

                    return false
                  end

                  local current = vim.fn["ddu#custom#get_current"]("file")
                  local enabled = has_value(current.sourceOptions.file.sorters, "dot")
                  local sorters = { "sorter_directory_file" }

                  if not enabled then
                    table.insert(sorters, "dot")
                  end

                  print(vim.inspect(sorters))
                  vim.fn["ddu#redraw"]("file", {
                      refreshItems = true,
                      updateOptions = { sourceOptions = { file = { sorters = sorters } } },
                  })
                end, { noremap = true, buffer = true })

                vim.keymap.set("n", "q", function()
                  vim.fn["ddu#ui#filer#do_action"]("quit")
                end, { noremap = true, silent = true, buffer = true })
                vim.keymap.set(
                    "n",
                    "<Space>q",
                    "<Cmd>call ddu#ui#filer#do_action('quit')<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "c",
                    "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'copy'})<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "d",
                    "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'delete'})<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "r",
                    "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'rename'})<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "m",
                    "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'move'})<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "C",
                    "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'newFile'})<CR>",
                    { noremap = true, silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "K",
                    "<Cmd>call ddu#ui#filer#do_action('itemAction', {'name': 'newDirectory'})<CR>",
                    { noremap = true, silent = true, buffer = true }
                )

                vim.keymap.set(
                    "n",
                    "gr",
                    ":call ddu#ui#filer#do_action('itemAction', {'name': 'grep'})<CR>",
                    { noremap = true, buffer = true }
                )
                -- nnoremap <expr><buffer>re vimfiler#do_action('replace')
              end,
          })
        end,
    })

    use({
        "Shougo/ddu-source-action",
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              kindOptions = {
                  action = {
                      defaultAction = "do",
                  },
              },
          })
        end,
    })

    use({
      "alpaca-tc/ddu-source-buffer",
      requires = {
          "Shougo/ddu-filter-sorter_alpha",
      },
      wants = {
          "ddu.vim",
          "ddu-ui-ff",
          "ddu-kind-file",
          "ddu-filter-matcher_regexp",
          "ddu-source-action",
      },
      keys = {
          { "n", "<C-J>b" },
      },
      config = function()
          vim.fn["ddu#custom#patch_local"]("buffers", {
              sources = { { name = "buffers" } },
              uiParams = { ff = { startFilter = false } },
              sourceOptions = {
                  buffer = {
                      converters = { "fold_path" },
                  },
              },
          })

          vim.keymap.set("n", "<C-J>b", ":call ddu#start(#{ name: 'buffers' })<CR>", { noremap = true, silent = true })
      end
    })

    use({
        "Shougo/ddu-source-file",
        requires = {
            "ryota2357/ddu-column-icon_filename",
            "Shougo/ddu-column-filename",
            "alpaca-tc/ddu-filter-sorter_directory_file",
            "alpaca-tc/ddu-filter-dot",
        },
        wants = {
            "ddu.vim",
            "ddu-ui-filer",
            "ddu-kind-file",
            "ddu-filter-matcher_regexp",
            "ddu-source-action",
            "ddu-column-filename",
            "ddu-filter-sorter_alpha",
            "ddu-filter-sorter_directory_file",
            "ddu-filter-dot",
        },
        keys = {
            { "n", "<C-J>f" },
        },
        config = function()
          vim.keymap.set("n", "<C-J>f", function()
            vim.fn["ddu#custom#patch_local"]("file", {
                sources = { { name = "file" } },
                ui = "filer",
                uiParams = {
                    filer = {
                        search = vim.fn["expand"]("%:p"),
                    },
                },
                sourceOptions = {
                    file = {
                        columns = { "filename" },
                        sorters = { "sorter_directory_file" },
                    },
                },
                columnParams = {
                    filename = {
                        fileIcon = "-",
                    },
                },
            })

            vim.fn["ddu#start"]({
                name = "file",
                sourceOptions = { file = { sorters = { "dot", "sorter_directory_file" } } },
            })
          end, { noremap = true, silent = true })
        end,
    })

    use({
        "Shougo/ddu-source-file_rec",
        requires = {
            "Shougo/ddu-filter-sorter_alpha",
        },
        wants = {
            "ddu.vim",
            "ddu-ui-ff",
            "ddu-kind-file",
            "ddu-filter-matcher_regexp",
            "ddu-source-action",
            "neosnippet.vim",
        },
        event = "User Rails",
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              sourceParams = {
                  file_rec = {
                      ignoredDirectories = { ".git", "node_modules", ".bundle" },
                  },
              },
          })

          local function setup_snippet(root, cwd)
            local function start_with(str, start)
              return string.sub(str, 1, string.len(start)) == start
            end

            local function end_with(str, ending)
              return ending == "" or string.sub(str, -#ending) == ending
            end

            local rails_snippets = {
                {
                    path = "app/views",
                    snippet = "ruby.rails.view",
                },
                {
                    path = "app/views",
                    ext = "haml",
                    snippet = "haml.rails.view",
                },
                {
                    path = "app/views",
                    ext = "erb",
                    snippet = "eruby.rails.view",
                },
                {
                    path = "app/models",
                    snippet = "ruby.rails.model",
                },
                {
                    path = "app/controllers",
                    snippet = "ruby.rails.controller",
                },
                {
                    path = "db/migrate",
                    ext = "rb",
                    snippet = "ruby.rails.migrate",
                },
                {
                    path = "config/routes.rb",
                    snippet = "ruby.rails.route",
                },
                {
                    path = "spec/factories",
                    snippet = "ruby.factory_girl",
                },
                {
                    path = "spec/controllers",
                    snippet = "ruby.rspec.controller",
                },
                {
                    path = "spec/models",
                    snippet = "ruby.rspec.model",
                },
                {
                    path = "spec/helpers",
                    snippet = "ruby.rspec.helper",
                },
                {
                    path = "spec/feature",
                    snippet = "ruby.capybara",
                },
                {
                    path = "spec/routing",
                    snippet = "ruby.rspec.routing",
                },
            }

            for _, def in pairs(rails_snippets) do
              local prefix = root .. "/" .. def.path

              if start_with(cwd, prefix) and (not def.ext or end_with(cwd, def.ext)) then
                local snippet_file = vim.fn.expand("~/.vim/snippet/" .. def.snippet .. ".snip")
                if vim.fn["filereadable"](snippet_file) then
                  vim.cmd("NeoSnippetSource " .. snippet_file)
                  vim.keymap.set(
                      "n",
                      "<Space>e",
                      ":<C-U>tabnew " .. snippet_file .. "<CR>",
                      { noremap = true, buffer = true }
                  )
                end
              end
            end
          end

          local function setup_rails()
            local cwd = vim.fn["expand"]("%:p")

            if vim.fn["alpaca#is_rails"](cwd) == 0 then
              return
            end

            local root = vim.fn["alpaca#current_root"](cwd)
            setup_snippet(root, cwd)

            local from_root = function(prefix)
              local fn = function()
                local path = root .. prefix

                vim.fn["ddu#custom#patch_local"]("file_rec", {
                    sources = { { name = "file_rec" } },
                    uiParams = {
                        ff = { startFilter = true },
                    },
                    sourceOptions = {
                        file_rec = {
                            path = path,
                            sorters = { "sorter_alpha" },
                        },
                    },
                    ui = "ff",
                })

                vim.fn["ddu#start"]({ name = "file_rec" })
              end

              return fn
            end

            vim.keymap.set("n", "<C-K>", from_root("/app/models"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K><C-K>", from_root("/app/controllers"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K><C-K><C-K>", from_root("/app/views"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>u", from_root("/app/uploaders"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>p", from_root("/app/policies"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>d", from_root("/app/decorators"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>j", from_root("/app/jobs"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>c", from_root("/config"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>se", from_root("/app/services"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>sp", from_root("/spec"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>fo", from_root("/app/forms"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>fa", from_root("/spec/factories"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>m", from_root("/app/mailers"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>l", from_root("/app/lib"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>g", ":edit " .. root .. "/Gemfile<CR>", { noremap = true, buffer = true })
            vim.keymap.set(
                "n",
                "<C-K>S",
                ":edit " .. root .. "/db/schema.rb<CR>",
                { noremap = true, buffer = true }
            )
            vim.keymap.set(
                "n",
                "<C-K>r",
                ":edit " .. root .. "/config/routes.rb<CR>",
                { noremap = true, buffer = true }
            )
            vim.keymap.set("n", "<C-K>w", from_root("/app/workers"), { noremap = true, buffer = true })
            vim.keymap.set("n", "<C-K>h", from_root("/app/helpers"), { noremap = true, buffer = true })
          end

          local group = vim.api.nvim_create_augroup("PackerDduSourceFileRec", { clear = true })
          vim.api.nvim_create_autocmd({ "User" }, {
              group = group,
              pattern = "Rails",
              callback = setup_rails,
          })
          -- vim.api.nvim_create_autocmd({ "FileType" }, {
          --   group = group,
          --   pattern = "vimfiler",
          --   callback = setup_rails,
          -- })

          setup_rails()
        end,
    })

    use({
        "alpaca-tc/ddu-source-mr",
        wants = {
            "ddu.vim",
            "ddu-ui-ff",
            "ddu-kind-file",
            "ddu-filter-matcher_regexp",
            "ddu-source-action",
        },
        keys = {
            { "n", "<C-J>j" },
        },
        config = function()
          vim.fn["ddu#custom#patch_local"]("mr", {
              sources = { { name = "mr" } },
              uiParams = { ff = { startFilter = false } },
              sourceParams = {
                  mr = {
                      kind = "mru",
                  },
              },
              sourceOptions = {
                  mr = {
                      converters = { "fold_path" },
                  },
              },
          })

          vim.keymap.set("n", "<C-J>j", ":call ddu#start(#{ name: 'mr' })<CR>", { noremap = true, silent = true })
        end,
    })

    use({
        "shun/ddu-source-rg",
        requires = {
            "Shougo/ddu-filter-converter_display_word",
        },
        wants = {
            "ddu.vim",
            "ddu-ui-ff",
            "ddu-kind-file",
            "ddu-filter-matcher_regexp",
            "ddu-source-action",
            "ddu-filter-converter_display_word",
        },
        keys = {
            { "n", "gr" },
            { "n", "gR" },
        },
        config = function()
          vim.fn["ddu#custom#patch_local"]("rg", {
              ui = "ff",
              uiParams = {
                  autoResize = false,
              },
              sourceOptions = {
                  rg = {
                      converters = { "fold_path" },
                      matchers = { "converter_display_word", "matcher_regexp" },
                  },
              },
              sourceParams = {
                  rg = {
                      args = { "--column", "--no-heading", "--color", "never", "--json", "--smart-case" },
                      highlights = {
                          path = "Directory",
                          lineNr = "Directory",
                          word = "Search",
                      },
                  },
              },
          })

          local function ddu_start_rg(input)
            local root = vim.fn["alpaca#current_root"](vim.fn["getcwd"]())
            local options = {
                name = "rg",
                sources = {
                    {
                        name = "rg",
                        params = {
                            path = root,
                            input = input,
                        },
                        options = {
                            matchers = { "converter_display_word", "matcher_regexp" },
                        },
                    },
                },
                input = input,
                ui = "ff",
                volatile = string.len(input) == 0,
                uiParams = {
                    autoResize = false,
                },
                sourceOptions = {
                    rg = {
                        converters = { "fold_path" },
                    },
                },
            }

            vim.fn["ddu#start"](options)
          end

          vim.keymap.set("n", "gr", function()
            ddu_start_rg(vim.fn.expand("<cword>"))
          end, { noremap = true, silent = true })

          vim.keymap.set("n", "gR", function()
            ddu_start_rg("")
          end, { noremap = true, silent = true })
        end,
    })

    use({
        "Shougo/ddu-source-line",
        wants = {
            "ddu.vim",
            "ddu-ui-ff",
            "ddu-kind-file",
            "ddu-filter-matcher_regexp",
            "ddu-source-action",
        },
        keys = {
            { "n", "g/" },
        },
        config = function()
          vim.keymap.set(
              "n",
              "g/",
              ":call ddu#start(#{ name: 'line', sources: [#{ name: 'line' }] })<CR>",
              { noremap = true, silent = true }
          )
        end,
    })

    use({
        "alpaca-tc/ddu-source-git",
        wants = {
            "ddu.vim",
            "ddu-ui-ff",
            "ddu-kind-file",
            "ddu-filter-matcher_regexp",
            "ddu-source-action",
        },
        keys = {
            { "n", "gl" },
            { "n", "gs" },
            { "n", "gh" },
        },
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              kindOptions = {
                  git_branch = {
                      defaultAction = "switch",
                  },
                  git_status = {
                      defaultAction = "open",
                  },
                  git_log = {
                      defaultAction = "yank_hash",
                  },
              },
          })

          vim.keymap.set(
              "n",
              "gl",
              ":call ddu#start(#{ name: 'git_log', sources: [#{ name: 'git_log' }], uiParams: #{ ff: #{ startFilter: v:false } } })<CR>",
              { noremap = true, silent = true }
          )
          vim.keymap.set(
              "n",
              "gs",
              ":call ddu#start(#{ name: 'git_status', sources: [#{ name: 'git_status' }], uiParams: #{ ff: #{ startFilter: v:false } } })<CR>",
              { noremap = true, silent = true }
          )
          vim.keymap.set(
              "n",
              "gh",
              ":call ddu#start(#{ name: 'git_branch', sources: [#{ name: 'git_branch', params: #{ args: ['-a'] } }] })<CR>",
              { noremap = true, silent = true }
          )

          local group = vim.api.nvim_create_augroup("PackerDduSourceGit", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "ddu-ff",
              callback = function()
                local source = vim.b.ddu_ui_name or ""

                if source == "git_branch" then
                  vim.keymap.set(
                      "n",
                      "gu",
                      ":call ddu#ui#ff#do_action('itemAction', {'name': 'restore'})<CR>",
                      { noremap = true, silent = true, buffer = true }
                  )
                  vim.keymap.set(
                      "n",
                      "d",
                      ":call ddu#ui#ff#do_action('itemAction', #{ name: 'delete_local'})<CR>",
                      { noremap = true, silent = true, buffer = true }
                  )
                  vim.keymap.set(
                      "n",
                      "D",
                      ":call ddu#ui#ff#do_action('itemAction', #{ name: 'delete_local_force'})<CR>",
                      { noremap = true, silent = true, buffer = true }
                  )
                elseif source == "git_status" then
                  vim.keymap.set(
                      "n",
                      "ga",
                      ":call ddu#ui#ff#do_action('itemAction', #{ name: 'add'})<CR>",
                      { noremap = true, silent = true, buffer = true }
                  )
                  vim.keymap.set(
                      "n",
                      "gu",
                      ":call ddu#ui#ff#do_action('itemAction', #{ name: 'unstage'})<CR>",
                      { noremap = true, silent = true, buffer = true }
                  )
                end
              end,
          })
        end,
    })

    use({
        "lambdalisue/mr.vim",
        fn = { "mr#mrr#list", "mr#mrw#list", "mr#mru#list" },
        event = { "BufEnter" },
        setup = function()
          local function start_with(str, start)
            return string.sub(str, 1, string.len(start)) == start
          end

          local function end_with(str, ending)
            return ending == "" or string.sub(str, -#ending) == ending
          end

          local function contains(str, sub)
            return string.find(str, sub, 1, true) ~= nil
          end

          vim.g["mr#mru#predicates"] = {
              function(filename)
                return not start_with(filename, "/private/var/")
              end,
              function(filename)
                return not end_with(filename, ".fugitiveblame")
              end,
              function(filename)
                return not end_with(filename, "COMMIT_EDITMSG")
              end,
              function(filename)
                return not contains(filename, ".git/")
              end,
          }
        end,
    })

    use({
        "alpaca-tc/ddu-filter-matcher_regexp",
        config = function()
          vim.fn["ddu#custom#patch_global"]({
              filterParams = {
                  matcher_regexp = {
                      highlightMatched = "Statement",
                  },
              },
          })
        end,
    })

    -- completion / LSP
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        wants = {
            "plenary.nvim",
        },
        event = { "InsertEnter" },
        config = function()
          require("null-ls").setup({
              -- capabilities = capabilities,
              sources = {
                  require("null-ls").builtins.formatting.stylua,
                  require("null-ls").builtins.diagnostics.rubocop.with({
                      command = "bundle",
                      args = {
                          "exec",
                          "rubocop",
                          "-f",
                          "json",
                          "--force-exclusion",
                          "--stdin",
                          "$FILENAME",
                          "--disable-pending-cops",
                      },
                      extra_args = function(params)
                        local path = vim.fn.expand('%:p')

                        if S.contains(path, 'utsuwa') then
                          return { "--server" }
                        else
                          return {}
                        end
                      end,
                      condition = function(utils)
                        return utils.root_has_file({ ".rubocop.yml" })
                      end,
                  }),
                  require("null-ls").builtins.diagnostics.eslint.with({
                      prefer_local = "node_modules/.bin",
                      condition = function(utils)
                        return utils.root_has_file({ "node_modules/.bin/eslint" })
                      end,
                  }),
                  require("null-ls").builtins.formatting.eslint.with({
                      prefer_local = "node_modules/.bin",
                      condition = function(utils)
                        return utils.root_has_file({ "node_modules/.bin/eslint" })
                      end,
                  }),
                  -- require('null-ls').builtins.diagnostics.luacheck.with({
                  --   extra_args = {"--globals", "vim", "--globals", "awesome"},
                  -- }),
                  require("null-ls").builtins.diagnostics.yamllint,
                  require("null-ls").builtins.formatting.gofmt,
                  require("null-ls").builtins.formatting.rustfmt,
                  require("null-ls").builtins.formatting.rubocop.with({
                      command = "bundle",
                      args = {
                          "exec",
                          "rubocop",
                          "--auto-correct-all",
                          "-f",
                          "quiet",
                          "--stderr",
                          "--stdin",
                          "$FILENAME",
                          "--disable-pending-cops",
                      },
                      condition = function(utils)
                        return utils.root_has_file({ ".rubocop.yml" })
                      end,
                  }),
              },
          })

          vim.api.nvim_create_user_command("NullLsToggle", function()
            require("null-ls").toggle("")
          end, {})
        end,
    })

    use({
        "neovim/nvim-lspconfig",
        event = { "InsertEnter" },
        cmd = { "LspInfo", "LspStart", "LspLog", "LspStop" },
        setup = function()
          vim.opt_local.signcolumn = "no"

          vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.declaration()<CR>", { silent = true })
          vim.keymap.set("n", "ty", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", { silent = true })
          vim.keymap.set("n", "tt", "<cmd>lua vim.lsp.buf.definition()<CR>", { silent = true })
          vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { silent = true })
          vim.keymap.set("n", "ti", "<cmd>lua vim.lsp.buf.implementation()<CR>", { silent = true })
          vim.keymap.set("n", "ts", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { silent = true })
          vim.keymap.set("n", "ta", "<cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })
          vim.keymap.set("n", "td", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { silent = true })
          vim.keymap.set("n", "tr", "<cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })
          vim.keymap.set("n", "tf", "<cmd>lua vim.lsp.buf.references()<CR>", { silent = true })
          vim.keymap.set("n", "te", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { silent = true })
          vim.keymap.set("n", "tp", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { silent = true })
          vim.keymap.set("n", "tn", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { silent = true })
          vim.keymap.set("n", "tl", "<cmd>lua vim.diagnostic.setloclist()<CR>", { silent = true })
          vim.keymap.set("n", "ff", ":lua vim.lsp.buf.format { async = true }<CR>", { silent = true })

          -- nnoremap <silent> <space>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
          -- nnoremap <silent> <space>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
          -- nnoremap <silent> <space>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>

          local group = vim.api.nvim_create_augroup("PackerNvimLspconfig", { clear = true })

          -- vim.api.nvim_create_autocmd("BufWritePre", {
          --   group = group,
          --   pattern = { "*.go", "*.ts" },
          --   callback = function()
          --     vim.lsp.buf.format({ async = false })
          --   end,
          -- })

          local function goimports(timeout_ms)
            local context = { only = { "source.organizeImports" } }
            vim.validate({ context = { context, "t", true } })

            local params = vim.lsp.util.make_range_params()
            params.context = context

            -- See the implementation of the textDocument/codeAction callback
            -- (lua/vim/lsp/handler.lua) for how to do this properly.
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
            if not result or next(result) == nil then
              return
            end
            local actions = result[1].result
            if not actions then
              return
            end
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

          vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              pattern = { "*.go" },
              callback = function()
                goimports(1000)
              end,
          })

          -- vim.lsp.set_log_level("debug")
        end,
    })

    use({
        "williamboman/mason.nvim",
        event = { "InsertEnter" },
        requires = { "williamboman/mason-lspconfig.nvim" },
        wants = { "nvim-lspconfig", "mason-lspconfig.nvim" },
        cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
        run = function()
          vim.cmd("MasonInstall lua-language-server")
          vim.cmd("MasonInstall luacheck")
          vim.cmd("MasonInstall typescript-language-server")
          vim.cmd("MasonInstall deno")
          vim.cmd("MasonInstall clangd")
        end,
        config = function()
          require("mason").setup()

          local lsp_config = require("lspconfig")
          local mason_lspconfig = require("mason-lspconfig")

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
                            path = path,
                        },
                        completion = { callSnippet = "Both" },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { "vim" },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = library,
                            maxPreload = 2000,
                            preloadFileSize = 50000,
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = { enable = false },
                    },
                },
            }
          end

          mason_lspconfig.setup_handlers({
              function(server_name)
                local opts = {}

                if server_name == "denols" then
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
                elseif server_name == "tsserver" then
                  opts = {
                      autostart = false,
                  }
                elseif server_name == "sorbet" then
                  opts = {
                      autostart = false,
                      cmd = { "bundle", "exec", "srb", "tc", "--lsp", "--dir", "." },
                  }
                elseif server_name == "sumneko_lua" then
                  opts = lua_vim_lsp_config()
                elseif server_name == "rust_analyzer" then
                  opts = {
                      autostart = true,
                      settings = {
                          ["rust-analyzer"] = {
                              imports = {
                                  granularity = {
                                      group = "module",
                                  },
                                  prefix = "self",
                              },
                              cargo = {
                                  buildScripts = {
                                      enable = true,
                                  },
                              },
                              procMacro = {
                                  enable = true,
                              },
                          },
                      },
                  }
                end

                lsp_config[server_name].setup(opts)
              end,
          })

          local function file_match_str(path, pattern)
            if vim.fn["filereadable"](path) == 1 then
              local lines = vim.fn["readfile"](path)

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

            for ft, _ in string.gmatch(vim.bo.filetype, "([^\\.]+)") do
              filetype = filetype or ft
            end

            local root = vim.fn["alpaca#current_root"](vim.fn["getcwd"]())
            local isTsJs = filetype == "typescript" or filetype == "javascript" or filetype == "typescriptreact"
            local currentFile = vim.fn["expand"]("%:p")

            if filetype == "ruby" and file_match_str(root .. "/Gemfile", "sorbet") then
              vim.cmd("LspStart sorbet")
            elseif
                isTsJs
                and (
                vim.fn["filereadable"](root .. "/deno.json") == 1
                or file_match_str(root .. "/vercel.json", "vercel-deno")
                or file_match_str(currentFile, "https://deno.land/")
                )
            then
              vim.cmd("LspStart denols")
            elseif isTsJs and file_match_str(root .. "/package.json", "typescript") then
              vim.cmd("LspStart tsserver")
            elseif filetype == "c" then
              vim.cmd("LspStart clangd")
            elseif filetype == "rust" then
              vim.cmd("LspStart rust-analyzer")
            elseif filetype == "terraform" then
              vim.cmd("LspStart terraformls")
            end
          end

          start_lsp()

          local group = vim.api.nvim_create_augroup("PackerMason", { clear = true })

          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = { "ruby", "javascript", "typescript", "typescriptreact", "typescript.jsx", "c", "rust" },
              callback = start_lsp,
          })
        end,
    })

    use({
        "Shougo/neosnippet.vim",
        cmd = { "NeoSnippetEdit", "NeoSnippetSource", "NeoSnippetClearMarkers" },
        event = { "InsertEnter" },
        ft = { "snippet" },
        fn = {
            "neosnippet#get_snippets",
            "neosnippet#expandable_or_jumpable",
            "neosnippet#mappings#jump_or_expand_impl",
        },
        requires = { "Shougo/context_filetype.vim" },
        setup = function()
          vim.g["neosnippet#disable_runtime_snippets"] = { ruby = 1 }
          vim.g["neosnippet#enable_preview"] = 1
          vim.g["neosnippet#snippets_directory"] = vim.g.my.dir.snippets

          vim.keymap.set("i", "<C-F>", "<Plug>(neosnippet_expand_or_jump)", { silent = true })
          vim.keymap.set("s", "<C-F>", "<Plug>(neosnippet_expand_or_jump)", { silent = true })
          vim.keymap.set(
              "i",
              "<C-Space>",
              "ddc#map#manual_complete(['neosnippet'])",
              { expr = true, noremap = true, replace_keycodes = false }
          )
          vim.keymap.set("n", "<Space>e", ":NeoSnippetEdit -split<CR>", { silent = true, noremap = true })
        end,
        config = function()
          local group = vim.api.nvim_create_augroup("PackerNeosnippet", { clear = true })
          vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              pattern = "*",
              callback = function()
                if vim.bo.modifiable and not vim.bo.readonly then
                  vim.fn["neosnippet#commands#_clear_markers"]()
                end
              end,
          })
        end,
    })

    use({
        "Shougo/ddc.vim",
        requires = {
            "vim-denops/denops.vim",
            "Shougo/pum.vim",
            "LumaKernel/ddc-file",
            "Shougo/ddc-matcher_head",
            "Shougo/ddc-sorter_rank",
            "Shougo/ddc-converter_remove_overlap",
            "Shougo/ddc-ui-native",
            "Shougo/neco-vim",
            "Shougo/ddc-source-nvim-lsp",
            "matsui54/ddc-buffer",
            "matsui54/ddc-dictionary",
            "Shougo/neosnippet.vim",
        },
        wants = {
            "denops.vim",
            "pum.vim",
            "ddc-file",
            "ddc-matcher_head",
            "ddc-sorter_rank",
            "ddc-converter_remove_overlap",
            "ddc-ui-native",
            "neco-vim",
            "ddc-source-nvim-lsp",
            "ddc-buffer",
            "ddc-dictionary",
            "neosnippet.vim",
        },
        event = { "InsertEnter" },
        config = function()
          vim.fn["ddc#custom#patch_global"]({
              ui = "native",
              -- completionMenu = "pum.vim",
              sources = {
                  "neosnippet",
                  "nvim-lsp",
                  "buffer",
                  "file",
                  "dictionary",
              },
              backspaceCompletion = true,
              sourceOptions = {
                  _ = {
                      matchers = { "matcher_head" },
                      sorters = { "sorter_rank" },
                      converters = { "converter_remove_overlap" },
                  },
                  neosnippet = {
                      mark = "snip",
                  },
                  buffer = {
                      mark = "buffer",
                      minAutoCompleteLength = 2,
                  },
                  dictionary = {
                      mark = "dict",
                  },
                  necovim = {
                      mark = "neco",
                  },
                  ["nvim-lsp"] = {
                      mark = "lsp",
                      forceCompletionPattern = "\\.\\w*|:\\w*|->\\w*",
                      minAutoCompleteLength = 0,
                  },
                  file = {
                      mark = "file",
                      isVolatile = true,
                      forceCompletionPattern = "\\S/\\S*",
                      minAutoCompleteLength = 1,
                  },
              },
              sourceParams = {
                  file = {
                      displayCwd = false,
                      bufAsRoot = true,
                      cwdMaxItems = 0,
                      projFromCwdMaxItems = {},
                      projFromBufMaxItems = {},
                  },
                  ["nvim-lsp"] = {
                      kindLabels = {
                          Class = "c",
                      },
                  },
                  buffer = {
                      requireSameFiletype = false,
                      limitBytes = 5000000,
                      fromAltBuf = true,
                      forceCollect = true,
                  },
              },
          })

          vim.fn["ddc#custom#patch_filetype"]({ "vim" }, {
              keywordPattern = "[a-zA-Z_:]\\w*",
              sources = { "buffer", "necovim", "dictionary" },
          })

          vim.fn["ddc#enable"]()

          -- vim.keymap.set('i', '<Tab>', '<Cmd>call pum#map#insert_relative(+1)<CR>', { noremap = true, replace_keycodes = false })
          -- vim.keymap.set('i', '<S-Tab>', '<Cmd>call pum#map#insert_relative(-1)<CR>', { noremap = true, replace_keycodes = false })

          vim.keymap.set("i", "<TAB>", function()
            local col = vim.fn["col"](".")
            local line = vim.fn["getline"](".")
            local checked_backspace = col == 1 or string.sub(line, col - 1, col - 1) == " "

            if vim.fn.pumvisible() ~= 0 then
              return "<C-N>"
            elseif vim.fn["neosnippet#expandable_or_jumpable"]() ~= 0 then
              return vim.fn["neosnippet#mappings#jump_or_expand_impl"]()
            elseif checked_backspace then
              return "<TAB>"
            else
              return vim.fn["pum#map#insert_relative"](1)
            end
          end, { expr = true, noremap = false })

          vim.keymap.set("i", "<C-X><C-F>", "ddc#map#manual_complete('file')", { expr = true })
          vim.keymap.set("i", "<C-X><C-O>", "ddc#map#manual_complete('lsp')", { expr = true })
        end,
    })

    use({
        "Shougo/neco-vim",
        ft = { "vim" },
    })

    -- utilities
    use({
        "Shougo/vimfiler",
        cmd = { "VimFiler", "VimFilerBufferDir", "VimFilerExplorer", "VimFilerCreate" },
        wants = {
            "unite.vim",
            "vimproc.vim",
        },
        setup = function()
          vim.g.vimfiler_data_directory = vim.g.my.dir.vimfiler
          vim.g.vimfiler_force_overwrite_statusline = 0
          vim.g.vimfiler_draw_files_limit = 0
          vim.g.vimfiler_safe_mode_by_default = 0
          vim.g.vimfiler_as_default_explorer = 1
          vim.g.vimfiler_sort_type = "filename"
          vim.g.vimfiler_preview_action = ""
          vim.g.vimfiler_enable_auto_cd = 1
          vim.g.vimfiler_file_icon = "-"
          vim.g.vimfiler_max_directories_history = 1000
          vim.g.vimfiler_tree_indentation = 1
          vim.g.vimfiler_readonly_file_icon = "x"
          vim.g.vimfiler_tree_closed_icon = "‣"
          vim.g.vimfiler_tree_leaf_icon = " "
          vim.g.vimfiler_tree_opened_icon = "▾"
          vim.g.vimfiler_marked_file_icon = "✓"
          vim.g.vimfiler_ignore_pattern = "\\v^(\\.git|\\.)"
          vim.g.unite_kind_cdable_lcd_command = "lcd"
          vim.g.vimfiler_no_default_key_mappings = 1

          vim.keymap.set("n", ",,", ":VimFilerCreate<CR>", { silent = true, noremap = true })

          if vim.fn.has("vim_starting") == 1 then
            local group = vim.api.nvim_create_augroup("PackerVimfilerSetup", { clear = true })
            vim.api.nvim_create_autocmd("VimEnter", {
                group = group,
                pattern = "*",
                callback = function()
                  vim.api.nvim_del_augroup_by_id(group)

                  if vim.fn.argc() == 0 then
                    vim.cmd("VimFiler")
                  end
                end,
            })
          end
        end,
        config = function()
          local group = vim.api.nvim_create_augroup("PackerVimfiler", { clear = true })

          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "vimfiler",
              callback = function()
                if vim.b.vimfiler == nil then
                  return
                end

                vim.opt_local.number = false

                vim.keymap.set("n", "C", "<Plug>(vimfiler_new_file)", { buffer = true })
                vim.keymap.set("n", "<C-J>", "[unite]", { buffer = true })
                vim.keymap.set("n", "<CR>", "<Plug>(vimfiler_edit_file)", { buffer = true })
                vim.keymap.set("n", "b", ":<C-U>UniteBookmarkAdd<CR>", { noremap = true, buffer = true })
                vim.keymap.set(
                    "n",
                    "<expr>p",
                    "vimfiler#do_action('preview')",
                    { noremap = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "<buffer>re",
                    "vimfiler#do_action('replace')",
                    { noremap = true, expr = true }
                )
                vim.keymap.set("n", "v", "v", { noremap = true, buffer = true })
                vim.keymap.set(
                    "n",
                    "<buffer>gs",
                    ":call ddu#start(#{ name: 'git_status', sources: [#{ name: 'git_status' }], uiParams: #{ ff: #{ startFilter: v:false } } })<CR>",
                    { noremap = true, silent = true }
                )
                vim.keymap.set(
                    "n",
                    "u",
                    ":<C-U>Unite file -no-start-insert -buffer-name=file<CR>",
                    { noremap = true, buffer = true }
                )
                vim.keymap.set("n", "<TAB>", "<Plug>(vimfiler_switch_to_other_window)", { buffer = true })
                vim.keymap.set("n", "<TAB>", "<Plug>(vimfiler_switch_to_another_vimfiler)", { buffer = true })
                vim.keymap.set("n", "j", "<Plug>(vimfiler_loop_cursor_down)", { buffer = true })
                vim.keymap.set("n", "k", "<Plug>(vimfiler_loop_cursor_up)", { buffer = true })

                -- Toggle mark.
                vim.keymap.set("n", "<C-l>", "<Plug>(vimfiler_redraw_screen)", { buffer = true })
                vim.keymap.set("n", "<Space>", "<Plug>(vimfiler_toggle_mark_current_line)", { buffer = true })
                vim.keymap.set("n", "s", "<Plug>(vimfiler_toggle_mark_current_line)", { buffer = true })
                vim.keymap.set("v", "<Space>", "<Plug>(vimfiler_toggle_mark_selected_lines)", { buffer = true })

                -- Toggle marks in all lines.
                vim.keymap.set("n", "*", "<Plug>(vimfiler_toggle_mark_all_lines)", { buffer = true })
                vim.keymap.set("n", "&", "<Plug>(vimfiler_mark_similar_lines)", { buffer = true })
                -- Clear marks in all lines.
                vim.keymap.set("n", "U", "<Plug>(vimfiler_clear_mark_all_lines)", { buffer = true })

                -- Copy files.
                vim.keymap.set("n", "c", "<Plug>(vimfiler_copy_file)", { buffer = true })
                vim.keymap.set("n", "Cc", "<Plug>(vimfiler_clipboard_copy_file)", { buffer = true })

                -- Move files.
                vim.keymap.set("n", "m", "<Plug>(vimfiler_move_file)", { buffer = true })
                vim.keymap.set("n", "Cm", "<Plug>(vimfiler_clipboard_move_file)", { buffer = true })

                -- Delete files.
                vim.keymap.set("n", "d", "<Plug>(vimfiler_delete_file)", { buffer = true })

                -- Rename.
                vim.keymap.set("n", "r", "<Plug>(vimfiler_rename_file)", { buffer = true })

                -- Make directory.
                vim.keymap.set("n", "K", "<Plug>(vimfiler_make_directory)", { buffer = true })

                -- Paste.
                vim.keymap.set("n", "Cp", "<Plug>(vimfiler_clipboard_paste)", { buffer = true })

                -- Execute or change directory.
                vim.keymap.set("n", "R", "<Plug>(vimfiler_execute)", { buffer = true })
                vim.keymap.set("n", "l", "<Plug>(vimfiler_smart_l)", { buffer = true })

                vim.keymap.set("n", "x", "<Plug>(vimfiler_execute_system_associated)", { buffer = true })

                -- Move to directory.
                vim.keymap.set("n", "h", "<Plug>(vimfiler_smart_h)", { buffer = true })
                vim.keymap.set("n", "L", "<Plug>(vimfiler_switch_to_drive)", { buffer = true })
                vim.keymap.set("n", "~", "<Plug>(vimfiler_switch_to_project_directory)", { buffer = true })
                vim.keymap.set("n", "<BS>", "<Plug>(vimfiler_switch_to_parent_directory)", { buffer = true })

                vim.keymap.set("n", "gv", "<Plug>(vimfiler_execute_new_gvim)", { buffer = true })
                vim.keymap.set("n", ".", "<Plug>(vimfiler_toggle_visible_ignore_files)", { buffer = true })
                vim.keymap.set("n", "H", "<Plug>(vimfiler_popup_shell)", { buffer = true })

                -- Edit file.
                vim.keymap.set("n", "e", "<Plug>(vimfiler_edit_file)", { buffer = true })
                vim.keymap.set("n", "E", "<Plug>(vimfiler_split_edit_file)", { buffer = true })
                vim.keymap.set("n", "B", "<Plug>(vimfiler_edit_binary_file)", { buffer = true })

                -- Choose action.
                vim.keymap.set("n", "a", "<Plug>(vimfiler_choose_action)", { buffer = true })

                -- Hide vimfiler.
                vim.keymap.set("n", "q", "<Plug>(vimfiler_hide)", { buffer = true })
                -- Exit vimfiler.
                vim.keymap.set("n", "Q", "<Plug>(vimfiler_exit)", { buffer = true })
                -- Close vimfiler.
                vim.keymap.set("n", "-", "<Plug>(vimfiler_close)", { buffer = true })

                vim.keymap.set("n", "ge", "<Plug>(vimfiler_execute_external_filer)", { buffer = true })
                vim.keymap.set(
                    "n",
                    "<RightMouse>",
                    "<Plug>(vimfiler_execute_external_filer)",
                    { buffer = true }
                )

                vim.keymap.set("n", "!", "<Plug>(vimfiler_execute_shell_command)", { buffer = true })
                vim.keymap.set("n", "?", "<Plug>(vimfiler_help)", { buffer = true })
                vim.keymap.set("n", "v", "<Plug>(vimfiler_preview_file)", { buffer = true })
                vim.keymap.set("n", "o", "<Plug>(vimfiler_sync_with_current_vimfiler)", { buffer = true })
                vim.keymap.set("n", "O", "<Plug>(vimfiler_open_file_in_another_vimfiler)", { buffer = true })
                vim.keymap.set("n", "<C-g>", "<Plug>(vimfiler_print_filename)", { buffer = true })
                vim.keymap.set("n", "g<C-g>", "<Plug>(vimfiler_toggle_maximize_window)", { buffer = true })
                vim.keymap.set("n", "yy", "<Plug>(vimfiler_yank_full_path)", { buffer = true })
                vim.keymap.set("n", "M", "<Plug>(vimfiler_set_current_mask)", { buffer = true })
                vim.keymap.set("n", "gr", function()
                  local vimfiler = vim.b.vimfiler
                  vim.fn["vimfiler#mappings#do_action"](vimfiler, "ddu-rg")
                end, { buffer = true })
                vim.keymap.set("n", "gf", "<Plug>(vimfiler_find)", { buffer = true })
                vim.keymap.set("n", "S", "<Plug>(vimfiler_select_sort_type)", { buffer = true })
                vim.keymap.set("n", "<C-v>", "<Plug>(vimfiler_switch_vim_buffer_mode)", { buffer = true })
                vim.keymap.set("n", "gc", "<Plug>(vimfiler_cd_vim_current_dir)", { buffer = true })
                vim.keymap.set("n", "gS", "<Plug>(vimfiler_toggle_simple_mode)", { buffer = true })
                vim.keymap.set("n", "gg", "<Plug>(vimfiler_cursor_top)", { buffer = true })
                vim.keymap.set("n", "G", "<Plug>(vimfiler_cursor_bottom)", { buffer = true })
                vim.keymap.set("n", "t", "<Plug>(vimfiler_expand_tree)", { buffer = true })
                vim.keymap.set("n", "T", "<Plug>(vimfiler_expand_tree_recursive)", { buffer = true })
                vim.keymap.set("n", "I", "<Plug>(vimfiler_cd_input_directory)", { buffer = true })
                vim.keymap.set("n", "<2-LeftMouse>", "<Plug>(vimfiler_double_click)", { buffer = true })

                -- pushd/popd
                vim.keymap.set("n", "Y", "<Plug>(vimfiler_pushd)", { buffer = true })
                vim.keymap.set("n", "P", "<Plug>(vimfiler_popd)", { buffer = true })

                vim.keymap.set("n", "gj", "<Plug>(vimfiler_jump_last_child)", { buffer = true })
                vim.keymap.set("n", "gk", "<Plug>(vimfiler_jump_first_child)", { buffer = true })
              end,
          })
        end,
    })

    -- optional
    use({
        "alpaca-tc/alpaca_github.vim",
        cmd = { "GhFile", "GhPullRequestCurrentLine", "GhPullRequest" },
        requires = { "tyru/open-browser.vim" },
        setup = function()
          vim.g["alpaca_github#host"] = "github"
          vim.keymap.set("n", ",go", ":GhFile<CR>")
          vim.keymap.set("x", ",go", ":GhFile<CR>")
          vim.keymap.set("n", ",gp", ":GhPullRequestCurrentLine<CR>")
        end,
    })

    use({
        "liuchengxu/vista.vim",
        cmd = { "Vista", "Vista!", "Vista!!" },
        setup = function()
          vim.keymap.set("n", "<Space>t", ":Vista!!<CR>", { noremap = true })
        end,
        config = function()
          vim.g.vista_default_executive = "nvim_lsp"
          vim.g["vista#renderer#enable_icon"] = 1
          vim.g.vista_sidebar_width = 40
          vim.g.vista_icon_indent = { "", "" }
          vim.g.vista_fold_toggle_icons = vim.g.vista_fold_toggle_icons or { "▼", "▶" }
          -- let g:vista#renderer#enable_icon = 0

          vim.g.vista_executive_for = {
              c = "nvim_lsp",
              cpp = "nvim_lsp",
              lua = "nvim_lsp",
              typescript = "nvim_lsp",
              javascript = "nvim_lsp",
              ruby = "ctags",
              vim = "ctags",
          }
        end,
    })

    use({
        "alpaca-tc/nvim-miniyank",
        branch = "loop_cycle",
        keys = { "<Plug>(miniyank-autoput)", "<Plug>(miniyank-autoPut)" },
        -- on_map = [['nx', '<Plug>(miniyank-autoput)'], ['nx', '<Plug>(miniyank-autoPut)']]
        setup = function()
          vim.g.miniyank_maxitems = 100
          vim.g.miniyank_loop_cycle = true
          vim.g.miniyank_echo_position = true

          vim.keymap.set("n", "p", "<Plug>(miniyank-autoput)")
          vim.keymap.set("n", "P", "<Plug>(miniyank-autoPut)")
        end,
        config = function()
          vim.keymap.set("n", "<C-P>", "<Plug>(miniyank-cycle)")
          vim.keymap.set("n", "<C-N>", "<Plug>(miniyank-cycleback)")
        end,
    })

    use({
        "alpaca-tc/alpaca-switch-file.vim",
        fn = { "switch_file#next", "switch_file#prev" },
        setup = function()
          vim.g.switch_file_rules = {
              vim = { { "autoload/%\\.vim", "plugin/%\\.vim" } },
              ruby = {
                  { "spec/requests/%_spec\\.rb", "app/controllers/%_controller\\.rb" },
                  { "spec/%_spec\\.rb",          "app/%\\.rb" },
                  { "spec/%_spec\\.rb",          "spec/lib/%_spec\\.rb",             "lib/%\\.rb" },
                  { "%.rb",                      "%.rbs" },
                  { "lib/%\\.rb",                "sig/%\\.rbs",                      "spec/%_spec\\.rb" },
              },
              rbs = {
                  { "%.rbs", "%.rb" },
              },
              typescript = {
                  { "%\\.ts", "__tests__/%.test.ts" },
                  { "%\\.ts", "__tests__/%-test.ts" },
              },
          }

          vim.keymap.set("n", "<Space>a", ":call switch_file#next()<CR>")
          vim.keymap.set("n", "<Space>A", ":call switch_file#prev()<CR>")
        end,
    })

    use({
        "alpaca-tc/alpaca_remove_dust.vim",
        cmd = { "RemoveDustDisable", "RemoveDustEnable", "RemoveDust", "RemoveDustForce" },
        setup = function()
          vim.g.remove_dust_enable = 1

          local group = vim.api.nvim_create_augroup("PackerAlpacaRemoveDust", { clear = true })
          vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              pattern = "*",
              callback = function()
                vim.cmd("RemoveDust")
              end,
          })

          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = { "ts", "go", "c", "make", "markdown" },
              callback = function()
                vim.cmd("RemoveDustDisable")
              end,
          })
        end,
    })

    use({
        "alpaca-tc/alpaca_window.vim",
        fn = {
            "alpaca_window#set_smart_close",
            "alpaca_window#smart_close",
            "alpaca_window#open_buffer",
            "alpaca_window#util#fold_buffer_automatically",
        },
        keys = {
            "<Plug>(alpaca_window_tabnew)",
            "<Plug>(alpaca_window_move_buffer_into_last_tab)",
            "<Plug>(alpaca_window_smart_new)",
        },
        setup = function()
          vim.g.alpaca_window_default_filetype = "ruby"
          vim.g.alpaca_window_max_height = vim.fn.winheight(0)
          vim.g.alpaca_window_max_width = vim.fn.winwidth(0)

          vim.keymap.set("n", "tc", "<Plug>(alpaca_window_tabnew)", { silent = true })
          vim.keymap.set("n", "tw", "<Plug>(alpaca_window_move_buffer_into_last_tab)")

          local group = vim.api.nvim_create_augroup("PackerAlpacaWindow", { clear = true })
          vim.api.nvim_create_autocmd("FileType", {
              pattern = "qf",
              group = group,
              callback = function()
                vim.fn["alpaca_window#set_smart_close"]()
              end,
          })
        end,
    })

    use({
        "RRethy/nvim-treesitter-endwise",
        requires = { "nvim-treesitter/nvim-treesitter" },
        wants = { "nvim-treesitter" },
    })

    use({
        "windwp/nvim-autopairs",
        requires = { "RRethy/nvim-treesitter-endwise" },
        wants = { "nvim-treesitter-endwise" },
        event = { "InsertEnter" },
        config = function()
          local Rule = require("nvim-autopairs.rule")
          local npairs = require("nvim-autopairs")

          npairs.setup({
              map_c_h = true,
              map_cr = false,
          })

          local endwise = require("nvim-autopairs.ts-rule").endwise
          local ruby_types = { "ruby", "eruby", "ruby.rspec" }

          npairs.add_rules({
              endwise("%sdo$", "end", ruby_types, nil),
              endwise("%sdo%s|.*|$", "end", ruby_types, nil),
              endwise("begin$", "end", ruby_types, nil),
              endwise("def%s.+$", "end", ruby_types, nil),
              endwise("module%s.+$", "end", ruby_types, nil),
              endwise("class%s.+$", "end", ruby_types, nil),
              endwise("[%s=]%sif%s.+$", "end", ruby_types, nil),
              endwise("[%s=]%sunless%s.+$", "end", ruby_types, nil),
              endwise("[%s=]%scase%s.+$", "end", ruby_types, nil),
              endwise("[%s=]%swhile%s.+$", "end", ruby_types, nil),
              endwise("[%s=]%suntil%s.+$", "end", ruby_types, nil),
          })

          npairs.add_rule(Rule("|", "|", ruby_types))
          npairs.add_rule(Rule("|", "|", { "rust" }))
          npairs.add_rule(Rule("'''", "'''", { "toml" }))

          _G.MUtils = {}

          MUtils.CR = function()
            if vim.fn.pumvisible() ~= 0 then
              if vim.fn.complete_info({ "selected" }).selected ~= -1 then
                return npairs.esc("<c-y>") .. npairs.autopairs_cr()
              else
                return npairs.esc("<c-e>") .. npairs.autopairs_cr()
              end
            else
              return npairs.autopairs_cr()
            end
          end
          vim.api.nvim_set_keymap("i", "<cr>", "v:lua.MUtils.CR()", { expr = true, noremap = true })
        end,
    })

    use({
        "thinca/vim-qfreplace",
        cmd = { "Qfreplace" },
        ft = { "unite", "quickfix", "vimfiler" },
        fn = { "qfreplace#start" },
    })

    use({
        "kana/vim-niceblock",
        keys = { "<Plug>(niceblock-I)", "<Plug>(niceblock-A)" },
        setup = function()
          vim.keymap.set("x", "I", "<Plug>(niceblock-I)")
          vim.keymap.set("x", "A", "<Plug>(niceblock-A)")
        end,
    })

    use({
        "alpaca-tc/beautify.vim",
        cmd = { "Beautify" },
        run = function()
          vim.fn.system({ "npm", "install", "-g", "js-beautify" })
          vim.fn.system({ "npm", "install", "-g", "jq" })
          vim.fn.system({ "pip", "install", "sqlparse" })
        end,
        setup = function()
          vim.g["beautify#beautifier#html2haml#ruby19_attributes"] = 1
        end,
    })

    use({
        "alpaca-tc/switch.vim",
        cmd = { "Switch" },
        event = { "InsertEnter" },
        setup = function()
          vim.g.switch_no_builtins = false
          vim.keymap.set("n", "!", ":Switch<CR>", { noremap = true })
        end,
        config = function()
          local switch_definition = {
              _ = {
                  { ["\\Cenable"] = "\\Cdisable" },
                  { ["\\CEnable"] = "\\CDisable" },
                  { ["\\Ctrue"] = "false" },
                  { ["\\CTrue"] = "False" },
                  { ["\\Cfalse"] = "true" },
                  { ["\\CFalse"] = "True" },
                  { "left",                      "right" },
                  { "top",                       "bottom" },
                  { "north",                     "south" },
                  { "east",                      "west" },
                  { "start",                     "stop" },
                  { "up",                        "down" },
                  { "next",                      "previous" },
                  { "read",                      "write" },
                  { "old",                       "new" },
                  { "open",                      "close" },
                  { "enable",                    "disable" },
                  { "first",                     "last" },
                  { "minminimun",                "maxmaxinum" },
                  { "yes",                       "no" },
                  { "head",                      "tail" },
                  { "push",                      "pull" },
                  { "good",                      "bad" },
                  { "prefix",                    "suffix" },
              },
              coffee = {
                  { "if",                     "unless" },
                  { "is",                     "isnt" },
                  { ["^\\(.*\\)->"] = "\\1=>" },
                  { ["^\\(.*\\)=>"] = "\\1->" },
              },
              liquid = {
                  { "if",    "unless" },
                  { "endif", "endunless" },
              },
              ["Rakefile,Gemfile,ruby,ruby.rspec,eruby,haml,slim"] = {
                  { "if",                                                                    "unless" },
                  { "while",                                                                 "until" },
                  { ".blank?",                                                               ".present?" },
                  { "include",                                                               "extend",      "prepend" },
                  { "class",                                                                 "module" },
                  { ".inject",                                                               ".delete_if" },
                  { "attr_accessor",                                                         "attr_reader", "attr_writer" },
                  { ["%r\\({[^}]\\+\\)}"] = "/\\1/" },
                  { [":\\(\\k\\+\\)\\s*=>\\s*"] = "\\1: " },
                  { ["\\<\\(\\k\\+\\): "] = ":\\1 => " },
                  { ["\\.\\%(tap\\)\\@!\\(\\k\\+\\)"] = ".tap { |o| puts o.inspect }.\\1" },
                  { ["\\.tap { |o| \\%(.\\{-}\\) }"] = "" },
                  { ["\\(\\k\\+\\)(&:\\(\\S\\+\\))"] = "\\1 { |x| x\\.\\2 }" },
                  { ["\\(\\k\\+\\)\\s\\={ |\\(\\k\\+\\)| \\2.\\(\\S\\+\\) }"] = "\\1(&:\\3)" },
              },
              ["ruby.rspec"] = {
                  { "it_has_behavior",                                               "it_should_behave_like" },
                  { "describe",                                                      "context",              "specific", "example" },
                  { "before",                                                        "after" },
                  { "be_true",                                                       "be_false" },
                  { "be_truthy",                                                     "be_falsy" },
                  { "==",                                                            "eql",                  "equal" },
                  { ["\\.should_not"] = "\\.should" },
                  { "\\.to_not",                                                     "\\.to" },
                  { ["\\([^. ]\\+\\)\\.should\\(_not\\|\\)"] = "expect(\\1)\\.to\\2" },
                  { ["expect(\\([^. ]\\+\\))\\.to\\(_not\\|\\)"] = "\\1.should\\2" },
              },
              ["rails,slim,ruby"] = {
                  { 100, ":continue",                       ":information" },
                  { 101, ":switching_protocols" },
                  { 102, ":processing" },
                  { 200, ":ok",                             ":success" },
                  { 201, ":created" },
                  { 202, ":accepted" },
                  { 203, ":non_authoritative_information" },
                  { 204, ":no_content" },
                  { 205, ":reset_content" },
                  { 206, ":partial_content" },
                  { 207, ":multi_status" },
                  { 208, ":already_reported" },
                  { 226, ":im_used" },
                  { 300, ":multiple_choices" },
                  { 301, ":moved_permanently" },
                  { 302, ":found" },
                  { 303, ":see_other" },
                  { 304, ":not_modified" },
                  { 305, ":use_proxy" },
                  { 306, ":reserved" },
                  { 307, ":temporary_redirect" },
                  { 308, ":permanent_redirect" },
                  { 400, ":bad_request" },
                  { 401, ":unauthorized" },
                  { 402, ":payment_required" },
                  { 403, ":forbidden" },
                  { 404, ":not_found" },
                  { 405, ":method_not_allowed" },
                  { 406, ":not_acceptable" },
                  { 407, ":proxy_authentication_required" },
                  { 408, ":request_timeout" },
                  { 409, ":conflict" },
                  { 410, ":gone" },
                  { 411, ":length_required" },
                  { 412, ":precondition_failed" },
                  { 413, ":request_entity_too_large" },
                  { 414, ":request_uri_too_long" },
                  { 415, ":unsupported_media_type" },
                  { 416, ":requested_range_not_satisfiable" },
                  { 417, ":expectation_failed" },
                  { 422, ":unprocessable_entity" },
                  { 423, ":precondition_required" },
                  { 424, ":too_many_requests" },
                  { 426, ":request_header_fields_too_large" },
                  { 500, ":internal_server_error" },
                  { 501, ":not_implemented" },
                  { 502, ":bad_gateway" },
                  { 503, ":service_unavailable" },
                  { 504, ":gateway_timeout" },
                  { 505, ":http_version_not_supported" },
                  { 506, ":variant_also_negotiates" },
                  { 507, ":insufficient_storage" },
                  { 508, ":loop_detected" },
                  { 510, ":not_extended" },
                  { 511, ":network_authentication_required" },
              },
              c = {
                  { "signed", "unsigned" },
              },
              ["lua,vim"] = {
                  {
                      ["let\\s\\+\\([gstb]\\):\\(\\a\\+\\|\\a\\+\\)\\s*\\(.\\|+\\|-\\|*\\|\\\\\\)\\{,1}=\\s*\\(\\a\\+\\)\\s*.*$"] = "vim.\\1.\\2 = \\3",
                  },
              },
              markdown = {
                  { ["[ ]"] = "[x]" },
                  { ["\\[\\(.\\+\\)\\]"] = "［\\1］" },
                  { "#", "##", "###", "####", "#####" },
                  { ["\\(\\*\\*\\|__\\)\\(.*\\)\\1"] = "_\\2_" },
                  { ["\\(\\*\\|_\\)\\(.*\\)\\1"] = "__\\2__" },
              },
              ["typescript,javascript"] = {
                  { ["const \\(.\\+\\)\\s\\+=\\s\\+require(\\(.\\+\\))"] = "import \\1 from \\2" },
                  { ["import \\(.\\+\\) from \\(.\\+\\)"] = "const \\1 = require(\\2)" },
              },
          }

          switch_definition = vim.fn["alpaca#initialize#redefine_dict_to_each_filetype"](switch_definition, {})

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
              for filetype, _ in string.gmatch(ft, "([^,]+)") do
                table.insert(filetypes, filetype)
                local filetype_name = table.concat(filetypes, ".")

                if switch_definition[filetype_name] ~= nil then
                  definitions = merge(definitions, switch_definition[filetype_name])
                end
              end
            end

            if vim.fn.exists("b:rails_root") == 0 and switch_definition["rails"] ~= nil then
              definitions = merge(definitions, switch_definition["rails"])
            end

            if switch_definition["_"] ~= nil then
              definitions = merge(definitions, switch_definition["_"])
            end

            return definitions
          end

          local switch_definition_cache = {}

          local function define_switch_mappings()
            if vim.fn.exists("b:switch_custom_definitions") ~= 0 then
              vim.cmd("unlet b:switch_custom_definitions")
            end

            local ft = vim.fn.empty(vim.bo.filetype) == 1 and "*" or vim.bo.filetype

            if switch_definition_cache[ft] == nil then
              switch_definition_cache[ft] = get_switch_mappings()
            end

            vim.b.switch_custom_definitions = switch_definition_cache[ft]
          end

          local group = vim.api.nvim_create_augroup("PackerSwitchVim", { clear = true })
          vim.api.nvim_create_autocmd("Filetype", {
              pattern = "*",
              group = group,
              callback = define_switch_mappings,
          })

          define_switch_mappings()
        end,
    })

    -- file types
    use({
        "cespare/vim-toml",
        ft = { "toml" },
    })

    use({
        "slim-template/vim-slim",
        ft = { "slim" },
    })

    use({
        "mutewinter/nginx.vim",
        ft = { "nginx" },
    })

    use({
        "elixir-lang/vim-elixir",
        ft = { "elixir" },
    })

    use({
        "mattreduce/vim-mix",
        ft = { "elixir" },
    })

    use({
        "vim-scripts/sh.vim",
        ft = "sh",
    })

    use({
        "keith/swift.vim",
        ft = { "swift" },
        rtp = "vim",
    })

    use({
        "hashivim/vim-terraform",
        ft = { "terraform" },
        config = function()
          vim.g.terraform_fmt_on_save = 1
        end,
    })

    use({
        "rust-lang/rust.vim",
        ft = { "rust" },
        config = function()
          vim.g.rustfmt_autosave = 1
        end,
    })

    use({
        "jlcrochet/vim-rbs",
        ft = { "rbs" },
    })

    -- never use
    use({
        "Shougo/vinarise.vim",
        cmd = { "Vinarise" },
        requires = { "s-yukikaze/vinarise-plugin-peanalysis" },
        setup = function()
          vim.g.vinarise_objdump_command = "gobjdump"
        end,
    })

    use({
        "s-yukikaze/vinarise-plugin-peanalysis",
        opt = true,
        run = "brew install binutils",
    })

    use({
        "Shougo/unite.vim",
        cmd = {
            "Unite",
            "UniteBookmarkAdd",
            "UniteClose",
            "UniteResume",
            "UniteWithBufferDir",
            "UniteWithCurrentDir",
            "UniteWithCursorWord",
            "UniteWithInput",
            "UniteWithInputDirectory",
        },
        fn = { "unite#util#path2project_directory", "unite#util#get_vital" },
        wants = {
            "vimfiler",
            "ddu-source-rg",
        },
        setup = function()
          vim.g.unite_winheight = 20
        end,
        config = function()
          local group = vim.api.nvim_create_augroup("PackerUnite", { clear = true })

          vim.api.nvim_create_autocmd("FileType", {
              group = group,
              pattern = "unite",
              callback = function()
                vim.cmd([[highlight link uniteMarkedLine Identifier]])
                vim.cmd([[highlight link uniteCandidateInputKeyword Statement]])

                vim.keymap.set(
                    "n",
                    "f",
                    "<Plug>(unite_toggle_mark_current_candidate)",
                    { silent = true, buffer = true }
                )
                vim.keymap.set(
                    "x",
                    "f",
                    "<Plug>(unite_toggle_mark_selected_candidates)",
                    { silent = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    ",,",
                    "unite#do_action('vimfiler')",
                    { noremap = true, silent = true, expr = true, buffer = true }
                )
                vim.keymap.set(
                    "n",
                    "re",
                    "unite#do_action('replace')",
                    { noremap = true, expr = true, buffer = true }
                )
              end,
          })

          vim.fn["unite#custom#action"]("file", "ddu-rg", {
              is_selectable = 1,
              func = function(candidates)
                local paths = {}

                for _, item in pairs(candidates) do
                  table.insert(paths, item.action__path)
                end

                local input = vim.fn["input"]("Pattern: ")

                vim.fn["ddu#start"]({
                    name = "rg",
                    push = true,
                    sources = {
                        {
                            name = "rg",
                            params = {
                                input = input,
                                paths = paths,
                            },
                        },
                    },
                })
              end,
          })

          if vim.fn.executable("ag") then
            vim.g.unite_source_grep_command = "ag"
            vim.g.unite_source_grep_default_opts = "--nocolor --nogroup"
            vim.g.unite_source_grep_recursive_opt = ""
          elseif vim.fn.executable("rg") then
            vim.g.unite_source_grep_command = "rg"
            vim.g.unite_source_grep_default_opts = "-n --no-heading --color never"
            vim.g.unite_source_grep_recursive_opt = ""
            vim.g.unite_source_grep_max_candidates = 200
          else
            vim.g.unite_source_grep_command = "grep"
            vim.g.unite_source_grep_recursive_opt = "-R"
          end
        end,
    })

    use({
      'chrisbra/csv.vim',
      ft = { "csv" },
    })

    if packer_bootstrap then
      print("Restart Neovim required after installation!")
      require("packer").sync()
    end
  end

  -- [[plugins]]
  -- repo = 'posva/vim-vue'
  -- on_ft = "vue"
  -- hook_source = '''
  --   " autocmd FileType vue syntax sync fromstart
  -- '''
  --
  -- [[plugins]]
  -- repo = 'leafgarland/typescript-vim'
  -- on_ft = ["typescript"]
  --
  -- [[plugins]]
  -- repo = 'yuezk/vim-js'
  -- on_ft = ["javascript", "typescript", "javascript.jsx", "typescript.tsx"]
  --
  -- [[plugins]]
  -- repo = 'MaxMEllon/vim-jsx-pretty'
  -- on_ft = ["javascript", "typescript", "javascript.jsx", "typescript.tsx"]
  -- depends = ["vim-js", "yats.vim"]
  -- hook_source = '''
  --   let g:vim_jsx_pretty_highlight_close_tag = 1
  -- '''
  --
  -- [[plugins]]
  -- repo = 'HerringtonDarkholme/yats.vim'
  -- on_ft = ["javascript", "typescript", "javascript.jsx", "typescript.tsx"]
  --
  -- [[plugins]]
  -- repo = 'peitalin/vim-jsx-typescript'
  -- on_ft = ["typescript"]
  --
  -- [[plugins]]
  -- repo = 'othree/yajs.vim'
  -- on_ft     = ["javascript"]
  --
  -- [[plugins]]
  -- repo = 'othree/javascript-libraries-syntax.vim'
  -- on_ft     = ["javascript"]
  --
  -- [[plugins]]
  -- repo = 'digitaltoad/vim-jade'
  -- on_ft     = ["jade"]
  --
  -- [[plugins]]
  -- repo = 'wavded/vim-stylus'
  -- on_ft     = ["stylus"]
  --
  -- [[plugins]]
  -- repo = 'moll/vim-node'
  -- on_ft     = ["javascript"]
  --
  -- [[plugins]]
  -- repo = 'alpaca-tc/vim-markdown'
  -- on_ft     = ["markdown"]
  --
  -- [[plugins]]
  -- repo = 'mrkn/vim-cruby'
  -- on_ft = ["c"]
  --
  -- [[plugins]]
  -- repo = 'vim-ruby/vim-ruby'
  -- on_ft     = ["ruby", "erb", "ruby.rspec"]
  -- hook_source = '''
  --   let g:ruby_indent_block_style = 'do'
  --   let g:ruby_foldable_groups = 'NONE'
  -- '''

  packer_init()

  local packer = require("packer")
  packer.init({
      display = {
          open_fn = function()
            return require("packer.util").float({ border = "rounded" })
          end,
      },
      subcommands = {
          install = "clone --no-single-branch --progress",
      },
      max_jobs = 5,
      opt_default = true,
      autoremove = true,
  })
  packer.startup(plugins)
end

M.setup()

return M
