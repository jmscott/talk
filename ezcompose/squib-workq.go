package main
import . "fmt"

func fib(i int) int {

	if i < 2 {
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

func squib_queue(in chan int, worker_count int) (merge chan int) {

	merge = make(chan int)

	for i := 0;  i < worker_count;  i++ {

		go func() {

			out := square_pipe(fib_pipe(in))
			for {
				merge <- (<- out)
			}

		}()
	}
	return merge
}

func main() {

	in := make(chan int)

	pump := func(limit int) {
		for i := 1;  i <= limit;  i++ {
			in <- i
		}
	}
	go pump(42)

	out := squib_queue(in, 4)

	for i := 1;  i <= 42;  i++ {
		Println(<- out)
	}
}
