//  Perl style range over an array or slice

for index, value := range env {
	Printf("env[%d] = %s\n", value, index)
}
