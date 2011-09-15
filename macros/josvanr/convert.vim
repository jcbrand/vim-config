" **convert.vim**
let n=bufnr("$")
let i=1
while i<=n
  exe "b".i
  set fileformat=unix
  exe "w"
  let i=i+1
endwhile
