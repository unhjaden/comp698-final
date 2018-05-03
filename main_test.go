package main

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHandler(t *testing.T) {
	request, _ := http.NewRequest("GET", "/", nil)
	response := httptest.NewRecorder()
	hello(response, request)

	expected := "Hello, World!"
	if response.Body.String() != expected {
		t.Fatalf("Got: %s\nExpected: %s",
			response.Body.String(), expected)
	}
}