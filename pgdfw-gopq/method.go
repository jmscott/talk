package main
import "math"
import . "fmt"

type point struct {
	x, y, z         float64
}

func (p *point) length() float64 {
	return math.Sqrt(p.x * p.x + p.y * p.y + p.z * p.z)
}

func main() {
	p := &point {
		x:	1.0,
		y:	2.0,
		z:	3.0,
	}
	Println(p.length())
}
