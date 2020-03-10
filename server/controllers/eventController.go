package controllers

import (
	"aidus_server/models"
	"aidus_server/utils"
	u "aidus_server/utils"
	"github.com/prometheus/common/log"
	"github.com/satori/go.uuid"
	"net/http"
	"strconv"
)

var PostFix = func(w http.ResponseWriter, r *http.Request) {
	if fixName := r.FormValue("fixName"); fixName != "" {
		userId := utils.GetUserId(r)
		issueId, _ := uuid.FromString(r.FormValue("issueId"))
		if err := models.SaveEvent(issueId, userId, fixName, models.EventFix); err != nil {
			log.Error(err.Error())
			u.RespondMsgWithStatus(w, http.StatusInternalServerError, err.Error())
		}
	}
}

var GetEvents = func(w http.ResponseWriter, r *http.Request) {
	issueId := r.URL.Query()["issueId"][0]
	events, err := models.GetIssueEvents(issueId)
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
		return
	}
	u.RespondJson(w, events)
}

var PostRedirect = func(w http.ResponseWriter, r *http.Request) {
	issueId, _ := uuid.FromString(r.FormValue("issueId"))
	userToId, err := strconv.ParseUint(r.FormValue("userToId"), 10, 64)
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusBadRequest, "Bad user to id format")
		return
	}
	err = models.SaveEvent(issueId, uint(userToId), r.FormValue("description"), models.EventRedirect)
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
	}
}

var PostRedirectAnswer = func(w http.ResponseWriter, r *http.Request) {
	issueId, _ := uuid.FromString(r.FormValue("issueId"))
	var err error
	if r.FormValue("answer") == "true" {
		err = models.SaveEvent(issueId, u.GetUserId(r), "", models.EventAccepted)
	} else {
		lastOwnerId, err := models.GetRedirectInitiatorId(issueId)
		if err != nil {
			log.Error(err.Error())
			u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
			return
		}
		err = models.SaveEvent(issueId, lastOwnerId, "", models.EventDeclined)
	}
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
	}
}

var PostAccept = func(w http.ResponseWriter, r *http.Request) {
	issueId, _ := uuid.FromString(r.FormValue("issueId"))
	err := models.SaveEvent(issueId, u.GetUserId(r), "", models.EventAccepted)
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
	}
}

var PostClose = func(w http.ResponseWriter, r *http.Request) {
	issueId, _ := uuid.FromString(r.FormValue("issueId"))
	err := models.SaveEvent(issueId, u.GetUserId(r), r.FormValue("description"), models.EventClosed)
	if err != nil {
		log.Error(err.Error())
		u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
	}
}
