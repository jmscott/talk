package main
import . "fmt"

func fib(i int) int {					// HL
	if i <= 2 {
		return 1
	}
	return fib(i - 1) + fib(i - 2)
}

func main() {						// HL

	out := make(chan int)
	fibber := func(i int) {				// HL
		out <- fib(i)
	}

	go fibber(43);   go fibber(43);   go fibber(43);   go fibber(43);
	go fibber(43);   go fibber(43);   go fibber(43);   go fibber(43);

	Println(<-out,  <-out,  <-out,  <-out,  <-out,  <-out,  <-out,  <-out)
}
