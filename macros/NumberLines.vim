while line(".") < line("$")
  execute 'normal I' . line(".") . '|j'
endwhile
