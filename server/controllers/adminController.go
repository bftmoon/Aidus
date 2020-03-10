package controllers

import (
	"aidus_server/models"
	u "aidus_server/utils"
	"encoding/json"
	"github.com/google/uuid"
	"github.com/prometheus/common/log"
	"net/http"
)

var CreateAccount = func(w http.ResponseWriter, r *http.Request) {
	account := &models.Account{}
	err := json.NewDecoder(r.Body).Decode(account)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, err.Error())
		return
	}
	msg, status := account.Create()
	u.RespondMsgWithStatus(w, status, msg)
}

var CreateGroup = func(w http.ResponseWriter, r *http.Request) {
	group := &models.Group{}
	err := json.NewDecoder(r.Body).Decode(group)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, err.Error())
		return
	}
	msg, code := group.Create()
	u.RespondMsgWithStatus(w, code, msg)
}

var CreateService = func(w http.ResponseWriter, r *http.Request) {
	service := &models.Service{}
	err := json.NewDecoder(r.Body).Decode(service)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, err.Error())
		return
	}
	log.Warn(service)
	if service.ParentServiceID != nil {
		_, err = uuid.Parse(service.ParentServiceID.(string))
		if err != nil {
			u.RespondMsgWithStatus(w, http.StatusBadRequest, "Bad parent ID format")
			return
		}
	}
	msg, code := service.Create()
	u.RespondMsgWithStatus(w, code, msg)
}

var CreateParentService = func(w http.ResponseWriter, r *http.Request) {
	service := &models.ParentService{}
	err := json.NewDecoder(r.Body).Decode(service)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, err.Error())
		return
	}
	msg, code := service.Create()
	u.RespondMsgWithStatus(w, code, msg)
}
