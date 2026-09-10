# Neovim configuration

The restored baseline uses **Neovim 0.11.7** with `NVIM_APPNAME=nv10` and
this checkout at `~/.config/nv10`. Launch with `nv11` on the restored workstation,
or set `NVIM_APPNAME=nv10` when invoking a compatible Neovim executable.

## Dependencies

- Git, a C compiler and Make, curl, unzip, tar, ripgrep, and fd (`fdfind` on Ubuntu).
- On Wayland, `wl-clipboard` provides the system clipboard. Ordinary yanks use
  it through the existing `clipboard=unnamed,unnamedplus` setting.
- The local plugin `~/projects/landmark.nvim` must be present.
- Lazy installs plugins; `:Lazy restore` restores revisions in `lazy-lock.json`.
  Tree-sitter's build step installs the configured parsers. Telescope's native
  fzf extension and Markdown preview also have build hooks.
- Language servers and their runtimes are installed separately. The server list
  is in `lua/plugins/lsp.lua`; Java uses `after/ftplugin/java.lua` and `jdtls`.

Keep the terminal's own `TERM` value. `nv11.backup` is the historical wrapper,
preserved as a reference; it is not the current launcher.

## Temporary Tree-sitter recovery pin

`lua/plugins/treesitter.lua` explicitly pins the legacy `master` API to
`cf12346a3414fa1b06af75c79faebe7f76df080a`. This supports Neovim 0.11 and the
existing `require("nvim-treesitter.configs").setup` call. It prevents updates to
this plugin even when other plugins update.

When upgrading Neovim, migrate to Tree-sitter's supported API on a separate
branch, remove the explicit `commit` field, and regenerate this plugin's lock
entry and parsers. Preserve the 100 KiB highlighting limit, Markdown's existing
indentation, JSONC support, and the three custom Kotlin/SimKit filetypes.
Keep `lazy = false`, as required by Tree-sitter.

Retain this baseline and its Neovim executable until the upgrade has been tested.
Language-server installation changes should follow on a separate branch.

The workstation-wide `RECOVERY.md` journal is kept locally and excluded from Git.

