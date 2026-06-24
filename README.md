```
██╗   ██╗██╗███╗   ███╗      █████╗ ██╗    ██╗██╗  ██╗
██║   ██║██║████╗ ████║     ██╔══██╗██║    ██║██║ ██╔╝
██║   ██║██║██╔████╔██║     ███████║██║ █╗ ██║█████╔╝
╚██╗ ██╔╝██║██║╚██╔╝██║     ██╔══██║██║███╗██║██╔═██╗
 ╚████╔╝ ██║██║ ╚═╝ ██║     ██║  ██║╚███╔███╔╝██║  ██╗
  ╚═══╝  ╚═╝╚═╝     ╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝
```

[![CI](https://github.com/MenkeTechnologies/vim-awk/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/vim-awk/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-online-05d9e8.svg)](https://menketechnologies.github.io/vim-awk/)
[![Syntax](https://img.shields.io/badge/syntax-standalone%20AWK-ff2a6d.svg)](https://menketechnologies.github.io/vim-awk/)
[![LSP](https://img.shields.io/badge/LSP%20%2F%20DAP-awkrs-39ff14.svg)](https://github.com/MenkeTechnologies/vim-awk)
[![License: MIT](https://img.shields.io/badge/License-MIT-d300c5.svg)](https://opensource.org/licenses/MIT)

### `[VIM PLUGIN // NEON SYNTAX // STANDALONE AWK GRAMMAR // ALE + LSP + DAP]`

> *"Load it with pathogen. Open a `.awk`. It lights up."*

Vim / Neovim support for **AWK**, targeting **awkrs** — a pattern / action engine written in Rust with a POSIX / gawk / mawk-style union CLI. Standalone syntax highlighting, filetype detection, brace-aware indentation, `:make` / `:AwkRun` wiring, ALE linting, and vim-lsp / coc.nvim / nvim-dap integration. Zero configuration.

```bash
cd ~/.vim/bundle && git clone https://github.com/MenkeTechnologies/vim-awk   # pathogen
```

### [`Read the Docs`](https://menketechnologies.github.io/vim-awk/) &middot; [`Engineering Report`](https://menketechnologies.github.io/vim-awk/report.html)

---

## [0x00] OVERVIEW

**vim-awk** is Vim / Neovim support for **AWK** — targeting **awkrs**, a pattern / action engine written in Rust with a POSIX / gawk / mawk-style union CLI. It ships as a standard Vim runtime tree, so **pathogen / vim-plug / native packages** add it to `runtimepath` with zero special handling and zero configuration.

The syntax file is a **standalone AWK grammar** covering the POSIX awk core plus the gawk / mawk extensions awkrs accepts. AWK's surface is small and fixed, so the keyword / built-in lists are hand-curated rather than generated; `scripts/gen_syntax.sh` stamps the file with the awkrs version it was verified against.

- **patterns** — `BEGIN` `END` `BEGINFILE` `ENDFILE`, `/regex/`, expression patterns
- **built-in variables** — `NR` `NF` `FS` `OFS` `ORS` `RS` `FILENAME` `FNR` `RSTART` `RLENGTH` `SUBSEP` `ARGC` `ARGV` `ENVIRON` `CONVFMT` `OFMT` (+ gawk `FPAT`, `IGNORECASE`, `RT`, …)
- **built-in functions** — `length` `substr` `index` `split` `sub` `gsub` `match` `sprintf` `sin` `cos` `atan2` `exp` `log` `sqrt` `int` `rand` `srand` `tolower` `toupper` `system` `close` `fflush` (+ gawk `gensub`, `strftime`, `systime`, bit ops, …)

> The `awkrs` binary must be on `$PATH` for running, linting and LSP.

---

## [0x01] FEATURE MATRIX

| Capability | Status |
|---|---|
| Filetype detection — `*.awk` | **Implemented** — every `*.awk` buffer becomes `filetype=awk` |
| Filetype detection — shebang | **Implemented** — extensionless scripts with `#!/usr/bin/env awkrs` (or awk / gawk / mawk) are detected |
| Syntax highlighting | **Implemented** — standalone AWK grammar (patterns, control flow, statements, built-in variables, built-in functions, field references, regex literals, strings, operators) |
| Indentation | **Implemented** — standalone brace-aware indenter |
| Comments | **Implemented** — `commentstring=# %s`, comment-continuation `formatoptions` |
| Run / make | **Implemented** — `:compiler awkrs` (`:make` → quickfix) and `:AwkRun` (`<LocalLeader>r`) |
| Linting | **Implemented** — ALE linter running `awkrs -L invalid` |
| Language server (vim-lsp) | **Implemented** — `awkrs --lsp`, allowlisted for `awk` |
| Language server (coc.nvim) | **Implemented** — ready-to-paste `languageserver` config |
| Debug adapter (nvim-dap) | **Implemented** — ready-to-paste `awkrs --dap` adapter config |
| Help | **Implemented** — `:help vim-awk` |
| Config required | **None** — opt-outs to disable ALE, LSP, or the run mapping |

---

## [0x02] INSTALL

**pathogen**

```bash
cd ~/.vim/bundle
git clone https://github.com/MenkeTechnologies/vim-awk
# then inside vim:  :Helptags
```

**vim-plug** (add to `~/.vimrc` / `init.vim`)

```vim
Plug 'MenkeTechnologies/vim-awk'
```

**native packages** (Vim 8+ / Neovim)

```bash
git clone https://github.com/MenkeTechnologies/vim-awk \
    ~/.vim/pack/plugins/start/vim-awk
```

Open any `.awk` file and it lights up — no further configuration. See `:help vim-awk`.

---

## [0x03] SYNTAX // TOKEN CATEGORIES

The grammar classifies tokens into the categories the AWK language defines — POSIX awk plus the gawk / mawk extensions awkrs accepts:

| Category | Tokens (sample) | Highlight |
|---|---|---|
| Patterns | `BEGIN` `END` `BEGINFILE` `ENDFILE` · `/regex/` · expression patterns | `PreProc` |
| Control flow | `if` `else` `while` `for` `do` `break` `continue` `next` `nextfile` `exit` `return` `delete` `in` | `Statement` |
| Statements | `print` `printf` `getline` | `Statement` |
| Function definition | `function` `func` | `Keyword` |
| Built-in variables | `NR` `NF` `FS` `OFS` `ORS` `RS` `FILENAME` `FNR` `RSTART` `RLENGTH` `SUBSEP` `ARGC` `ARGV` `ENVIRON` `CONVFMT` `OFMT` | `Special` |
| String functions | `length` `substr` `index` `split` `sub` `gsub` `match` `sprintf` `tolower` `toupper` | `Function` |
| Arithmetic functions | `sin` `cos` `atan2` `exp` `log` `sqrt` `int` `rand` `srand` | `Function` |
| I/O functions | `system` `close` `fflush` | `Function` |
| Field references | `$0` `$1` `$NF` `$(expr)` | `Identifier` |

ERE regex literals (`/.../`), double-quoted strings with escapes, the `~` / `!~` match operators, `#` comments, numbers, and the full operator set are all handled. Everything links to standard highlight groups, so every colorscheme covers it.

---

## [0x04] RUN // LINT

`:compiler awkrs` wires `:make` to run the current program through awkrs in lint mode and route diagnostics to the quickfix list:

```bash
awkrs -L invalid -f %
```

To execute the current buffer as an AWK program: `:AwkRun [files...]` (mapped to `<LocalLeader>r`).

When **[ALE](https://github.com/dense-analysis/ale)** is installed, vim-awk registers a linter that runs the same `awkrs -L invalid -f %t` inline. Diagnostics of the form `<file>:<line>: <message>` are surfaced. Skipped silently if ALE is absent or `g:vim_awk_no_ale` is set.

---

## [0x05] LANGUAGE SERVER

### vim-lsp

Registered automatically as `awkrs --lsp`, allowlisted for the `awk` filetype — no extra config when **[vim-lsp](https://github.com/prabirshrestha/vim-lsp)** is installed. awkrs must be invoked with **only** `--lsp` — it rejects an appended `--stdio`, so do not add transport args.

### coc.nvim

Add to `coc-settings.json`:

```json
{
  "languageserver": {
    "awkrs": {
      "command": "awkrs",
      "args": ["--lsp"],
      "filetypes": ["awk"]
    }
  }
}
```

---

## [0x06] DEBUG ADAPTER

awkrs exposes a Debug Adapter via `awkrs --dap` (DAP on stdio). For **[nvim-dap](https://github.com/mfussenegger/nvim-dap)**, add to your Neovim config:

```lua
local dap = require('dap')
dap.adapters.awkrs = {
  type = 'executable',
  command = 'awkrs',
  args = { '--dap' },   -- no extra transport args; awkrs rejects them
}
dap.configurations.awk = {
  { type = 'awkrs', request = 'launch', name = 'Run AWK program',
    program = '${file}' },
}
```

---

## [0x07] OPTIONS

Set before the plugin loads (e.g. in your `vimrc`):

| Variable | Effect |
|---|---|
| `let g:vim_awk_no_ale = 1` | Skip ALE linter registration |
| `let g:vim_awk_no_lsp = 1` | Skip vim-lsp server registration |
| `let g:vim_awk_no_maps = 1` | Skip the `<LocalLeader>r` run mapping |

---

## [0x08] LAYOUT

```
vim-awk/
├── ftdetect/awk.vim     # *.awk + awk / awkrs shebang -> filetype=awk
├── syntax/awk.vim       # standalone AWK grammar (POSIX + gawk / mawk)
├── scripts/gen_syntax.sh # stamps syntax/awk.vim with the awkrs version
├── ftplugin/awk.vim     # commentstring '# %s', :compiler awkrs, :AwkRun
├── compiler/awkrs.vim   # :make via awkrs -L invalid -> quickfix
├── indent/awk.vim       # standalone brace-aware indenter
├── plugin/awk.vim       # ALE linter + vim-lsp + coc + nvim-dap wiring
└── doc/awk.txt          # :help vim-awk
```

Standard Vim runtime layout — pathogen / vim-plug / native packages add it to `runtimepath` with no special handling.

---

## [0x09] LICENSE

MIT © **[MenkeTechnologies](https://github.com/MenkeTechnologies)**
