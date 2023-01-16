local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("RailsDetect", { clear = true })

  vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    group = group,
    pattern = "*",
    callback = function()
      local cwd = vim.fn["expand"]("%:p")

      if vim.fn["alpaca#is_rails"](cwd) == 1 then
        vim.api.nvim_exec_autocmds("User", { pattern = "Rails" })
      end
    end,
  })

  -- Add Rails path
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "Rails",
    callback = function()
      local path = {
        "app/controllers",
        "app/controllers/concerns",
        "app/models",
        "app/models/concerns",
        "app/mailers",
        "app/mailers/concerns",
        "app/serializers",
        "app/repositories",
        "app/validators",
        "app/view_models",
        "app/workers",
        "app/decorators",
        "app/jobs",
        "app/forms",
        "app/policies",
        "lib",
      }

      local root = vim.fn["alpaca#current_root"](vim.fn["getcwd"]())

      for _, val in pairs(path) do
        vim.opt_local.path:prepend(root .. "/" .. val)
      end
    end,
  })

  -- Customize gf
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "Rails",
    callback = function()
      vim.keymap.set('n', 'gf', function()
        local file = vim.fn['RubyCursorFile']()

        if vim.fn.findfile(file) == '' then
          local candidate = vim.fn.substitute(file, 'rt_hr', 'rthr', 'g')

          if vim.fn.findfile(candidate) then
            file = candidate
          end
        end

        if vim.fn.findfile(file) == '' then
          vim.cmd(string.format('echo "E447: Can\'t find file \'%s\' in path"', file))
        else
          vim.cmd('find ' .. file)
        end
      end, { buffer = true })
    end
  })
end

return M
