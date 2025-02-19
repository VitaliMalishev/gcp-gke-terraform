package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()
		version := os.Getenv("APP_VERSION")
		if version == "" {
			version = "1.0"
		}
		
		response := fmt.Sprintf("Hello World cluster endpoint \nVersion: %s\nHostname: %s\n", version, hostname)
		fmt.Fprint(w, response)
	})

	http.ListenAndServe(":8080", nil)
}
