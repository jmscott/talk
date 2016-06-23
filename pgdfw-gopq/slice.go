package main
import . "fmt"

func main() {
	var buffer [256]byte          //  byte byte byte ... 256 times
	buffer[109] = 123      
	slice := buffer[100:150]      //  New slice using array buffer[]
	Println(slice[9])             //  ???
	slice2 := slice[5:10]         //  Slice of a slice
	Println(slice2[4])            //  Addressed relative to second slice
	p := &slice[9]                //  Pointer to address of slice[9], slice2[4], buffer[109]
	*p = 97                       //  Write directly to memory, like C

	Println(*p, buffer[109], slice2[4], slice[9])
}
