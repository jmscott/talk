package main

import (
	. "fmt"
	. "strings"
)

type flow struct {

	//  all expressions are resolved when closed
	resolved chan struct{}

	//  request next flow
	next chan chan *flow

	//  count total unresolved query predicate expressions
	confluent_count uint32

	//  tuple being analyzed: [hostname, ip4]
	tuple map[string]string
}

//  A is always resolved and B is "conflueing"
var flowA, flowB *flow

func (flo *flow) new(inbound map[string]string) *flow {

	return &flow{
		resolved: make(chan struct{}),
		next:     make(chan chan *flow),
		tuple:    inbound,
	}
}

var attack [4]map[string]string

func init() {
	flowA = flowA.new(nil)
	close(flowA.resolved) //  0'th already resolved

	attack[0] = map[string]string{
		"ip4":      "173.193.106.242",
		"hostname": "condor.setspace.com",
	}
	attack[1] = map[string]string{
		"ip4":      "23.207.24.80",
		"hostname": "www.apple.com",
	}
	attack[2] = map[string]string{
		"ip4":      "10.214.34.11",
		"hostname": "kimroom.kp",
	}
	attack[3] = map[string]string{
		"ip4":      "10.214.34.25",
		"hostname": "theputins.ru",
	}
}

//  OMIT

func (flo *flow) get() *flow {

	<-flo.resolved

	reply := make(chan *flow)

	flo.next <- reply

	return <-reply
}

func (flo *flow) has_prefix(
	prefix_constant string,
	in chan string,
) (out chan bool) {

	out = make(chan bool)

	go func() {

		for flo = flo.get(); flo != nil; flo = flo.get() {

			out <- HasPrefix(<-in, prefix_constant)
		}
	}()

	return out
}

func (flo *flow) project_tuple(att_name string) (out chan string) {

	out = make(chan string)

	go func() {

		for flo = flo.get(); flo != nil; flo = flo.get() {

			out <- flo.tuple[att_name]
		}
	}()

	return out
}

func (flo *flow) has_suffix(
	suffix_constant string,
	in chan string,
) (out chan bool) {

	out = make(chan bool)

	go func() {

		for flo = flo.get(); flo != nil; flo = flo.get() {

			out <- HasSuffix(<-in, suffix_constant)
		}
	}()

	return out
}

func (flo *flow) print(in chan bool) (out chan struct{}) {

	out = make(chan struct{})
	go func() {
		defer close(out)

		for flo = flo.get(); flo != nil; flo = flo.get() {

			who := "+ good guy"
			if <-in {
				who = "! bad guy"
			}

			Println(who, "->", flo.tuple)

			out <- struct{}{} //  why the extra {}?
		}
	}()

	return out
}

func conflue(out chan struct{}) {

	//  wait for all expressions in flowA to resolve
	for flowA.confluent_count > 0 {

		reply := <-flowA.next
		flowA.confluent_count--

		reply <- flowB
		flowB.confluent_count++
	}

	//  wait for flowB to finish with final print statement
	<-out

	//  start moving flowB to next flow
	close(flowB.resolved)

	//  and the wheel turns ...
	flowA = flowB
}

func simple_conflue(source map[string]string) {

	//  compile expression
	//
	//	print(hostname like "%.kp")

	out :=
		flowA.print(
			flowA.has_suffix(".kp",
				flowA.project_tuple("hostname")))

	//  three go routines will converge
	flowA.confluent_count = 3

	flowB = flowB.new(source)
	conflue(out)
}

func compile() (out chan struct{}) {
	out = flowA.print(
		flowA.logical_AND(

			//  ip4 like "10.%"
			flowA.has_prefix(
				"10.",
				flowA.project_tuple("ip4"),
			),

			flowA.logical_OR(

				// hostname like "%.ru"
				flowA.has_suffix(
					".ru",
					flowA.project_tuple("hostname"),
				),

				// hostname like "%.kp"
				flowA.has_suffix(
					".kp",
					flowA.project_tuple("hostname")))))
	flowA.confluent_count = 9
	return
}

func (flo *flow) logical_AND(left, right chan bool) (out chan bool) {

	out = make(chan bool)

	go func() {
		defer close(out)

		for flo = flo.get(); flo != nil; flo = flo.get() {

			l, r := false, false
			for count := 0; count < 2; count++ {
				select {
				case l = <-left:
				case r = <-right:
				}
			}

			out <- l && r
		}
	}()
	return out
}

func (flo *flow) logical_OR(left, right chan bool) (out chan bool) {

	out = make(chan bool)

	go func() {
		defer close(out)

		for flo = flo.get(); flo != nil; flo = flo.get() {

			l, r := false, false
			for count := 0; count < 2; count++ {
				select {
				case l = <-left:
				case r = <-right:
				}
			}

			out <- l || r
		}
	}()
	return out
}

func attacking() {

	out := compile()
	for _, a := range attack {
		flowB = flowB.new(a)
		conflue(out)
	}
}

func simple() {

	trivial := map[string]string{
		"hostname": "kimsroom.kp",
	}

	simple_conflue(trivial)
}

func main() {

	simple()
}

//OMIT
