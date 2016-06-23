package main

import . "fmt"

func main() {

	chat := make(chan string)   //  declare and create twoway string channel

	go func() {
		Println("background: ", <- chat)
		chat <- "Good bye, cruel world"
	}()

	chat <- "Hello, world"
	Println("main: ", <-chat)
}
