  exp  AND  exp                //  logical and of two qualifications       // HL
  {
        l := yylex.(*yyLexState)
        $$ = l.bool_node(AND, $1, $3)
        if $$ == nil {
                return 0
        }

        if $1.go_type != reflect.Bool {
                l.error("logical 'and' requires boolean operands")
                return 0
        }
  }
|
  '('  exp  ')'                 //  change precedence of qualification  // HL
  {
        $$ = $2
  }
