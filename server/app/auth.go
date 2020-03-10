package app

import (
	"aidus_server/models"
	u "aidus_server/utils"
	"github.com/dgrijalva/jwt-go"
	"github.com/google/uuid"
	"github.com/prometheus/common/log"
	"net/http"
	"os"
	"strings"
)

var Authentication = func(next http.Handler) http.Handler {

	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		log.Info(r.Method, ": ", r.URL.String(), ", Headers: ", r.Header)

		if r.URL.Path == "/api/user/login" || r.URL.Path == "/api/webhook/alert" {
			next.ServeHTTP(w, r)
			return
		}

		authHeader := r.Header.Get("Authorization")
		if authHeader == "" {
			u.RespondMsgWithStatus(w, http.StatusUnauthorized, "Missing auth data")
			return
		}
		splitted := strings.Split(authHeader, " ")
		if len(splitted) != 2 {
			u.RespondMsgWithStatus(w, http.StatusUnauthorized, "Invalid auth header")
			return
		}
		tokenData, err := jwt.Parse(splitted[1], func(token *jwt.Token) (interface{}, error) {
			return []byte(os.Getenv("token_password")), nil
		})

		if err != nil {
			log.Error(err.Error())
			u.RespondMsgWithStatus(w, http.StatusUnauthorized, "Invalid token")
			return
		}

		if strings.HasPrefix(r.URL.String(), "/api/admin") && !tokenData.Claims.(jwt.MapClaims)["admin"].(bool) {
			u.RespondMsgWithStatus(w, http.StatusForbidden, "Admin role required")
			return
		}
		if tokenData.Claims.(jwt.MapClaims)["is_auth"].(bool) {
			if r.URL.String() == "/api/user/refresh" {
				u.RespondMsgWithStatus(w, http.StatusUnauthorized, "Invalid refresh token")
				return
			}
		} else if r.URL.String() != "/api/user/refresh" {
			u.RespondMsgWithStatus(w, http.StatusUnauthorized, "Invalid auth token")
			return
		}
		next.ServeHTTP(w, u.AddTokenDataToContext(tokenData, r))
	})
}

func CheckRightForIssue(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if (r.Method == "POST" || r.Method == "PUT") && strings.HasPrefix(r.URL.String(), "/api/issue") {
			var ownerId uint
			if r.URL.String() == "/api/issue/accept" {
				ownerId = u.GetGroupId(r)
			} else {
				ownerId = u.GetUserId(r)
			}
			issueId := r.FormValue("issueId")
			if issueId == "" {
				u.RespondMsgWithStatus(w, http.StatusBadRequest, "Missing issue ID")
				return
			}
			if _, err := uuid.Parse(issueId); err != nil {
				u.RespondMsgWithStatus(w, http.StatusBadRequest, "Bad ID format")
				return
			}
			hasRights, err := models.CheckBelongIssue(ownerId, issueId)
			if err != nil {
				log.Error(err.Error())
				u.RespondMsgWithStatus(w, http.StatusInternalServerError, "")
				return
			}
			if !hasRights {
				u.RespondMsgWithStatus(w, http.StatusForbidden, "Issue not belong to this user")
			}
		}
		h.ServeHTTP(w, r)
	})
}
