" vim-awk — filetype-local settings for AWK buffers

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" AWK comments run '#' to end of line.
setlocal commentstring=#\ %s
setlocal comments=:#

" Continue the comment leader on <Enter> / o / O, recognize numbered lists.
setlocal formatoptions-=t
setlocal formatoptions+=croql

" Run the current AWK program through awkrs. `:make` uses the awkrs compiler
" (compiler/awkrs.vim); :AwkRun pipes the buffer through awkrs directly.
" Guard the :compiler call so the file still sources cleanly when the plugin
" dir is not yet on runtimepath (e.g. an isolated `:source` lint).
if !empty(globpath(&runtimepath, 'compiler/awkrs.vim'))
  compiler awkrs
else
  setlocal makeprg=awkrs\ -L\ invalid\ -f\ %
  setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m,%m\ at\ %f\ line\ %l
endif

if !exists(':AwkRun')
  command! -buffer -nargs=* -complete=file AwkRun
        \ echo system('awkrs -f ' . shellescape(expand('%:p')) . ' ' . <q-args>)
endif

" <LocalLeader>r runs the current file via `awkrs -f %`.
if !get(g:, 'vim_awk_no_maps', 0)
  nnoremap <buffer> <silent> <LocalLeader>r :AwkRun<CR>
endif

" Restore on filetype change.
let b:undo_ftplugin = 'setlocal commentstring< comments< formatoptions<'
      \ . '| silent! nunmap <buffer> <LocalLeader>r'
      \ . '| silent! delcommand AwkRun'
