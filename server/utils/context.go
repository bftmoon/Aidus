package utils

import (
	"context"
	"github.com/dgrijalva/jwt-go"
	"github.com/prometheus/common/log"
	"net/http"
)

func GetUserId(r *http.Request) uint {
	return uint(r.Context().Value("id").(float64))
}

func GetGroupId(r *http.Request) uint {
	return uint(r.Context().Value("group_id").(float64))
}

func AddTokenDataToContext(t *jwt.Token, r *http.Request) *http.Request {
	log.Info("JWT Claims: ", t.Claims)
	claims := t.Claims.(jwt.MapClaims)
	r = r.WithContext(context.WithValue(r.Context(), "id", claims["id"]))
	if t.Claims.(jwt.MapClaims)["is_auth"].(bool) {
		r = r.WithContext(context.WithValue(r.Context(), "group_id", claims["group_id"]))
	}
	return r
}
