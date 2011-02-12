call actions#AddAction('run php background', {'action': funcref#Function('vim_addon_other_php#RunPHPRHS', {'args': [1]})})
call actions#AddAction('run python background', {'action': funcref#Function('vim_addon_other_python#RunPythonRHS', {'args': [1]})})
call actions#AddAction('run python using make', {'action': funcref#Function('vim_addon_other_python#RunPythonRHS', {'args': [0]})})

" m-X key jump to tab X
for i in range(1,8)
  exec 'map <m-'.i.'> '.i.'gt'
endfor

" faster novigation in windows:
for i in ["i","j","k","l","q"]
  exec 'noremap <m-s-'.i.'> <c-w>'.i
endfor

augroup CREATE_MISSING_DIR_ON_BUF_WRITE
  autocmd BufWritePre * if !isdirectory(expand('%:h')) | call mkdir(expand('%:h'),'p') | endif
augroup end

command! -nargs=* Bookmark call vim_addon_other#Bookmark(<f-args>)

" fast resizing of windows:
noremap <m-w> :call vim_addon_other#SetWindowSize("h")<cr>
" m-s-w could make trouble ..
noremap <m-s-w> :call vim_addon_other#SetWindowSize("w")<cr>


" allow <m-x/X> mappings to work in vim (remap <esc-x> to <m-x>)
" Maybe there is a smarter way of doing this. It works fine for me.
" omitting o,O,w,W,e,E,j,k,h,l,c,C,v,V because they are used often after <esc>
" This would be too annoying. I ue m-t otherwise so I keep t,T
for i in split("abdgimnpqrstuxyzABDGHIJKLMNPQRSTUXYZ0123456789",'.\zs')
  exec 'map <esc>'.i.' <m-'.i.'>'
endfor


nnoremap \G :<C-U>call vim_addon_other#SmartGotoLine()<CR>

noremap <m-k><m-l> :call vim_addon_other#KeepOrDropLines("keep")<cr>
noremap <m-d><m-l> :call vim_addon_other#KeepOrDropLines("drop")<cr>


" grep
" memo: -g -r = grep -r
noremap <m-g><m-r> :call vim_addon_other#GrepR()<cr>

noremap <m-m><m-i><m-d> :call vim_addon_other#GnuIdutils_Mkid()<cr>
noremap <m-l><m-i><m-d> :call vim_addon_other#GnuIdutils_Lid()<cr>

" gnu id utils
