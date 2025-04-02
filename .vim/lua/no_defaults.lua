local function unset_defaults()
  local keys = {
    { 'n', 'grn' },
    { { 'n', 'x' }, 'gra' },
    { 'n', 'grr' },
    { 'n', 'gri' },
    { 'n', 'gO' },
    { { 'i', 's' }, '<C-S>' },
  }
  for _, key in ipairs(keys) do
    pcall(vim.keymap.del, key[1], key[2])
  end
end

unset_defaults()
