// BUG(jmscott, What about using sql prepare to speed up the query)

// 1 START OMIT
package main

import (
	"bufio"
	"database/sql"
	"io"
	"os"
	"strings"
	"syscall"

	. "fmt"
	_ "github.com/lib/pq"
)
// 1 END OMIT

// 2 START OMIT
const (
	select_stmt = `
	 select
	 	exists (
		  select
		  	cookie
		    from
		    	login_session
		    where
		    	cookie = $1
		)`
	QUERY_COUNT = 9
	COOKIE_CHANNEL_SIZE = 96
)

var (
	Stdin = os.NewFile(uintptr(syscall.Stdin), "/dev/stdin")
)

type stat struct {      //  track stats for select queries for each go routine
	true_count      uint64
	false_count     uint64
}
// 2 END OMIT

// 3 START OMIT
func select_cookies(
	db *sql.DB,                   //  database connection
	stmt *sql.Stmt,               //  prepared statment
	cookies chan string,          //  read cookies
	done chan *stat,              //  answer with stats
) {
	stat, exists := &stat{}, false

	//  read cookies on string channel
	for cookie := range cookies {
		err := stmt.QueryRow(cookie).Scan(&exists)	// HL
		if err != nil {
			panic(err)
		}
		if exists {
			stat.true_count++
		} else {
			stat.false_count++
		}
	}
	done <- stat
}
// 3 END OMIT

// 4 START OMIT
func open_db() (
	db *sql.DB,
	stmt *sql.Stmt,
) {
	var err error

	//  open postgresql database, inheriting PG params from environment
	db, err = sql.Open("postgres", "sslmode=disable")
	if err != nil {
		panic(err)
	}

	db.SetMaxIdleConns(8)       //  keep 8 idle connections
	db.SetMaxOpenConns(128)     //  no more 128 simultaneous db connection

	stmt, err = db.Prepare(select_stmt)
	if err != nil {
		panic(err)
	}
	return db, stmt
}
// 4 END OMIT

// 5 START OMIT
func send_cookies (cookies chan string) {

	//  for each cookie read on standard input,
	//  send that cookie to some query go routines
	in := bufio.NewReader(Stdin)
	for {
		cookie, err := in.ReadString('\n')
		if err != nil {
			if err == io.EOF {
				break
			}
			panic(err)
		}

		//  send to competing pool of selects
		cookies <- strings.TrimRight(cookie, "\n")
	}
	close(cookies)
}
// 5 END OMIT

// 6 START OMIT
func wait(done chan *stat) {

	true_count := uint64(0)
	false_count := uint64(0)

	//  wait for select()s to finish in the 
	for i := 0;  i < QUERY_COUNT;  i++ {

		// read stat from each terminating query worker
		s := <- done

		//  accumulate total stats as workers exit
		true_count += s.true_count
		false_count += s.false_count
	}
	Printf(" True/False Count: %d/%d\n", true_count, false_count)
}
// 6 END OMIT

// 7 START OMIT
func main() {

	//  open postgresql database, inheriting PG params from environment
	db, stmt := open_db()

	// works indicate finished by sending stats on 'done' channel
	done := make(chan *stat)

	// workers compete by reading string cookies from this channel
	cookies := make(chan string, COOKIE_CHANNEL_SIZE)

	//  spawn competing go routines
	for i := 0;  i < QUERY_COUNT;  i++ {
		go select_cookies(db, stmt, cookies, done)
	}
	//  boot up cookie switch in background
	go send_cookies(cookies)

	// synchronously wait for results
	wait(done)

	os.Exit(0)     //  good bye, cruel world
}
// 7 END OMIT
