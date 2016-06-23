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


func fib_pipe(in chan int) (out chan int) {

	out = make(chan int)

	go func() {
		defer close(out)

		for i := range in {
			out <- fib(i)
		}
	}()
	return out
}

func square_pipe(in chan int) (out chan int) {

	out = make(chan int)

	go func() {
		defer close(out)

		for i := range in {
			out <- square(i)
		}
	}()
	return out
}

func main() {

	in := make(chan int)

	out := square_pipe(fib_pipe(in))

	for i := 1;  i <= 42;  i++ {
		in <- i
		Println(i, <-out)
	}
}
