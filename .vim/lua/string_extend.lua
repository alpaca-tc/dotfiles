local M = {}

function M.start_with(str, start)
  return string.sub(str, 1, string.len(start)) == start
end

function M.end_with(str, ending)
  return ending == "" or string.sub(str, -#ending) == ending
end

function M.contains(str, sub)
  return string.find(str, sub, 1, true) ~= nil
end

return M
