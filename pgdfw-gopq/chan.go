done := make(chan int)

...

//  send the boolean value 'true' down the channel.
//  block until other ends reads

done <- true

...

//  the other end waits for done

<- done
Print("finished")
