package main

import . "fmt"

// 1 START OMIT
type locker interface {
	lock()
	unlock()
}
// 1 END OMIT

// 2 START OMIT
type foo struct {
	name	string
}
type bar struct {
	name	string
}

//  Methods for locker interface defined over 'foo' and 'bar' types

func (f *foo) lock() {
	Println(f.name, "hello from foo.lock()")
}

func (b *bar) lock() {
	Println(b.name, "hello from bar.lock()")
}

func (f *foo) unlock() {
	Println(f.name, "hello from foo.unlock()")
}

func (b *bar) unlock() {
	Println(b.name, "hello from bar.unlock()")
}

// 2 END OMIT

// 3 START OMIT
func main() {
	var l locker

	l = &foo{name: "John"}
	l.lock()
	// ... critical code
	l.unlock()

	l = &bar{name: "Beth"}
	l.lock()
	//  .. critical code
	l.unlock()
}
// 3 END OMIT
