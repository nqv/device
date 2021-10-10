package main

import (
	"flag"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"golang.org/x/net/webdav"
)

const webdavPath = "/webdav/"

func main() {
	root := flag.String("root", ".", "root directory")
	addr := flag.String("addr", "", "listen address e.g. :http, :8080, 127.0.0.1:8080")
	user := flag.String("user", "", "user authentication in format username:password")
	cert := flag.String("cert", "", "tls certificate file")
	key := flag.String("key", "", "tls key file")
	verbose := flag.Bool("verbose", false, "log WebDAV errors")
	flag.Parse()

	wdHandler := &webdav.Handler{
		Prefix:     webdavPath,
		FileSystem: webdav.Dir(*root),
		LockSystem: webdav.NewMemLS(),
	}
	if *verbose {
		wdHandler.Logger = func(r *http.Request, err error) {
			if err != nil {
				log.Printf("%s %s: %s", r.Method, r.URL.Path, err)
			}
		}
	}
	if *user == "" {
		http.Handle(webdavPath, wdHandler)
	} else {
		http.HandleFunc(webdavPath, func(w http.ResponseWriter, r *http.Request) {
			u, p, ok := r.BasicAuth()
			if !ok || u+":"+p != *user {
				w.Header().Set("WWW-Authenticate", "Basic realm=\"WebDAV\"")
				w.WriteHeader(http.StatusUnauthorized)
				w.Write([]byte("Unauthorized"))
				return
			}
			wdHandler.ServeHTTP(w, r)
		})
	}
	server := http.Server{Addr: *addr}
	sigCh := make(chan os.Signal, 2)
	signal.Notify(sigCh, os.Interrupt, syscall.SIGQUIT)
	go func() {
		<-sigCh
		server.Close()
	}()
	var err error
	if *cert == "" || *key == "" {
		err = server.ListenAndServe()
	} else {
		err = server.ListenAndServeTLS(*cert, *key)
	}
	if err != nil {
		log.Fatal(err)
	}
}
