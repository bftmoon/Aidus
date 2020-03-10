package controllers

import (
	"aidus_server/models"
	u "aidus_server/utils"
	"encoding/json"
	"net/http"
)

var Authenticate = func(w http.ResponseWriter, r *http.Request) {
	account := &models.Account{}
	err := json.NewDecoder(r.Body).Decode(account)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, "Invalid request")
		return
	}
	status, msg, tokens := models.Login(account)
	if tokens == nil {
		u.RespondMsgWithStatus(w, status, msg)
	} else {
		u.RespondJson(w, tokens)
	}
}

var RefreshAuthToken = func(w http.ResponseWriter, r *http.Request) {
	status, msg := models.RefreshAuth(u.GetUserId(r))
	u.RespondMsgWithStatus(w, status, msg)
}
