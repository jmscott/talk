package main
import . "fmt"

func fib(i int) int {

	if i < 2 {
		return 1
	}

	return fib(i - 1) + fib(i - 2)
}

func main() {

	Println(fib(40))

}
