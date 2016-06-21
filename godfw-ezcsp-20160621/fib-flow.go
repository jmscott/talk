package main
import "fmt"

func fib(i int) int {

	if i <= 2 {
		return 1
	}

	return fib(i - 1) + fib(i - 2)
}

func fib_flow(in chan int) (out chan int) {			// HL

	out = make(chan int)

	go func() {						//  Listen in Background on 'in' channel // HL
		for i := range in {
			out <- fib(i)
		}
		close(out)
	}()

	return out
}

func main() {							// HL

	in := make(chan int)
	out := fib_flow(in)

	in <- 43
	fmt.Println(<- out)
}
// END MAIN OMIT
