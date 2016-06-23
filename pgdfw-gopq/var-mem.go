//  create variable initialized to utf-8 string

s := "hello, world"

//  take memory address of variable s

sp := &s

//  change contents of what new variable s references

*sp = "good bye, cruel world"
