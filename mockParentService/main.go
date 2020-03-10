package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"syscall"
)

var fixesJson []byte

func main() {
	var fixes [5]FixInfo
	for i := 0; i < 5; i++ {
		fixes[i] = FixInfo{
			ID:   strconv.Itoa(i),
			Name: "Fix " + strconv.Itoa(i),
			Description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. ",
		}
	}
	fixesJson, _ = json.Marshal(fixes)
	fmt.Println("Start mock parent on port 5000")
	err := http.ListenAndServe(":5000", http.HandlerFunc(FixHandler))
	if err != nil {
		fmt.Print(err)
	}
}

func FixHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println(r.Method + " "+ r.URL.Path)
	switch r.URL.Path {
	case "/api/fix":
		if r.Method != "POST" {
			fmt.Println("Wrong method")
			w.WriteHeader(http.StatusBadRequest)
			return
		}
		body := &Body{}
		err := json.NewDecoder(r.Body).Decode(body)
		postBody, _ := json.Marshal(map[string]string{
			"issueId": body.IssueId,
			"fixName": "Restart event",
		})
		req, _ := http.NewRequest("POST", "http://localhost:8000/api/fix", bytes.NewBuffer(postBody))
		req.Header.Set("Authorization", r.Header.Get("Authorization"))
		res, err := http.DefaultClient.Do(req)
		if err != nil {
			fmt.Println(err.Error())
			w.WriteHeader(http.StatusBadRequest)
		}
		if res.StatusCode == http.StatusOK {
			fmt.Println("Main service OK")
			// do fix
			b, _ := syscall.ByteSliceFromString("Success event restart")
			w.Write(b[:len(b)-1])
		} else {
			fmt.Println(res.Status)
			w.WriteHeader(res.StatusCode)
		}
		break
	case "/api/fixes":
		if r.Method != "GET" {
			fmt.Println("Wrong method")
			w.WriteHeader(http.StatusBadRequest)
		}
		w.Write(fixesJson)
		break
	default:
		fmt.Println("Path not exist")
		w.WriteHeader(http.StatusNotFound)
	}
}

type Body struct {
	IssueId string
	FixId   string
}

type FixInfo struct {
	ID   string
	Name string
	Description string
}
