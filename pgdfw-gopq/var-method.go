type bean_count uint16

//  bind private print() to any bean_count type

func (bc bean_count) print() {
        Println(bc)
}

...

	bc := bean_count(0)
	bc.print()
