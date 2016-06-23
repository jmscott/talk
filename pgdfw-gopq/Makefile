export GOROOT=/usr/local/go
export GOPATH=/usr/local
GO=$(GOROOT)/bin/go

all: sql-bench-go
clean:
	rm -f sql-bench-go sql-bench-c

sql-bench-go: sql-bench.go
	$(GO) build -o sql-bench-go sql-bench.go
