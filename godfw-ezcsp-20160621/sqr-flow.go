package main
import "fmt"

func sqr_flow(in chan uint64) (out chan uint64) {

	out = make(chan uint64)

	go func() {
		for i := range in {
			out <- i * i
		}
		close(out)
	}()

	return out
}

func main() {

	in := make(chan uint64)
	out := sqr_flow(in)

	in <- 43
	fmt.Println(<- out)
}
// END MAIN OMIT
