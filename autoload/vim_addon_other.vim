fun! vim_addon_other#Bookmark(...) abort
  let msg = join(a:000," ")
  let pos = getpos('.')
  let bookmark=expand('%').':'.pos[1].' '.msg
  let f = 'bookmarks.txt'
  let lines = filereadable(f) ? readfile(f, 'b') : []
  call writefile([bookmark, getline('.')]+lines, f, 'b')
endf

" set window height/width in 1/10th steps of total height/width
" parameter: 'h' or 'w' ( set height/width)
fun! vim_addon_other#SetWindowSize(orientation)
    let fract = nr2char(getchar())
  if a:orientation == 'h'
    exec fract*&lines/10.'wincmd _'
  else
    exec fract*&columns/10.'wincmd |'
  endif
endf


" jump to nearest line ending with v:count
" thus if you are on line 20234500 and you type 80 you'll jump to 20234480
" credits to ujihisa who had this idea
function! vim_addon_other#SmartGotoLine()
    let c = v:count
    let half = ('1'.repeat('0',len(c))) / 2
    let lnum = line('.')[:-len(c)-1].c
    if  lnum > half + line('.')
      let lnum -= 2* half
    endif
    exec 'normal '.lnum.'G'
endfunction

" TODO: support visual mode!
fun! vim_addon_other#KeepOrDropLines(keep_or_drop)
  let drop = a:keep_or_drop == "drop"
  let where = &buftype == "quickfix" ? "quickfix window" : "buffer"

  let regex = input(a:keep_or_drop.' lines in '. where.' :')

  if where == "quickfix window"
    let list = getqflist()
    call setqflist(filter(getqflist(), '(has_key(v:val,"bufnr") ? bufname(v:val.bufnr)."|" : "").v:val.text '.(drop ? '!~' : '=~').' '.string(regex)))
  else
    exec (drop ? "g" : "v").'/'.regex.'/d'
  endif
endf
