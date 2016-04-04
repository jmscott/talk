//  send a string constant upstream

type string_value struct {
	string
	is_null bool
}
type string_chan chan *string_value

...

func (flo *flow) const_string(s string) (out string_chan) {

	out = make(string_chan)

	go func() {
		defer close(out)

		for flo = flo.get(); flo != nil; flo = flo.get() {
			out <- &string_value{
				string: s,
			}
		}
	}()

	return out
}
