func to_lower(in chan string) (out chan string) {

	out = make(chan string)

	go func() {
		defer close(out)

		for s := range in {
			out <- strings.ToLower(s)
		}
	}()

	return out
}

