-- Restore the session for the current directory automatically.
return {
  { "folke/persistence.nvim", enabled = false },
  {
    "rmagatti/auto-session",
    lazy = false,
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    },
  },
}
