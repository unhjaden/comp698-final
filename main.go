package main

import (
	"io"
	"log"
	"net/http"
)

func hello(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "Hello, World!")
}

func main() {
	http.HandleFunc("/", hello)
	log.Fatal(http.ListenAndServe(":80", nil))
}