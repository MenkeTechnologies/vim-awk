" vim-awk — :compiler awkrs
"
" Wires `:make` to run the current AWK program through the awkrs binary
" in lint mode, so parse / static-check diagnostics land in the quickfix
" list. Flags verified against `awkrs --help` (v0.4.14):
"   -L, --lint <fatal|invalid|no-ext>   static lint level
"   -f, --file <PROGFILE>               read the AWK program from a file

if exists('current_compiler')
  finish
endif
let current_compiler = 'awkrs'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" `awkrs -L invalid -f %` parses + lints the program without consuming input.
CompilerSet makeprg=awkrs\ -L\ invalid\ -f\ %

" awkrs / gawk-style diagnostics: "awkrs: file:line: message" and
" "message at file line n".
CompilerSet errorformat=%f:%l:%c:\ %m
CompilerSet errorformat+=%f:%l:\ %m
CompilerSet errorformat+=%m\ at\ %f\ line\ %l
CompilerSet errorformat+=awkrs:\ %f:%l:\ %m
CompilerSet errorformat+=awkrs:\ %m
