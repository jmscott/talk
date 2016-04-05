
 //  set up first flow to compile all ast nodes into a single flow graph. // HL
 //  each flow terminates by sending a count of the fired unix processes. // HL
 
 flowA := &flow{
 	next:     make(chan flow_chan),
 	resolved: make(chan struct{}),
 }
 uc := flowA.compile(ast, depend_order)           //  compile using gnu tsort // HL
 close(flowA.resolved)                            //  flowA never runs // HL
 
 //  start pumping standard input to the flow graph of nodes             // HL
 
 in := bufio.NewReader(os.Stdin)
 for {
 	line, err := in.ReadString('\n')
 	...
