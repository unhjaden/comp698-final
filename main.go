package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"time"
)

func IndexHandler(w http.ResponseWriter, r *http.Request) {
	data, err := ioutil.ReadFile("./static/html/index.html")
	if err != nil {
		fmt.Fprint(w, err)
	}
	http.ServeContent(w, r, "index.html", time.Now(), bytes.NewReader(data))
}

func main() {

	s := &http.Server{
		Addr:    ":80",
		Handler: nil,
	}

	http.Handle("/css/", http.StripPrefix("/css/", http.FileServer(http.Dir("./static/css"))))
	http.Handle("/js/", http.StripPrefix("/js/", http.FileServer(http.Dir("./static/js"))))
	http.HandleFunc("/home", IndexHandler)
	log.Fatal(s.ListenAndServe())

}