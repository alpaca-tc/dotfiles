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

function M.to_snake_case(s)
  return s:gsub('%f[^%l]%u','_%1'):gsub('%f[^%a]%d','_%1'):gsub('%f[^%d]%a','_%1'):gsub('(%u)(%u%l)','%1_%2'):lower()
end

return M
