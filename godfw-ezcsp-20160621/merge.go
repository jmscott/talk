func merge(in ...<-chan int) <-chan int {
    var wg sync.WaitGroup			// HL
    out := make(chan int)

    io := func(c <-chan int) {	//  
        for n := range c {
            out <- n
        }
        wg.Done()			// End of input so decrement semaphore counter // HL
    }
    wg.Add(len(in))

    for _, c := range in {		//  Start listeners // HL
        go io(c)
    }

    go func() {				//  Wait for all listeners to finish // HL
        wg.Wait()
        close(out)
    }()

    return out
}
