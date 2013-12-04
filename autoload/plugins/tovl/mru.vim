" functions will be loaded lazily when needed
" exec vam#DefineAndBind('s:c','g:my_mru', '{}')
if !exists('g:my_mru') | let g:my_mru = {} | endif | let s:c = g:my_mru
let s:c.hist_file = get(s:c, 'histfile', $HOME.'/.my_mru')
let s:c.hist_line_size = get(s:c, 'hist_line_size', 1000)

fun! plugins#tovl#mru#ShowMRUList()
  let list = []
  let files = {}
  for i in plugins#tovl#mru#R()
    " only show a file once. the first match is sufficient
    if !has_key(files, i[1])
      call add(list, {'event' : i[0], 'file' : i[1]})
      let files[i[1]] = 1
    endif
  endfor
  call tovl#ui#filter_list#ListView({
      \ 'number' : 1,
      \ 'selectByIdOrFilter' : 1,
      \ 'Continuation' : funcref#Function('exec "e ".escape(ARGS[0]["file"], " ")'),
      \ 'items' : list,
      \ 'cmds' : ['wincmd J'],
      \ 'aligned' : 1
      \ })
endf

fun! plugins#tovl#mru#R()
 return 
       \ filereadable(s:c.hist_file)
	\?  readfile(s:c.hist_file)
	\: []
endf

fun! plugins#tovl#mru#Remember()
  if expand('%:p') == ''
    return
  endif
  " get current file conents 
  let c = plugins#tovl#mru#R()
  let c = [expand('%:p')] + c
  let c = c[0: s:c.hist_line_size ]
  " force writing to disk:
  call writefile(c, string(s:c.hist_file)]
endf
