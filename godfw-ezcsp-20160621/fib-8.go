package main
import "fmt"

func fib(i uint64) uint64 {
	if i <= 2 {
		return 1
	}
	return fib(i - 1) + fib(i - 2)
}

func main() {

	fmt.Println(
		fib(43),   fib(43),   fib(43),   fib(43),  
		fib(43),   fib(43),   fib(43),   fib(43),  
	)
}
