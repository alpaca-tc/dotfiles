local M = {}

function M.insert_multi(t, ...)
  local args = {...}
  local initial_size = #t

  for i = 1, #args do
    t[initial_size + i] = args[i]
  end

  return t
end

return M
