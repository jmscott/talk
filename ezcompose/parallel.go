package main
import . "fmt"

func fib(i int) int {
	if i < 2 {
		return 1
	}
	return fib(i - 1) + fib(i - 2)
}

func main() {

	answer := make(chan int)

	fib_worker := func(i int) {
		answer <- fib(i)
	}

	go fib_worker(42)				// Just add "go" in front of function call
	go fib_worker(42)
	go fib_worker(42)
	go fib_worker(42)

	Println(<- answer, <- answer, <- answer, <- answer)
}
