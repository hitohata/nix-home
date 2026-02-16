# Neovim Manual

## Table of Contents
- [File Navigation](#file-navigation)
- [Buffer Management](#buffer-management)
- [Window Management](#window-management)
- [Code Outline (Aerial)](#code-outline-aerial)
- [LSP (Language Server)](#lsp-language-server)
- [Code Completion](#code-completion)
- [GitHub Copilot](#github-copilot)
- [Git Integration](#git-integration)
- [Terminal](#terminal)
- [File Explorer](#file-explorer)
- [Search and Navigation](#search-and-navigation)
- [Editing](#editing)
- [Copy Path](#copy-path)
- [Markdown](#markdown)
- [Notifications and Messages](#notifications-and-messages)
- [Spell Checking](#spell-checking)
- [Commands](#commands)
- [Key Notation Reference](#key-notation-reference)

---

## File Navigation

| Keybinding | Description |
|------------|-------------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fg` | Live grep (search in files) |

## Buffer Management

| Keybinding | Description |
|------------|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bp` | Pick buffer (interactive selection) |
| `<leader>fb` | List all buffers (Telescope) |

## Window Management

### Navigation
| Keybinding | Description |
|------------|-------------|
| `<C-h>` | Go to left window |
| `<C-j>` | Go to lower window |
| `<C-k>` | Go to upper window |
| `<C-l>` | Go to right window |

### Resizing
| Keybinding | Description |
|------------|-------------|
| `<C-Up>` | Increase window height |
| `<C-Down>` | Decrease window height |
| `<C-Left>` | Decrease window width |
| `<C-Right>` | Increase window width |

## Code Outline (Aerial)

Aerial provides a code outline window for skimming and quick navigation through symbols (functions, classes, variables, etc.).

| Keybinding | Description |
|------------|-------------|
| `<leader>a` | Toggle Aerial (code outline) |
| `{` | Jump to previous symbol |
| `}` | Jump to next symbol |

### Inside Aerial Window
| Keybinding | Description |
|------------|-------------|
| `<CR>` | Jump to symbol |
| `p` | Scroll to symbol (preview) |
| `<C-v>` | Jump to symbol in vsplit |
| `<C-s>` | Jump to symbol in split |
| `q` | Close Aerial |
| `o` / `za` | Toggle tree node |
| `l` / `zo` | Open tree node |
| `h` / `zc` | Close tree node |

## LSP (Language Server)

| Keybinding | Description |
|------------|-------------|
| `gD` | Go to declaration |
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | Show references |
| `K` | Hover documentation |
| `<C-i>` | Signature help |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format code |
| `<leader>fd` | Show diagnostics (Telescope) |

## Code Completion

### nvim-cmp
| Keybinding | Description |
|------------|-------------|
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` | Next item / Expand snippet |
| `<S-Tab>` | Previous item / Jump back in snippet |
| `<C-b>` | Scroll docs up |
| `<C-f>` | Scroll docs down |
| `<C-e>` | Abort completion |

## GitHub Copilot

| Keybinding | Description |
|------------|-------------|
| `<M-l>` | Accept suggestion |
| `<M-k>` | Accept word |
| `<M-j>` | Accept line |
| `<M-]>` | Next suggestion |
| `<M-[>` | Previous suggestion |
| `<C-]>` | Dismiss suggestion |
| `<M-CR>` | Open Copilot panel |

## Git Integration

| Keybinding | Description |
|------------|-------------|
| `<leader>gg` | Open LazyGit |
| `<leader>gb` | Git blame line |
| `<leader>gp` | Preview hunk |
| `<leader>gr` | Reset hunk |
| `]h` | Next hunk |
| `[h` | Previous hunk |

## Terminal

| Keybinding | Description |
|------------|-------------|
| `<C-\>` | Toggle terminal |
| `<leader>tf` | Float terminal |
| `<leader>th` | Horizontal terminal |
| `<leader>tv` | Vertical terminal |
| `<Esc>` (in terminal) | Exit terminal mode |
| `<C-h/j/k/l>` (in terminal) | Navigate to window |

## File Explorer

| Keybinding | Description |
|------------|-------------|
| `<leader>e` | Toggle file explorer (NvimTree) |

## Search and Navigation

| Keybinding | Description |
|------------|-------------|
| `<Esc>` | Clear search highlight |

## Editing

### Insert Mode
| Keybinding | Description |
|------------|-------------|
| `jk` | Exit insert mode |
| `jj` | Exit insert mode |

### Visual Mode
| Keybinding | Description |
|------------|-------------|
| `J` | Move selected line(s) down |
| `K` | Move selected line(s) up |

## Copy Path

| Keybinding | Description |
|------------|-------------|
| `<leader>cp` | Copy absolute path to clipboard |
| `<leader>cr` | Copy relative path to clipboard |
| `<leader>cf` | Copy filename to clipboard |

## Markdown

| Keybinding | Description |
|------------|-------------|
| `<leader>mr` | Toggle markdown render (render-markdown.nvim) |
| `<leader>z` | Toggle zen mode (distraction-free writing) |
| `<leader>mp` | Open markdown preview in browser |
| `<leader>ms` | Stop markdown preview |

## Notifications and Messages

| Keybinding | Description |
|------------|-------------|
| `<leader>nm` | Show messages |
| `<leader>nh` | Noice history |
| `<leader>nl` | Noice last message |
| `<leader>nn` | Show notifications |
| `<leader>nc` | Copy messages to clipboard |
| `<leader>ny` | Copy last message to clipboard |
| `<leader>nb` | Noice history (buffer for yanking) |

## Spell Checking

Neovim has built-in spell checking enabled for US English. Additionally, CSpell LSP provides advanced spell checking for code and markdown files.

| Command | Description |
|---------|-------------|
| `z=` | Show spelling suggestions for word under cursor |
| `]s` | Next misspelled word |
| `[s` | Previous misspelled word |
| `zg` | Add word to dictionary |
| `zw` | Mark word as incorrect |

## Commands

Neovim commands are executed in normal mode by typing `:` followed by the command name and pressing Enter.

### Custom Commands

| Command | Description |
|---------|-------------|
| `:LazyGit` | Open LazyGit in a terminal window |
| `:RenderMarkdown toggle` | Toggle markdown rendering on/off |
| `:ZenMode` | Toggle zen mode for focused writing |
| `:MarkdownPreview` | Open markdown preview in browser |
| `:MarkdownPreviewStop` | Stop markdown preview server |
| `:Telescope find_files` | Find files using Telescope |
| `:Telescope live_grep` | Search text in files |
| `:NvimTreeToggle` | Toggle file explorer |
| `:ToggleTerm` | Toggle terminal window |
| `:AerialToggle` | Toggle code outline |
| `:AerialInfo` | Show Aerial debug info |

### Built-in Commands

| Command | Description |
|---------|-------------|
| `:w` | Save (write) current file |
| `:q` | Quit current window |
| `:wq` or `:x` | Save and quit |
| `:q!` | Quit without saving |
| `:e <file>` | Edit/open a file |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Delete/close buffer |
| `:split` or `:sp` | Split window horizontally |
| `:vsplit` or `:vsp` | Split window vertically |
| `:help <topic>` | Open help for a topic |

---

## Key Notation Reference

Understanding Vim/Neovim key notation can be confusing at first. Here's a guide to the special keys and modifiers used in this manual:

### Leader Key
- `<leader>` - This is set to the **Space bar** in our configuration
  - Example: `<leader>ff` means press **Space** then **f** then **f**

### Modifier Keys
- `<C-x>` - **Ctrl** + x (hold Ctrl and press x)
- `<S-x>` - **Shift** + x (hold Shift and press x)
- `<M-x>` or `<A-x>` - **Alt/Meta** + x (hold Alt and press x)

### Special Keys
- `<CR>` - **Enter/Return** key
- `<Esc>` - **Escape** key
- `<Tab>` - **Tab** key
- `<Space>` - **Space bar**
- `<BS>` - **Backspace**
- `<Up>`, `<Down>`, `<Left>`, `<Right>` - **Arrow keys**

### Mode Prefixes (not shown in keybindings above)
- `n` - Normal mode
- `i` - Insert mode
- `v` - Visual mode
- `t` - Terminal mode

### Examples
- `<leader>ff` = **Space** + **f** + **f**
- `<C-k>` = **Ctrl** + **k**
- `<S-h>` = **Shift** + **h**
- `<M-l>` = **Alt** + **l**
- `<C-\>` = **Ctrl** + **\** (backslash)

### Case Sensitivity
- Lowercase letters (like `h`, `j`, `k`, `l`) are just those keys
- Uppercase letters (like `K`, `J`) mean **Shift** + that letter
- When you see `<S-h>`, it explicitly shows the Shift modifier (same as pressing **H**)

### Reading Sequences
- Single keys in succession: `gg` means press **g** twice quickly
- With leader: `<leader>ff` means press **Space**, then **f**, then **f** in sequence
- With modifiers: `<C-w>h` means hold **Ctrl** + **w**, then release and press **h**
