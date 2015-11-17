if exists('w:m1')
  silent! call matchdelete(w:m1)
  silent! call matchdelete(w:m2)
  unlet w:m1
  unlet w:m2
endif
