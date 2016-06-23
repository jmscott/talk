func flow (north, south, east, west chan int) {

	var message int

	for {
		select {

		case message <- west:
			..
		case message <- south:
			..
		case north <- message:
			..
		case east <- message:
			..
		}
	}
}
