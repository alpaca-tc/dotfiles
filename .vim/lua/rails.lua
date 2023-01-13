local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("RailsDetect", { clear = true })

  vim.api.nvim_create_autocmd({ "BufNewFile", "BufReadPost" }, {
    group = group,
    pattern = "*",
    callback = function()
      local cwd = vim.fn["expand"]('%:p')

      if vim.fn["alpaca#is_rails"](cwd) == 1 then
        vim.api.nvim_exec_autocmds("User", { pattern = "Rails" })
      end
    end
  })
end

return M
