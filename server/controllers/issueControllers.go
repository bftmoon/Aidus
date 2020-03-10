package controllers

import (
	"aidus_server/models"
	u "aidus_server/utils"
	"github.com/gorilla/mux"
	"github.com/jinzhu/gorm"
	"github.com/prometheus/common/log"
	"net/http"
	"strconv"
)

var GetIssues = func(w http.ResponseWriter, r *http.Request) {
	start, err := strconv.ParseUint(r.URL.Query()["start"][0], 10, 64)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, "Bad 'start' param")
		return
	}
	limit, err := strconv.ParseUint(r.URL.Query()["limit"][0], 10, 64)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, "Bad 'limit' param")
		return
	}
	statusMas := r.URL.Query()["status"]
	log.Info(statusMas)
	var data []*models.IssueForList
	if len(statusMas) != 1 {
		data, err = models.GetIssuesList(start, limit, u.GetUserId(r), u.GetGroupId(r))
	} else {
		data, err = models.GetIssuesListWithStatus(start, limit, u.GetUserId(r), u.GetGroupId(r), statusMas[0])
	}
	if err != nil && err != gorm.ErrRecordNotFound {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
		return
	}
	u.RespondJson(w, data)
}

var GetIssue = func(w http.ResponseWriter, r *http.Request) {
	data, err := models.GetIssue(mux.Vars(r)["id"])
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
		return
	}
	u.RespondJson(w, data)
}
