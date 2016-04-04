package main
import "fmt"

func fib(i int) int {
	if i < 2 {
		return 1
	}
	return fib(i - 1) + fib(i - 2)
}

func fib_chan(in chan int) (out chan int) {

	out = make(chan int)

	go func() {
		defer close(out)

		for i := range in {
			out <- fib(i)
		}
	}()

	return out
}

func main() {
	in := make(chan int)

	out := fib_chan(in)

	i := 1;
	for {
		in <- i
		fmt.Println(i, "=", <-out)
		i++
	}
}
