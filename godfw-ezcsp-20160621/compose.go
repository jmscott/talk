package main
import "fmt"

func fib(i int) int {

	if i <= 2 {
		return 1
	}

	return fib(i - 1) + fib(i - 2)
}

func fib_flow(in chan int) (out chan int) {

	out = make(chan int)

	go func() {
		for i := range in {
			out <- fib(i)
		}
		close(out)
	}()

	return out
}

func sqr_flow(in chan int) (out chan int) {

	out = make(chan int)

	go func() {
		for i := range in {
			out <- i * i
		}
		close(out)
	}()

	return out
}

func main() {

	in := make(chan int)

	out := sqr_flow(
                   fib_flow(
                       sqr_flow(
                           fib_flow(in),
                       ),
                   ),
               )

	in <- 5
	fmt.Println(<- out)
}
