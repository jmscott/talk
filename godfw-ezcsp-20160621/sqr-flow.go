package main
import "fmt"

func sqr_flow(in chan int) (out chan int) {		// HL

	out = make(chan int)

	go func() {					//  Listen in Background on 'in' channel // HL
		for i := range in {
			out <- i * i
		}
		close(out)
	}()

	return out
}

func main() {						// HL

	in := make(chan int)
	out := sqr_flow(in)

	in <- 43
	fmt.Println(<- out)
}
// END MAIN OMIT
