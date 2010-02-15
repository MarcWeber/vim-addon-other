let s:ef =
        \ '%f:%l:%c:%m'
        \ .',%E%f:%l:%c:'

fun! vim_addon_other_haskell#RunGHCRHS()
  " errorformat taken from http://www.vim.org/scripts/script.php?script_id=477

  let options = filter( getline(1, line('$')), "v:val =~ '--\\s*ghc-options:'" )
  if len(options) == 1
    let ghcOptions = split( matchstr( options[0], 'ghc-options:\s*\zs.*'), '\s*,\s*')
  elseif len(options) > 1
    echo "ambiguous options definitions"
    let ghcOptions = []
  else
    let ghcOptions = []
  endif

  let args = ["ghc","--make"] + ghcOptions + [ expand('%') ]
  let args = eval(input('command: ', string(args)))
  return "call bg#RunQF(".string(args).", 'c', ".string(s:ef).")"
endf

fun! vim_addon_other_haskell#RunCabalBuild()
  " errorformat taken from http://www.vim.org/scripts/script.php?script_id=477

  let args = ["./Setup","build"]
  let args = eval(input('command: ', string(args)))
  return "call bg#RunQF(".string(args).", 'c', ".string(s:ef).")"
endf
