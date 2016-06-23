//  variable info is a pointer to a function - named closure

info := func(msg string) {
	Println(msg)
}

info("hello, world")

... 

info("good bye, cruel world")
