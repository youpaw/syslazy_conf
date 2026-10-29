# syslazy_conf

A Neovim config built on [LazyVim](https://lazyvim.org). It starts from [Omarchy](https://omarchy.org)'s
config and adds C/C++ tooling. It runs on any machine. When Omarchy is installed, it follows the system theme
and hot-reloads it.

## Install

```sh
mv ~/.config/nvim ~/.config/nvim.bak   # back up any existing config
git clone https://github.com/youpaw/syslazy_conf ~/.config/nvim
nvim                                   # first start installs the plugins
```

To try it next to an existing config:

```sh
git clone https://github.com/youpaw/syslazy_conf ~/.config/syslazy
NVIM_APPNAME=syslazy nvim
```

Requirements: Neovim >= 0.11, git, a C compiler (for treesitter), ripgrep, fd. To debug C/C++ through
gdbserver you also need gdb. Mason installs clangd, clang-format and cpptools on first use.

## What's in it

On top of LazyVim and Omarchy's defaults:

- **C/C++**: the `lang.clangd` extra, with clangd flags in `lua/plugins/clangd.lua`. Code is formatted with
  clang-format through conform (`<leader>cf`). Format on save is off.
- **Debugging**: the `dap.core` extra (`<leader>d…`). It adds `cppdbg` launch and
  `gdbserver localhost:5678` attach configurations, and the codelldb ones remain
  (`lua/plugins/dap.lua`).
- **Sessions**: auto-session restores sessions per directory and replaces persistence.nvim.
- **Editing**: mini.surround (`gsa` / `gsd` / `gsr`). Indentation is 8-wide hard tabs.
- **File tree**: `<Tab>` in neo-tree opens a file as a preview and keeps the cursor in the tree. The next
  `<Tab>` replaces it, unless you've edited it or opened it with `<CR>`/`l`.

## Omarchy integration

`lua/config/omarchy.lua` looks for `~/.local/state/omarchy/current/theme/neovim.lua`. If that file is there,
it symlinks it to `lua/plugins/theme.lua` (gitignored) and turns on `omarchy-theme-hotreload`. Without
Omarchy, the colorscheme is tokyonight.

## Layout

```
lua/config/   options, keymaps, autocmds, lazy bootstrap, omarchy detection
lua/plugins/  one spec file per concern; files from Omarchy are kept as they were
lazyvim.json  enabled LazyVim extras (manage them with :LazyExtras)
```
