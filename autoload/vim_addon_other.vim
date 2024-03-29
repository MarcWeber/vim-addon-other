" vam#DefineAndBind('s:config','g:config',{})
if !exists('g:vim_addon_other_config') | let g:vim_addon_other_config = {} | endif | let s:config = g:vim_addon_other_config

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
"
" problem: you cannot jump to 05, becaues 5 will be passed via v:count
function! vim_addon_other#SmartGotoLine(visual_select)
    let c = v:count
    let half = ('1'.repeat('0',len(c))) / 2
    let lnum = line('.')[:-len(c)-1].c
    if  lnum > half + line('.')
      let lnum -= 2* half
    endif
    if a:visual_select
      exec 'normal! V'.lnum.'G'
    else
      exec 'normal '.lnum.'G'
    endif
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

fun! vim_addon_other#GrepR(excludes)
  let excludes = split('--exclude-dir=.cvs --exclude=tags --exclude=TAGS --exclude=*.png --exclude=*.gz --exclude=*.jpg --exclude=*.PNG --exclude=*.JPG  --exclude=*.annot -I --exclude-dir=.git --exclude=tags --exclude=TAGS --exclude=*.png --exclude=*.gz --exclude=*.jpg --exclude=*.PNG --exclude=*.JPG  --exclude=*.annot -I --exclude-dir=.hg --exclude=tags --exclude=TAGS --exclude=*.png --exclude=*.gz --exclude=*.jpg --exclude=*.PNG --exclude=*.JPG  --exclude=*.annot -I --exclude-dir=.svn --exclude=tags --exclude=TAGS --exclude=*.png --exclude=*.gz --exclude=*.jpg --exclude=*.PNG --exclude=*.JPG  --exclude=*.annot -I', '')
        \ + map(a:excludes, '"--exclude-dir=".v:val')

  if (isdirectory('dist') && filereadable('package.json'))
    call add(excludes, '--exclude-dir=dist')
  endif

  let cmd = funcref#Call( get(s:config,'grepprg', funcref#Function('return ["grep", "'.(a:excludes == [] ? '-R': '-r').'","-n"] + '.string(excludes).' + ["--", substitute(input("grep -r for :"), "[$]", "\\\\$", "g" ) , "."]') ) )
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
  let cmd = funcref#Call( get(s:config, 'lid', funcref#Function('return ["lid", "-R", "grep", input("lid -R grep (^word$ for whole word matchr :")]') ) )
  let errorFormat = get(s:config,'greplid_ef', '%f:%l:%m')
  call bg#RunQF(cmd,'c',errorFormat)
  return

  " non bg version
  exec 'set efm='.errorFormat
  exec 'set grepprg='.cmd[0]
  exec 'grep '.join(cmd[1:],' ')
endf


fun! vim_addon_other#RenameFile(newname)
  let file = expand('%')
  exec 'saveas '.a:newname
  if delete(file) !=0
    echoe "could'n delete file ". file
  endif
endfun

fun! vim_addon_other#ContinueWorkOnCopy(newname)
  let file = expand('%')
  exec 'saveas '.a:newname
endfun

" Visual mode search vsearch.vim (by godlygeek)
function! vim_addon_other#VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  " Use this line instead of the above to match matches spanning across lines
  "let @/ = '\V' . substitute(escape(@@, '\'), '\_s\+', '\\_s\\+', 'g')
  call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
  let @@ = temp
endfunction


" usage: inoremap <m-=> <c-r>=tovl#map#SurroundBy(' ','=',' ')<cr>
" This will add leading and trailing white spaces if not present
" memomic: Insert L eading T railing text as well
"
" usage (ftplugin):
" fun! s:LTSp(s)
"   return vim_addon_other#InsertLT(' ',a:s,' ')
" endf
" inoremap <buffer> <m->> <c-r>=<sid>LTSp("->")<cr>
fun! vim_addon_other#InsertLT(before, text, after)
  " TODO
  let [b,a] = vim_addon_other#SplitCurrentLineAtCursor()
  return (b =~ a:before.'$' ? '' : a:before ).a:text.(a =~ '^'.a:after ? '' : a:after )
endf

fun! vim_addon_other#SplitCurrentLineAtCursor()
  let pos = col('.') -1
  let line = getline('.')
  return [strpart(line,0,pos), strpart(line, pos, len(line)-pos)]
endfunction

fun! vim_addon_other#SelectTag(regex)
  let tag = eval(tlib#input#List('s','select tag', map(taglist(a:regex), 'string([v:val.kind, v:val.filename, v:val.cmd])')))
  exec 'e '.fnameescape(tag[1])
  exec tag[2]
endf

fun! vim_addon_other#GotoFileLine()
  let n = expand('%')
  let m = matchlist(n, '\(.\{-}\)\([:]\(\d\+\)\)\%([:]\(\d\+\)\)\?$')
  if filereadable(m[1])
    exec 'sp '.fnameescape(m[1]) | exec m[2]
    if m[3] > 0 | exec 'normal '.m[3].'|' | endif
    exec 'bw! '.fnameescape(n)
  endif
endf
