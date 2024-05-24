local M = {}

function M.setup()
  vim.api.nvim_create_user_command(
    'TypeProfRestart',
    function()
      vim.cmd('LspStop')
      vim.cmd('LspStart typeprof')
    end,
    {
      nargs = 0,
    }
  )
end

return M
