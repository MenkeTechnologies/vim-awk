" vim-awk — language-server / linter wiring for AWK (awkrs)
"
" awkrs CLI flags used here:
"   -L, --lint <fatal|invalid|no-ext>   static lint (parse + check, no run)
"   -f, --file <PROGFILE>               read the AWK program from a file
"   --lsp                               Language Server (JSON-RPC on stdio)
"   --dap                               Debug Adapter (DAP on stdio)
"
" LSP / DAP: the wiring below registers `awkrs --lsp` (Language Server,
" JSON-RPC on stdio) and documents `awkrs --dap` (Debug Adapter, DAP on stdio).
" Each MUST be invoked with ONLY that flag (no appended `--stdio`), mirroring
" `stryke --lsp`; vim-lsp / nvim-dap clients must NOT add transport args. The
" wiring is guarded so the plugin still loads and lints cleanly if the binary
" is absent.
"
" Opt-outs:
"   let g:vim_awk_no_ale = 1   " skip ALE linter registration
"   let g:vim_awk_no_lsp = 1   " skip vim-lsp server registration

if exists('g:loaded_vim_awk')
  finish
endif
let g:loaded_vim_awk = 1

" ---------------------------------------------------------------------------
" ALE linter
" ---------------------------------------------------------------------------
function! AwkProjectRoot(buffer) abort
  let l:git = ale#path#FindNearestDirectory(a:buffer, '.git')
  return !empty(l:git) ? fnamemodify(l:git, ':h:h') : expand('#' . a:buffer . ':p:h')
endfunction

function! AwkHandler(buffer, lines) abort
  let l:output = []
  for l:line in a:lines
    " awkrs / gawk-style: "awkrs: <file>:<line>: <message>" or
    " "<file>:<line>: <message>"
    let l:match = matchlist(l:line, '\v^%(awkrs:\s*)?.{-}:(\d+):\s*(.+)$')
    if !empty(l:match)
      call add(l:output, {'lnum': l:match[1] + 0, 'text': l:match[2], 'type': 'E'})
      continue
    endif
    " fallback: "<message> at <file> line <n>"
    let l:match = matchlist(l:line, '\v^(.+) at .+ line (\d+)')
    if !empty(l:match)
      call add(l:output, {'lnum': l:match[2] + 0, 'text': l:match[1], 'type': 'E'})
    endif
  endfor
  return l:output
endfunction

function! s:RegisterAwkALE() abort
  if get(g:, 'vim_awk_no_ale', 0)
    return
  endif
  if exists('*ale#linter#Define')
    call ale#linter#Define('awk', {
    \   'name': 'awkrs',
    \   'executable': 'awkrs',
    \   'command': 'awkrs -L invalid -f %t 2>&1',
    \   'callback': 'AwkHandler',
    \   'project_root': function('AwkProjectRoot'),
    \})
    let g:ale_linters = get(g:, 'ale_linters', {})
    let g:ale_linters.awk = ['awkrs']
  endif
endfunction

augroup vim_awk_ale
  autocmd!
  autocmd VimEnter * call s:RegisterAwkALE()
augroup END

" ---------------------------------------------------------------------------
" vim-lsp
" ---------------------------------------------------------------------------
if !get(g:, 'vim_awk_no_lsp', 0) && exists('*lsp#register_server')
  call lsp#register_server({
  \   'name': 'awkrs',
  \   'cmd': ['awkrs', '--lsp'],
  \   'allowlist': ['awk'],
  \})
endif

" ---------------------------------------------------------------------------
" coc.nvim — add to coc-settings.json:
"   {
"     "languageserver": {
"       "awkrs": {
"         "command": "awkrs",
"         "args": ["--lsp"],
"         "filetypes": ["awk"]
"       }
"     }
"   }
" ---------------------------------------------------------------------------

" ---------------------------------------------------------------------------
" nvim-dap — add to your Neovim config (debug adapter via `awkrs --dap`):
"   local dap = require('dap')
"   dap.adapters.awkrs = {
"     type = 'executable',
"     command = 'awkrs',
"     args = { '--dap' },   -- no extra transport args; awkrs rejects them
"   }
"   dap.configurations.awk = {
"     { type = 'awkrs', request = 'launch', name = 'Run AWK program',
"       program = '${file}' },
"   }
" ---------------------------------------------------------------------------
