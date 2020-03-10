package models

import (
	"github.com/jinzhu/gorm"
	"github.com/satori/go.uuid"
	"net/http"
)

type ParentService struct {
	ID  uuid.UUID `gorm:"type:uuid;primary_key;"`
	Url string    `gorm:"not null"`
}

func (p *ParentService) BeforeCreate(scope *gorm.Scope) error {
	return scope.SetColumn("ID", uuid.NewV4())
}

func (p *ParentService) Create() (string, int) {
	err := GetDB().Create(&p).Error
	if err != nil {
		return err.Error(), http.StatusInternalServerError
	}
	return p.ID.String(), http.StatusOK
}
