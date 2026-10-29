-- Optional Omarchy integration. On an Omarchy machine, link the system theme
-- into lua/plugins/theme.lua (gitignored) so lazy.nvim picks it up and its
-- change detection drives omarchy-theme-hotreload. Elsewhere this does nothing
-- and LazyVim falls back to its default colorscheme.
local M = {}

M.theme_file = vim.fn.expand("~/.local/state/omarchy/current/theme/neovim.lua")

function M.setup()
  if not vim.uv.fs_stat(M.theme_file) then
    return
  end
  vim.g.omarchy = true

  local link = vim.fn.stdpath("config") .. "/lua/plugins/theme.lua"
  if not vim.uv.fs_lstat(link) then
    vim.uv.fs_symlink(M.theme_file, link)
  end
end

return M
