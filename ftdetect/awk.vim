" vim-awk — filetype detection for AWK source
" Loaded automatically by pathogen / vim-plug / native packages via ftdetect/.

" By extension: every *.awk file is awk.
autocmd BufNewFile,BufRead *.awk setfiletype awk

" By shebang: files run as `#!/usr/bin/env awkrs` (or a direct awkrs / awk path)
" with no .awk extension still light up. Honor the awkrs shebang for
" extensionless scripts too.
autocmd BufNewFile,BufRead * call s:DetectAwkShebang()

function! s:DetectAwkShebang() abort
  if did_filetype() || &filetype ==# 'awk'
    return
  endif
  let l:first = getline(1)
  if l:first =~# '^#!.*\<\%(awkrs\|awk\|gawk\|mawk\|nawk\)\>'
    setfiletype awk
  endif
endfunction
