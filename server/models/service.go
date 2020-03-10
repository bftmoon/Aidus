package models

import (
	"errors"
	"github.com/jinzhu/gorm"
	"github.com/satori/go.uuid"
	"net/http"
)

type Service struct {
	ID uuid.UUID `gorm:"type:uuid;primary_key;"`
	//Issues          []Issue
	GroupID uint `gorm:"not null"`
	//ParentServiceID uuid.UUID `gorm:"type:uuid"`
	ParentServiceID interface{} // for null variant
}

func (s *Service) BeforeCreate(scope *gorm.Scope) error {
	return scope.SetColumn("ID", uuid.NewV4())
}

func (s *Service) Create() (string, int) {
	err := GetDB().Create(&s).Error
	if err != nil {
		return err.Error(), http.StatusInternalServerError
	}
	return s.ID.String(), http.StatusOK
}

func GetGroupByServiceId(serviceId uuid.UUID) (uint, error) {
	var groupId []uint
	err := GetDB().Table("services").Where("id=?", serviceId).Pluck("group_id", &groupId).Error
	if err != nil {
		return 0, err
	}
	if len(groupId) == 0 {
		return 0, errors.New("group not found")
	}
	return groupId[0], nil
}
