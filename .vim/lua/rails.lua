local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("RailsDetect", { clear = true })

  local function exec_autocmd_rails_if_rails()
    if vim.fn["alpaca#is_rails"](vim.fn.getcwd()) == 1 then
      vim.api.nvim_exec_autocmds("User", { pattern = "Rails" })
    end
  end

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "BufEnter" }, {
    group = group,
    pattern = "*",
    callback = exec_autocmd_rails_if_rails
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = group,
    pattern = "vimfiler",
    callback = function()
      exec_autocmd_rails_if_rails()
    end
  })

  -- Add Rails path
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "Rails",
    callback = function()
      local root = vim.fn["alpaca#current_root"](vim.fn["getcwd"]())

      local path = {
        root .. "/lib",
      }

      -- 文字列を改行で分割する
      for line in vim.fn["glob"](root .. "/app/*"):gmatch("([^\n]*)\n?") do
        table.insert(path, line)
        table.insert(path, line .. "/concerns")
      end

      for _, val in pairs(path) do
        vim.opt_local.path:prepend(val)
      end
    end,
  })

  local function find_file(path)
    local formatted_path = require("string_extend").to_snake_case(vim.fn.substitute(path, 'rt_hr', 'rthr', 'g'))
    local parts = vim.fn.split(formatted_path, '/')

    while #parts > 0 do
      local file = vim.fn.join(parts, '/')
      local rb_file = file .. '.rb'

      if vim.fn.findfile(rb_file) ~= '' then
        return rb_file
      end

      if vim.fn.findfile(file) ~= '' then
        return file
      end

      table.remove(parts)
    end

    return ''
  end

  -- Customize gf
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "Rails",
    callback = function()
      vim.keymap.set('n', 'gf', function()
        local original_file = vim.fn['RubyCursorFile']()
        local file = find_file(original_file)

        if vim.fn.findfile(file) == '' then
          vim.cmd(string.format('echo "E447: Can\'t find file \'%s\' in path"', original_file))
        else
          vim.cmd('find ' .. file)
        end
      end, { buffer = true })
    end
  })
end

return M
