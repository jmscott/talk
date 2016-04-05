import "regexp"

func re_match(sample, re string) bool {

	matched, err := regexp.MatchString(re, sample)
	if err != nil {
		panic(err)
	}

	return matched
}

type bool_value struct {
	bool
	is_null bool
}
type bool_chan chan *bool_value

func (flo *flow) string_rel2(
	rel2 func(left, right string) bool,
	in_left,
	in_right string_chan,
) (out bool_chan) {

	out = make(bool_chan)
	go func() {
		defer close(out)
	
// START FLOW OMIT
		for flo = flo.get(); flo != nil; flo = flo.get() {
			var left, right *string_value

			for left == nil || right == nil {		// HL
				select {
				case lv := <-in_left:			// HL
					if lv == nil {
						return
					}
					left = lv
				case rv := <-in_right:			// HL
					if rv == nil {
						return
					}
					right = rv
				}
			}
			bv := &bool_value {is_null: left.is_null || right.is_null}
			if bv.is_null == false {
				bv.bool = rel2(left.string, right.string)
			}
			out <- bv		//  send channel to next opcode
		}
// END FLOW OMIT
	
	}()
	return out
}
