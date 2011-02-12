" scriptmanager#DefineAndBind('s:config','g:config',{})
if !exists('g:config') | let g:config = {} | endif | let s:config = g:config

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

fun! vim_addon_other#GrepR()
  let cmd = funcref#Call( get(s:config,'grepprg', funcref#Function('return ["grep", "-r","-n", input("grep -r for :") , "."]') ) )
  let errorFormat = get(s:config,'grepprg_ef', '%f:%l:%m')
  call bg#RunQF(cmd,'c',errorFormat)
endf

let s:gnu_id_utils_file = fnamemodify(expand('<sfile>'),':h').'/gnu-idutils.config'
fun! vim_addon_other#GnuIdutils_Mkid()
  let this_config = s:gnu_id_utils_file
  let cmd = funcref#Call( get(s:config,'mkid', funcref#Function('return ["mkid", "-m", ARGS[0]]') ) , [this_config])
  let errorFormat = "dummy"
  call bg#RunQF(cmd,'c',errorFormat)
endf

fun! vim_addon_other#GnuIdutils_Lid()
"lid","-R","grep","-r",word
  let cmd = funcref#Call( get(s:config, 'lid', funcref#Function('return ["lid", "-R", "grep", input("lid -R grep (^word$ for whole word matchr :") , "."]') ) )
  let errorFormat = get(s:config,'greplid_ef', '%f:%l:%m')
  call bg#RunQF(cmd,'c',errorFormat)
endf
