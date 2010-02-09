fun! vim_addon_other_python#RunPythonRHS(background)
  " test this error format
  let ef= 
      \   '\ \ File\ "%f"\,\ l'
      \ .',%C\ %.%#'
      \ .',%A\ \ File\ "%f"'
      \ .',\ line\ %l%.%#endf'
      \ .',%Z%[%^\ ]%\@=%m'

  let args = ["python"] + [ expand('%')]
  let args = eval(input('command args: ', string(args)))
  return a:background
    \ ? "call bg#RunQF(".string(args).", 'c', ".string(ef).")"
    \ : ['exec "set efm='.ef.'" ',"set makeprg=python", "make ".join(args, ' ') ]
  " think about proper quoting in : case
endf
