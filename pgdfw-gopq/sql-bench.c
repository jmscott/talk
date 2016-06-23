/* Processed by ecpg (4.10.0) */
/* These include files are added by the preprocessor */
#include <ecpglib.h>
#include <ecpgerrno.h>
#include <sqlca.h>
/* End of automatic include section */

#line 1 "sql-bench.pgc"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

/* exec sql begin declare section */

		
		
 	  



#line 7 "sql-bench.pgc"
 bool cookie_exists ;
 
#line 8 "sql-bench.pgc"
 char cookie [ 4096 ] ;
 
#line 9 "sql-bench.pgc"
 const char * select_cookie = "					\
	select								\
	  exists (							\
		select							\
			cookie						\
		  from							\
			login_session					\
		  where							\
			cookie = ?					\
	)" ;
/* exec sql end declare section */
#line 21 "sql-bench.pgc"


void
check_sqlca()
{
	long status;

	status = sqlca.sqlcode;
	if (status == 0)
		return;
	fprintf(stderr, "ERROR: sqlcode != 0: %ld\n", status);
	fprintf(stderr, "ERROR: sqlerrm.sqlerrmc: %s\n",sqlca.sqlerrm.sqlerrmc);
	exit(1);
}


int
main(int argc, char **argv)
{
	int true_count = 0, false_count = 0;

	{ ECPGconnect(__LINE__, 0, NULL, NULL, NULL, "DEFAULT", 0); }
#line 42 "sql-bench.pgc"

	check_sqlca();

	{ ECPGprepare(__LINE__, NULL, 0, "select_cookie", select_cookie);}
#line 45 "sql-bench.pgc"

	check_sqlca();

	while (fgets(cookie, sizeof cookie, stdin) != NULL) {
		int len = strlen(cookie);		
		if (len > 1)
			cookie[len - 1] = 0;

		{ ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_execute, "select_cookie", 
	ECPGt_char,(cookie),(long)4096,(long)1,(4096)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_bool,&(cookie_exists),(long)1,(long)1,sizeof(bool), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 54 "sql-bench.pgc"

		check_sqlca();
		if (cookie_exists)
			true_count++;
		else
			false_count++;
	}
	printf("True/False Count: %d/%d\n", true_count, false_count);
	exit(0);
}
