package controllers

import (
	"aidus_server/models"
	u "aidus_server/utils"
	"github.com/prometheus/common/log"
	"net/http"
	"strconv"
)

var GetUsers = func(w http.ResponseWriter, r *http.Request) {
	groupIdMas := r.URL.Query()["groupId"]
	var data []*models.UserForList
	var err error
	if len(groupIdMas) > 0 {
		groupId, err := strconv.ParseUint(groupIdMas[0], 10, 64)
		if err != nil {
			log.Error(err.Error())
			u.RespondMsgWithStatus(w, http.StatusBadRequest, "Bad id format")
			return
		}
		data, err = models.GetUsersForGroup(groupId)
	} else {
		data, err = models.GetUsers()
	}
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
		return
	}
	u.RespondJson(w, data)
}

var GetGroups = func(w http.ResponseWriter, r *http.Request) {
	data, err := models.GetGroups()
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
		return
	}
	u.RespondJson(w, data)
}
