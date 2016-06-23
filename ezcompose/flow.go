type flow struct {

	next		flow_chan
	resolved	struct{}
}
type flow_chan chan *flow

func (flow *flow) get() *flow {

	<-flow.resolved

	reply := make(flow_chan)
	flow.next <- reply
	return <-reply
}

func (flow *flow) operation(in chan int) (out chan int) {

	func op() {
		defer(out)

		for flow = flow.get(); flow != nil; flow = flow.get() {
		}
	}
	return out
}
