package main
import "fmt"

func fib(i int) int {					// HL

	if i <= 2 {
		return 1
	}

	return fib(i - 1) + fib(i - 2)
}

func main() {						// HL

	fmt.Println(fib(43))

}
