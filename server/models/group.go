package models

import (
	"net/http"
	"strconv"
)

type Group struct {
	ID   uint
	Name string `gorm:"unique;not null"`
	//Accounts []Account `json:"-"`
	//Services []Service `json:"-"`
}

func (g *Group) Create() (string, int) {
	err := GetDB().Create(&g).Error
	if err != nil {
		return err.Error(), http.StatusInternalServerError
	}
	return strconv.Itoa(int(g.ID)), http.StatusOK
}

func GetGroups() ([]*Group, error) {
	groups := make([]*Group, 0)
	err := GetDB().Find(&groups).Error
	return groups, err
}
