rows, err := db.Query("SELECT ...")

...

defer rows.Close()

for rows.Next() {
    var id int
    var name string

    err = rows.Scan(&id, &name)

    ...
}

err = rows.Err() // get any error encountered during iteration
...
