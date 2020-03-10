package utils

import (
	"encoding/json"
	"github.com/prometheus/common/log"
	"net/http"
)

func RespondJson(w http.ResponseWriter, data interface{}) {
	err := json.NewEncoder(w).Encode(data)
	if err != nil {
		log.Error(err.Error())
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Header().Add("Content-Type", "application/json")
}

func RespondMsgWithStatus(w http.ResponseWriter, statusCode int, msg string) {
	w.WriteHeader(statusCode)
	if msg != "" {
		err := json.NewEncoder(w).Encode(msg)
		if err != nil {
			log.Error(err.Error())
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		w.Header().Add("Content-Type", "text/plain")
	}
}
