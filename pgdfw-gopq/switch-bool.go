//  Or full boolean expressions in eash case expression

switch {

case state == "start" || state == "active":
	...

case state == "sleeping" || state == "waiting":
	...

case state == "canceled":
	...

case state == "done"
	...

default:
	panic("unknown state")
}
