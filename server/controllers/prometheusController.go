package controllers

import (
	"aidus_server/app"
	"aidus_server/models"
	u "aidus_server/utils"
	"encoding/json"
	"github.com/jinzhu/gorm"
	"github.com/prometheus/alertmanager/template"
	"github.com/prometheus/common/log"
	uuid "github.com/satori/go.uuid"
	"net/http"
)

var SaveIssue = func(w http.ResponseWriter, r *http.Request) {

	data := template.Data{}
	err := json.NewDecoder(r.Body).Decode(&data)
	if err != nil {
		u.RespondMsgWithStatus(w, http.StatusBadRequest, "")
		return
	}
	for _, alert := range data.Alerts {
		serviceUuid, err := uuid.FromString(alert.Labels["id"])
		if err != nil {
			serverError(w, err)
		}
		severity := alert.Labels["severity"]
		delete(alert.Labels, "id")
		delete(alert.Labels, "severity")
		labels, err := json.Marshal(alert.Labels)
		if err != nil {
			serverError(w, err)
			return
		}
		transaction := models.GetDB().Begin()
		if err = transaction.Error; err != nil {
			serverError(w, err)
			return
		}
		issueId, err := models.SaveIssueWithDB(alert.Annotations["summary"], serviceUuid, severity, labels, transaction)
		if err != nil {
			serverErrorWithRollback(w, err, transaction)
			return
		}
		groupId, err := models.GetGroupByServiceId(serviceUuid)
		if err != nil {
			serverErrorWithRollback(w, err, transaction)
			return
		}
		err = models.SaveEventWithDB(issueId, groupId, alert.Annotations["description"], models.EventOpened, transaction)
		if err != nil {
			serverErrorWithRollback(w, err, transaction)
			return
		}
		if err = transaction.Commit().Error; err != nil {
			serverErrorWithRollback(w, err, transaction)
			return
		}
		tokens, err := models.GetFcmTokens(groupId)
		if err != nil {
			serverError(w, err)
			return
		}
		if len(tokens) > 0 {
			err = app.SendNotification(tokens, severity, alert.Annotations["title"])
			if err != nil {
				serverError(w, err)
			}
		}
	}
}

func serverErrorWithRollback(w http.ResponseWriter, err error, t *gorm.DB) {
	log.Error(err.Error())
	t.Rollback()
	u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
}

func serverError(w http.ResponseWriter, err error) {
	log.Error(err.Error())
	u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
}
