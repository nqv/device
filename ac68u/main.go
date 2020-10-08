package main

import (
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	fs := http.FileServer(http.Dir("."))
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Printf("%v %v", r.Method, r.URL)
		fs.ServeHTTP(w, r)
	})
	srv := http.Server{
		Addr:    ":8080",
		Handler: handler,
	}
	if len(os.Args) > 1 {
		srv.Addr = os.Args[1]
	}

	sigCh := make(chan os.Signal, 2)
	signal.Notify(sigCh, os.Interrupt, syscall.SIGQUIT)
	go func() {
		<-sigCh
		srv.Close()
	}()

	log.Printf("Listening on %v...", srv.Addr)
	err := srv.ListenAndServe()
	if err != nil {
		log.Fatal(err)
	}
}
