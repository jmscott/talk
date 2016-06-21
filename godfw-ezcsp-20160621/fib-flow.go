package main
import "fmt"

func fib(i uint64) uint64 {

	if i <= 2 {
		return 1
	}

	return fib(i - 1) + fib(i - 2)
}

func fib_flow(in chan uint64) (out chan uint64) {

	out = make(chan uint64)

	go func() {
		for i := range in {
			out <- fib(i)
		}
		close(out)
	}()

	return out
}

func main() {

	in := make(chan uint64)
	out := fib_flow(in)

	in <- 43
	fmt.Println(<- out)
}
// END MAIN OMIT