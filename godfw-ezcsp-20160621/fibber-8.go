package main
import . "fmt"

func fib(i int) int {
	if i <= 2 {
		return 1
	}
	return fib(i - 1) + fib(i - 2)
}

func main() {

	out := make(chan int)
	fibber := func(i int) {
		out <- fib(i)
	}

	go fibber(43);   go fibber(43);   go fibber(43);   go fibber(43);
	go fibber(43);   go fibber(43);   go fibber(43);   go fibber(43);

	Println(<-out,  <-out,  <-out,  <-out,  <-out,  <-out,  <-out,  <-out)
}
