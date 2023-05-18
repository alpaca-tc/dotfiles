local M = {}

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

return M
