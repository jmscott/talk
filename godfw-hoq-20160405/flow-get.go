//  each opcode requests another flow

func (flo *flow) get() *flow {

	//  wait for entire query to resolve     // HL

	<-flo.resolved

	//  next active flow arrives on this channel   // HL

	reply := make(flow_chan)

	//  request another flow by sending reply channel to main()  // HL

	flo.next <- reply

	//  return next flow to the this opcode // HL

	return <-reply
}
