package main
import (
	"fmt"
	"sync"
)

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

func sqr_fib_flow(in chan int) (out chan int) {

	return sqr_flow(fib_flow(in)) 
}


func merge(in ...<-chan int) <-chan int {
    var wg sync.WaitGroup
    out := make(chan int)

    io := func(c <-chan int) {	//  
        for n := range c {
            out <- n
        }
        wg.Done()			// End of input so decrement semaphore counter // HL
    }
    wg.Add(len(in))

    for _, c := range in {		//  Start listeners // HL
        go io(c)
    }

    go func() {				//  Wait for all listeners to finish // HL
        wg.Wait()
        close(out)
    }()

    return out
}

func pump(iv ...int) (chan int) {		// HL

	out := make(chan int)

	go func() {
		for _, n := range iv {
			out <- n
		}
		close(out)
	}()
	return out
}

func main() {		// HL

	in := pump(43, 43, 43, 43, 43, 43, 43, 43)
	out := merge(sqr_fib_flow(in), sqr_fib_flow(in), sqr_fib_flow(in), sqr_fib_flow(in))

	for n := range out {
		fmt.Println(n)
	}
}
// END MAIN OMIT
