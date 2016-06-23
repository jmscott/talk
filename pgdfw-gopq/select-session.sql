SELECT
	EXISTS (
	  SELECT
	  	cookie
	    FROM
	    	login_session
	    WHERE
	    	cookie = $1
	)
;
