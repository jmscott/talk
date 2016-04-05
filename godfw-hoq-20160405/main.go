	line = strings.TrimRight(line, "\n")        //  trim and split the input line of text  // HL
	flowB := &flow{
		line:     line,
		fields:   strings.SplitN(line, "\t", 255),
		next:     make(chan flow_chan),
		resolved: make(chan struct{}),
	}
	for flowA.confluent_count > 0 {            //  push flowA to flowB // HL
		reply := <-flowA.next
		flowA.confluent_count--
		reply <- flowB
		flowB.confluent_count++
	}
	if <-uc == nil {                           //  wait for flowB to finish // HL
		break
	}
	close(flowB.resolved)                     //  broadcast to all nodes in flowB the flow is done // HL
	flowA = flowB                             //  and so the wheel turns // HL
