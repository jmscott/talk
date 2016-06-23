package main
import . "fmt"

func fib(i int) int {

	if i <= 2 {
		return 1
	}
	return fib(i - 1) + fib(i - 2)
}

func square(i int) int {
	
	return i * i
}

func squib(i int) int {
	
	return square(fib(i))
}

func main() {

	request, reply := make(chan int), make(chan int)

	worker := func() {
		for {
			reply <- squib(<-request)
		}
	}

	pump := func(limit int) {
		for i := 1;  i <= limit;  i++ {
			request <- i
		}
	}

	go worker();  go worker();  go worker();  go worker();  go worker();  go worker()

	go pump(42)
	for i := 1;  i <= 42;  i++ {
		Println(i, <-reply)
	}
}
