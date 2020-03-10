package main

import (
	"aidus_server/app"
	c "aidus_server/controllers"
	"github.com/gorilla/mux"
	"github.com/prometheus/common/log"
	"net/http"
	"os"
)

func main() {

	router := mux.NewRouter()

	router.HandleFunc("/api/admin/create/group", c.CreateGroup).Methods("POST")
	router.HandleFunc("/api/admin/create/parent", c.CreateParentService).Methods("POST")
	router.HandleFunc("/api/admin/create/service", c.CreateService).Methods("POST")
	router.HandleFunc("/api/admin/create/account", c.CreateAccount).Methods("POST")

	router.HandleFunc("/api/user/login", c.Authenticate).Methods("POST")
	router.HandleFunc("/api/user/refresh", c.RefreshAuthToken).Methods("POST")

	router.HandleFunc("/api/issues", c.GetIssues).Methods("GET")
	router.HandleFunc("/api/issue/{id}", c.GetIssue).Methods("GET")
	router.HandleFunc("/api/workers", c.GetUsers).Methods("GET")
	router.HandleFunc("/api/groups", c.GetGroups).Methods("GET")
	router.HandleFunc("/api/story", c.GetEvents).Methods("GET")

	router.HandleFunc("/api/webhook/alert", c.SaveIssue).Methods("POST")

	router.HandleFunc("/api/issue/fix", c.PostFix).Methods("POST").Headers("Content-Type", "application/x-www-form-urlencoded")
	router.HandleFunc("/api/issue/redirect", c.PostRedirect).Methods("POST").Headers("Content-Type", "application/x-www-form-urlencoded")
	router.HandleFunc("/api/issue/redirect/answer", c.PostRedirectAnswer).Methods("POST").Headers("Content-Type", "application/x-www-form-urlencoded")
	router.HandleFunc("/api/issue/accept", c.PostAccept).Methods("POST").Headers("Content-Type", "application/x-www-form-urlencoded")
	router.HandleFunc("/api/issue/close", c.PostClose).Methods("POST").Headers("Content-Type", "application/x-www-form-urlencoded")

	//todo: change url in front

	router.Use(app.Authentication)
	router.Use(app.CheckRightForIssue)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8000"
	}

	log.Info("port: ", port)

	err := http.ListenAndServe(":"+port, router)
	if err != nil {
		log.Error(err.Error())
	}
}
