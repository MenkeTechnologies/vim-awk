" vim-awk — indentation for AWK buffers
"
" A standalone brace-aware indenter for AWK's block grammar. Increases
" indent after a line that opens a block / paren / bracket, and dedents a line
" that begins with a closing delimiter.

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal nolisp
setlocal nosmartindent
setlocal indentexpr=GetAwkIndent()
setlocal indentkeys=0{,0},0),0],!^F,o,O,e

let b:undo_indent = 'setlocal autoindent< lisp< smartindent< indentexpr< indentkeys<'

" Only define the function once.
if exists('*GetAwkIndent')
  finish
endif

function! GetAwkIndent() abort
  let l:prevlnum = prevnonblank(v:lnum - 1)
  if l:prevlnum == 0
    return 0
  endif

  let l:prevline = getline(l:prevlnum)
  let l:curline = getline(v:lnum)
  let l:ind = indent(l:prevlnum)
  let l:sw = shiftwidth()

  " Indent one level deeper after a line that ends by opening a block,
  " paren, or bracket (ignoring a trailing comment).
  if l:prevline =~# '[{[(]\s*\%(#.*\)\?$'
    let l:ind += l:sw
  endif

  " Dedent a line that starts with a closing delimiter.
  if l:curline =~# '^\s*[)}\]]'
    let l:ind -= l:sw
  endif

  return l:ind < 0 ? 0 : l:ind
endfunction
