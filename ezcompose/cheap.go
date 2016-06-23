func pipe_element(in chan int) (out chan int) {

	out = make(chan int)

	go func() {
		defer close(out)

		for {
			request := <-in
			if request == 0 {
				return
			}

			//  ... do some work

			out <- 42
		}
 	}()
 	return out
}
