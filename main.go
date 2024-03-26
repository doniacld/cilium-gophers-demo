package main

import (
	_ "embed"
	"fmt"
	"log"
	"net/http"
	"os"
)

//go:embed gopher-ascii.txt
var gopherAsciiFile string

func main() {
	// Define a handler function for the root URL ("/")
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		// ASCII art image of a gopher traveling

		b, err := os.ReadFile("./gopher-ascii.txt")
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		_, err = w.Write(b)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)

			return
		}
	})

	// Start the HTTP server on port 8080
	fmt.Println("Server listening on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
