package main

import "fmt"

func main() {

	//  create variable initialized to utf-8 string

	s := "hello, world"
	fmt.Println(s)

	//  take memory address of variable s

	sp := &s

	//  change what s references

	*sp = "good bye, cruel world"

	fmt.Println(s)		//  prove it
}
