# Neovim configuration

This configuration uses **Neovim 0.12.5**, adopted on 2026-09-10.
Run `nv12` to open it. The repository is a normal checkout of `master` at
`~/.config/nv12`, with its own `.git` directory. Future work can use ordinary
branches in this checkout; language-server changes are the next separate task.

The restored Neovim 0.11 configuration is preserved at tag
`neovim-0.11-baseline` (checkpoint `24b535c`). The old directory `~/.config/nv10`
is retained as an inactive local copy on `legacy/neovim-0.11`. The `nv11` launcher
has been retired. `NVIM_APPNAME=nv12` selects the current configuration and its
own plugin, parser, cache, and state directories.

`bin/nv12` sets `NVIM_APPNAME=nv12` and launches
`~/.local/opt/nvim-0.12.5/bin/nvim`; `~/.local/bin/nv12` links to that script.
The script is tracked in Git; the downloaded Neovim executable and runtime are
installed separately. The shell defaults `NVIM_APPNAME`, `EDITOR`, and `GIT_EDITOR`
select `nv12`. Open a new terminal after changing those defaults.
The binary and runtime came from the official Linux x86-64 archive, verified
against GitHub's published SHA-256. This installation does not need FUSE.
It is a manual installation: future Neovim updates require a new archive and
an updated launcher path.

## Dependencies

- Git, a C compiler and Make, curl, unzip, tar, ripgrep, and fd (`fdfind` on Ubuntu).
- Tree-sitter CLI 0.26.1 or newer. This trial uses the official 0.27.0 binary at
  `~/.local/opt/tree-sitter-0.27.0/bin/tree-sitter`, linked from `~/.local/bin`.
  It is also a manual installation; no Node/npm dependency was added.
- On Wayland, `wl-clipboard` provides the system clipboard. Ordinary yanks use
  it through the existing `clipboard=unnamed,unnamedplus` setting.
- The local plugin `~/projects/landmark.nvim` must be present.
- Lazy installs plugins; `:Lazy restore` restores revisions in `lazy-lock.json`.
  Tree-sitter installs the explicit parser list asynchronously on first launch.
  On a fresh machine, let installation finish before opening those filetypes;
  reopen any file opened before its parser was ready.
  `:TSUpdate` updates installed parsers to match the plugin; `:TSLog` shows errors.
  Telescope's native fzf extension and Markdown preview also have build hooks.
- Language servers and their runtimes are installed separately. The server list
  is in `lua/plugins/lsp.lua`; Java uses `after/ftplugin/java.lua` and `jdtls`.

Keep the terminal's own `TERM` value. `nv11.backup` is the historical wrapper,
preserved as a reference; it is not the current launcher.

## Upgrade changes and later review

- Tree-sitter now uses `main` and its current API. The explicit recovery `commit`
  pin has been removed; its reproducible revision remains in `lazy-lock.json`.
  Keep `lazy = false` and the `:TSUpdate` build hook.
- Highlighting and indentation follow the documented FileType callback pattern.
  Each configured parser uses its known filetypes, including aliases such as
  `sh` for Bash, React filetypes, JSONC, and the three custom Kotlin/SimKit types.
  Markdown and languages without indentation queries keep their fallback.
  The default install directory is used without an explicit `setup()` call.
- The inherited **100 KiB highlighting cutoff has been removed** to simplify
  the setup. Larger files now keep highlighting; revisit a limit if performance
  becomes a problem. The preserved 0.11 baseline retains its original cutoff.
- The same 25 parsers are configured. Terraform now also installs HCL as an
  upstream dependency, giving 26 installed parsers.
- Telescope 0.1.8 crashed in file previews because it used the removed Tree-sitter
  API. It is updated to 0.2.2, using `version = '*'` to follow stable releases
  instead of the old fixed tag. The exact revision remains in `lazy-lock.json`.
  Other plugin revisions are preserved.
- Language-server installation changes are deferred to a separate branch.

Headless checks covered all parser queries, filetype detection, highlighting,
Markdown Lua injections, indentation, large-file behavior, and plugin startup.
The one-time verification scripts and reports are outside this repo under
`~/.local/state/nv10-restoration/upgrade-20260910/`. Basic interactive editing was
also reviewed before adopting this configuration.

Sources: [Neovim 0.12.5](https://github.com/neovim/neovim/releases/tag/v0.12.5),
[Tree-sitter setup](https://github.com/nvim-treesitter/nvim-treesitter/tree/main),
[Telescope 0.2.2](https://github.com/nvim-telescope/telescope.nvim/releases/tag/v0.2.2).

The workstation-wide `RECOVERY.md` journal is kept locally and excluded from Git.
