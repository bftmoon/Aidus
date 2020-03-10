package models

import (
	"github.com/dgrijalva/jwt-go"
	"github.com/jinzhu/gorm"
	"github.com/prometheus/common/log"
	"golang.org/x/crypto/bcrypt"
	"net/http"
	"os"
	"time"
)

type UserForList struct {
	ID   uint
	Name string
	//Surname    string
	//Patronymic string
}

type Account struct {
	ID         uint
	Login      string `gorm:"unique;not null"`
	Name       string `gorm:"not null"`
	Surname    string `gorm:"not null"`
	Patronymic string
	IsAdmin    bool
	Password   string `gorm:"not null"`
	GroupID    uint   `gorm:"not null"`
	Services   []Service
	//FcmToken   string
	FcmToken interface{}
}

func (account *Account) Validate() (string, int) {
	if len(account.Password) < 10 {
		return "Password min length is 10", http.StatusBadRequest
	}
	temp := &Account{}
	err := GetDB().Table("accounts").Where("login = ?", account.Login).First(temp).Error
	if err != nil && err != gorm.ErrRecordNotFound {
		log.Error(err.Error())
		return "Connection error", http.StatusInternalServerError
	}
	if temp.Login != "" {
		return "Login already in use by another user", http.StatusBadRequest
	}
	return "", http.StatusOK
}

func (account *Account) Create() (string, int) {
	if resp, status := account.Validate(); status != http.StatusOK {
		return resp, status
	}
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(account.Password), bcrypt.DefaultCost)
	account.Password = string(hashedPassword)
	err := GetDB().Create(account).Error
	if err != nil {
		log.Error(err.Error())
		return err.Error(), http.StatusInternalServerError
	}
	t, err := prepareAuthToken(account)
	if err != nil {
		log.Error(err.Error())
		return "Token creation failed", http.StatusInternalServerError
	}
	return t, http.StatusOK
}

func Login(accountData *Account) (int, string, map[string]string) {

	account := &Account{}
	err := GetDB().Where("login = ?", accountData.Login).First(account).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return http.StatusForbidden, "Login not found", nil
		}
		log.Error(err.Error())
		return http.StatusInternalServerError, "Connection error", nil
	}
	err = bcrypt.CompareHashAndPassword([]byte(account.Password), []byte(accountData.Password))
	if err != nil && err == bcrypt.ErrMismatchedHashAndPassword {
		return http.StatusForbidden, "Invalid login credentials", nil
	}
	tokens := make(map[string]string, 2)
	tokens["authToken"], err = prepareAuthToken(account)
	if err != nil {
		log.Error(err.Error())
		return http.StatusInternalServerError, "", nil
	}
	tokens["refreshToken"], err = prepareRefreshToken(account)
	if err != nil {
		log.Error(err.Error())
		return http.StatusInternalServerError, "", nil
	}
	account.FcmToken = accountData.FcmToken
	err = GetDB().Save(account).Error
	if err != nil {
		log.Error(err.Error())
		return http.StatusInternalServerError, "", nil
	}
	return http.StatusOK, "", tokens
}

func GetUsersForGroup(groupId uint64) ([]*UserForList, error) {
	users := make([]*UserForList, 0)
	err := GetDB().Table("accounts").Select("id, concat(name, ' ', surname) as name").Where("group_id=?", groupId).Scan(&users).Error
	return users, err
}

func GetUsers() ([]*UserForList, error) {
	users := make([]*UserForList, 0)
	err := GetDB().Table("accounts").Select("id, concat(name, ' ', surname) as name").Scan(&users).Error
	return users, err
}

func GetFcmTokens(groupId uint) ([]string, error) {
	var fcmTokens []string
	err := GetDB().Table("accounts").Where("group_id=? and fcm_token is not null", groupId).Pluck("fcm_token", &fcmTokens).Error
	return fcmTokens, err
}

func RefreshAuth(userId uint) (int, string) {
	user := &Account{ID: userId}
	err := GetDB().Find(user).Error
	if err != nil {
		return http.StatusInternalServerError, ""
	}
	authToken, err := prepareAuthToken(user)
	if err != nil {
		return http.StatusInternalServerError, ""
	}
	return http.StatusOK, authToken
}

func prepareAuthToken(account *Account) (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id"] = account.ID
	claims["is_auth"] = true
	claims["group_id"] = account.GroupID
	claims["admin"] = account.IsAdmin
	claims["exp"] = time.Now().Add(time.Minute * 5).Unix()
	return token.SignedString([]byte(os.Getenv("token_password")))
}

func prepareRefreshToken(account *Account) (string, error) {
	token := jwt.New(jwt.SigningMethodHS256)
	claims := token.Claims.(jwt.MapClaims)
	claims["id"] = account.ID
	claims["is_auth"] = false
	claims["exp"] = time.Now().Add(time.Hour * 72).Unix()
	return token.SignedString([]byte(os.Getenv("token_password")))
}
