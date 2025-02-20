package main

import (
    "fmt"
    "net/http"
    "os"
    "io/ioutil"
)

func readVersion() string {
    version := "1.0" 
    data, err := ioutil.ReadFile("VERSION")
    if err == nil {
        version = string(data)
    }
    return version
}

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        hostname, _ := os.Hostname()
        version := os.Getenv("APP_VERSION")
        if version == "" {
            version = readVersion()
        }

        response := fmt.Sprintf("Github  \nVersion: %s\nHostname: %s\n", version, hostname)
        fmt.Fprint(w, response)
    })

    http.ListenAndServe(":8080", nil)
}
