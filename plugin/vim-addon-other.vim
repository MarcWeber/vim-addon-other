" m-X key jump to tab X
for i in range(1,8)
  exec 'map <m-'.i.'> '.i.'gt'
endfor

" faster novigation in windows:
for i in ["i","j","k","l","q","h"]
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


nnoremap \G :<C-U>call vim_addon_other#SmartGotoLine(0)<CR>
onoremap \G :<C-u>call vim_addon_other#SmartGotoLine(1)<CR>
vnoremap \G :<C-u>call vim_addon_other#SmartGotoLine(1)<CR>

" yank a document
" onoremap D :<C-U>normal! ggVG

noremap \kl :call vim_addon_other#KeepOrDropLines("keep")<cr>
noremap \dl :call vim_addon_other#KeepOrDropLines("drop")<cr>


" grep
" memo: -g -r = grep -r
noremap \gr :call vim_addon_other#GrepR()<cr>

noremap \mid :call vim_addon_other#GnuIdutils_Mkid()<cr>
noremap \lid :call vim_addon_other#GnuIdutils_Lid()<cr>

" gnu id utils

command! -nargs=1 -complete=file RenameFile call vim_addon_other#RenameFile(<f-args>)<cr>
command! -nargs=1 -complete=file ContinueWorkOnCopy call vim_addon_other#ContinueWorkOnCopy(<f-args>)<cr>

noremap \cp :RenameFile<space><c-r>=expand("%")<cr><c-r>=substitute(setcmdpos(getcmdpos()-strlen(expand("%:t"))),".","","g")<cr>
noremap \mv :ContinueWorkOnCopy<space><c-r>=expand("%")<cr><c-r>=substitute(setcmdpos(getcmdpos()-strlen(expand("%:t"))),".","","g")<cr>

" insert filename or path into commandline
cmap >fn <c-r>=expand('%:p')<cr>
cmap >fd <c-r>=expand('%:p:h').'/'<cr>
vnoremap * :<C-u>call vim_addon_other#VSetSearch()<CR>/<CR>
vnoremap # :<C-u>call vim_addon_other#VSetSearch()<CR>?<CR>

augroup GOTO_MARKER
  autocmd BufRead *  call search('<<<<<<')
augroup end

" sometimes :tjump shows to many hits. Use this to narrow down by typing
" characters using tlib's List function:
command!-nargs=1 TJump call vim_addon_other#SelectTag(<f-args>)

command! -nargs=1 RubyLibGrep exec 'grep -ri '.shellescape(<f-args>).' '.join(map(split($RUBYLIB,':'), 'shellescape(v:val)." "')," ")

augroup GOTO_LINE
  autocmd BufNewFile *:* call vim_addon_other#GotoFileLine()
augroup end

" delete, yank a document
noremap dad ggGVd
noremap yad ggVGy
