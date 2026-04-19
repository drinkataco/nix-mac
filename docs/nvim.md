# nvim

<!-- vim-md-toc format=bullets ignore=^TODO$ -->
* [General docs](#general-docs)
* [General usage](#general-usage)
* [Git diffs and conflicts](#git-diffs-and-conflicts)
* [Core plugins](#core-plugins)
  * [Editing](#editing)
  * [Git and workflow](#git-and-workflow)
  * [Statusline](#statusline)
  * [Search and navigation](#search-and-navigation)
  * [Diagnostics](#diagnostics)
* [Editor keymaps](#editor-keymaps)
  * [Core](#core)
  * [Files and tabs](#files-and-tabs)
  * [LSP](#lsp)
  * [Diagnostics](#diagnostics-1)
* [Config files in this setup](#config-files-in-this-setup)
<!-- vim-md-toc END -->

## General docs

- [neovim.io](https://neovim.io/)
- [neovim.io/doc](https://neovim.io/doc/)
- [neovim.io/doc/user/quickref.html](https://neovim.io/doc/user/quickref.html)
- [vimhelp.org](https://vimhelp.org/)

## General usage

- Search commands:
  - `:Commands`
  - or type `:` then press `Tab`
- View help:
  - `:help`
  - `:help <topic>`
  - `:Helptags`
- View keymaps:
  - `:map`
  - `:nmap`
  - `:imap`
  - `:verbose map <lhs>`
  - example: `:verbose map <leader>ff`

## Git diffs and conflicts

- Git is configured to use `nvimdiff` for both `git difftool` and `git mergetool`
- Diff a file from the shell:
  - `git difftool path/to/file`
- Diff all changed files from the shell:
  - `git difftool`
- Resolve merge conflicts from the shell:
  - `git mergetool`
- In `nvimdiff`:
  - 2-way diffs are for normal before/after comparisons
  - 3-way diffs are for merge conflicts, usually `LOCAL`, `BASE`, `REMOTE`, plus the merged result
  - use `]c` / `[c` to move between diff hunks
  - use `<leader>g2` for `:diffget //2`, usually `ours`
  - use `<leader>g3` for `:diffget //3`, usually `theirs`
  - use `<leader>gp` for `:diffput`
  - use `<leader>ga` for `:Git add %` once the file is resolved
- Useful fallback inside Neovim:
  - `:Gvdiffsplit` or `<leader>gd`

## Core plugins

### Editing

- `Comment.nvim`
  - docs: [github.com/numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)
  - Use this as the lightweight replacement for NerdCommenter.
  - Common motions:
    - `gcc` toggles the current line
    - `gbc` toggles the current line with block comments
    - `gc` plus a motion toggles a text object, for example `gcj` or `gc}`
    - in visual mode, `gc` toggles the current selection
- `nvim-cmp`
  - docs: [github.com/hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)
  - Completion is wired through LSP, buffer words, paths, and LuaSnip snippets.
  - LSP-backed completion is configured for Bash, YAML, TypeScript, JavaScript, JSON, Rust, and Python.
  - Common insert-mode keys:
    - `<C-Space>` opens the completion menu
    - `<C-n>` and `<C-p>` move through completion items
    - `<Tab>` and `<S-Tab>` move through completion items or snippet placeholders
    - `<CR>` confirms the selected item
    - `<C-e>` closes the menu
- `LuaSnip`
  - docs: [github.com/L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
  - `friendly-snippets` is loaded for common languages, including TypeScript, JavaScript, JSON, Rust, and Python.
- `CodeCompanion.nvim`
  - docs: [codecompanion.olimorris.dev](https://codecompanion.olimorris.dev/)
  - AI chat, action palette, and inline editing live inside Neovim.
  - Chat uses the Codex ACP adapter via `codex-acp`, with ChatGPT auth and `gpt-5-codex`.
  - Inline prompts and command generation use the OpenAI Responses adapter with `gpt-5-codex`.
  - If ChatGPT auth has expired, run `codex` in a terminal and sign in again.
  - Inline prompts require `OPENAI_API_KEY` in Neovim's environment.
  - Useful commands: `:CodeCompanion`, `:CodeCompanionChat`, `:CodeCompanionCLI`, `:CodeCompanionActions`.
  - Run `:checkhealth codecompanion` if an adapter or credential is not working.
  - Common keys:
    - `<leader>aa` opens CodeCompanion actions
    - `<leader>ac` toggles CodeCompanion chat
    - `<leader>ai` starts an inline prompt, or applies one to a visual selection

### Git and workflow

- `vim-fugitive`
  - docs: [github.com/tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)
  - Example Commands:
    - [`:Git`](https://github.com/tpope/vim-fugitive?tab=readme-ov-file#:Git)
    - [`:Git blame`](https://github.com/tpope/vim-fugitive?tab=readme-ov-file#:Git_blame)
    - [`:Gvdiffsplit`](https://github.com/tpope/vim-fugitive?tab=readme-ov-file#:Gdiffsplit)
    - [`:Git add %`](https://github.com/tpope/vim-fugitive?tab=readme-ov-file#:Git)
  - Custom Keymaps:
    - `<leader>gg`: runs `:Git` and opens Fugitive status
    - `<leader>gs`: runs `:Git` and opens Fugitive status
    - `<leader>gb`: runs `:Git blame` and opens blame for the current buffer
    - `<leader>gd`: runs `:Gvdiffsplit` and opens a vertical Git diff split inside Neovim
    - `<leader>g2`: runs `:diffget //2` and takes the left side during a conflict
    - `<leader>g3`: runs `:diffget //3` and takes the right side during a conflict
    - `<leader>gp`: runs `:diffput` and pushes the current diff changes to the other pane
    - `<leader>ga`: runs `:Git add %` and stages the current file
- `gitsigns.nvim`
  - docs: [github.com/lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
  - Shows added, changed, deleted, and untracked lines in the sign column for tracked files.

### Statusline

- `lualine.nvim`
  - docs: [github.com/nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
  - Layout is based on [github.com/hieulw/nvimrc](https://github.com/hieulw/nvimrc/blob/HEAD/lua/plugins/ui/statusline.lua).
  - Shows mode, filename, LSP status, Git diff, diagnostics, and filetype icon.

### Search and navigation

- `fzf`
  - docs: [github.com/junegunn/fzf](https://github.com/junegunn/fzf)
- `fzf.vim`
  - docs: [github.com/junegunn/fzf.vim](https://github.com/junegunn/fzf.vim)
  - Example Commands:
    - [`:Files`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#files)
    - [`:GitFiles`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#gitfiles)
    - [`:Buffers`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#buffers)
    - [`:BLines`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#lines)
    - [`:History`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#history)
    - [`:Commands`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#commands)
    - [`:Helptags`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#helptags)
    - [`:Ag`](https://github.com/junegunn/fzf.vim?tab=readme-ov-file#ag-rg)
  - Custom Keymaps:
    - `<leader><space>`: prefers `:GitFiles`, falls back to `:Files`, and finds files in the current repo or directory
    - `<leader>ff`: prefers `:GitFiles`, falls back to `:Files`, and finds files in the current repo or directory
    - `<leader>fa`: runs `:Files` and finds all files
    - `<leader>fb`: runs `:Buffers` and searches open buffers
    - `<leader>fh`: runs `:Helptags` and searches Neovim help tags
    - `<leader>fl`: runs `:BLines` and searches lines in the current buffer
    - `<leader>fr`: runs `:History` and searches recent files
    - `<leader>fi`: runs `:Ag` and searches project contents
    - `<leader>/`: runs `:Ag` and searches project contents
    - `<leader>fc`: runs `:Commands` and searches available commands
    - `<leader>gc`: runs `:BCommits` and searches commits for the current buffer

### Diagnostics

- Diagnostic messages open automatically when the cursor rests on an errored span.
  - delay is controlled by `updatetime` in the Neovim options
- `trouble.nvim`
  - docs: [github.com/folke/trouble.nvim](https://github.com/folke/trouble.nvim)
  - Use this for browsing LSP diagnostics without manually creating location or quickfix lists.
  - Example Commands:
    - `:Trouble diagnostics toggle`
    - `:Trouble diagnostics toggle filter.buf=0`
    - `:Trouble diagnostics toggle filter.buf=0 filter.severity=vim.diagnostic.severity.ERROR`
    - `:Trouble qflist toggle`
    - `:Trouble loclist toggle`
  - Custom Keymaps:
    - `<leader>xx`: opens workspace diagnostics
    - `<leader>xb`: opens diagnostics for the current buffer
    - `<leader>xq`: opens the quickfix list in Trouble
    - `<leader>xl`: opens the location list in Trouble

## Editor keymaps

### Core

- `<leader>p`
  - format current buffer

### Files and tabs

- `<leader>e`
  - explore files
- `<leader>ev`
  - explore files in vsplit
- `<leader>eh`
  - explore files in split
- `<leader>et`
  - explore files in new tab
- `<leader>tn`
  - new tab
- `<leader>to`
  - close other tabs
- `<leader>tq`
  - close current tab
- `<leader>th`
  - previous tab
- `<leader>tl`
  - next tab
- `<leader>gx`
  - open lazygit in a new tab
- `<leader>gl`
  - open lazygit in a new tab

### LSP

- `gd`
  - go to definition
- `gr`
  - list references
- `K`
  - hover docs
- `<leader>rn`
  - rename symbol
- `<leader>ca`
  - code action
- `[d`
  - previous diagnostic
- `]d`
  - next diagnostic

### Diagnostics

- `[d`
  - previous diagnostic
- `]d`
  - next diagnostic
- `<leader>xx`
  - workspace diagnostics
- `<leader>xb`
  - current buffer diagnostics
- `<leader>xq`
  - quickfix list
- `<leader>xl`
  - location list

## Config files in this setup

- config directory: [`dotfiles/.config/nvim`](/Users/osh/projects/nix-mac/dotfiles/.config/nvim)
- plugin list: [`dotfiles/.config/nvim/lua/plugins/list.lua`](/Users/osh/projects/nix-mac/dotfiles/.config/nvim/lua/plugins/list.lua)
- plugin config index: [`dotfiles/.config/nvim/lua/plugins/config.lua`](/Users/osh/projects/nix-mac/dotfiles/.config/nvim/lua/plugins/config.lua)
- per-plugin configs: [`dotfiles/.config/nvim/lua/plugins/config/`](/Users/osh/projects/nix-mac/dotfiles/.config/nvim/lua/plugins/config)
  - files in this directory are loaded as `config.<filename>`, for example `lualine.lua` becomes `config.lualine`
