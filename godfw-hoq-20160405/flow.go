//  a flow tracks the firing of rules over a single line of input text.

type flow struct {

	//  request a new flow from this channel, reading reply on sent side-channel   // HL
	next chan flow_chan

	//  channel is closed when all exec()s make no further progress // HL
	resolved chan struct{}

	//  the whole line of input with trailing new line removed   // HL
	line string

	//  tab separated fields split out from the line read from standard input   // HL
	fields []string

	//  count of go routines/operators still resolving qualifications  // HL
	confluent_count int
}
type flow_chan chan *flow
