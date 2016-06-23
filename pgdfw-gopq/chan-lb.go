
 type session struct {
 	name	string
 }

 c := make(chan *session)

 // channel of channels of pointers to sessions
 load_balancer := make(chan chan *session)
