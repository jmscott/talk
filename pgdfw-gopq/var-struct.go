type wine struct {
    vitner      string
    name        string
    year        uint16
}

//  json style initialization of new struct value

w := wine{
    vitner:    "Conchay Toro",
      name:    "Casillero del Diablo",
      year:    2008,
}
w.year = 2013

//  take address of wine structure value.  '&' operator from C language

wp := &w

//  dereference pointer using '.' and not the C style '->' operator

wp.year = 2012
