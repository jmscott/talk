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

func squib(i int) int {
	
	return square(fib(i))
}

func main() {

	Println(squib(42))
}
// END
