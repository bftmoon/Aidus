package models

import (
	"errors"
	"github.com/jinzhu/gorm"
	"github.com/satori/go.uuid"
	"time"
)

type Event struct {
	ID       uuid.UUID `gorm:"type:uuid;primary_key;"`
	IssueID  uuid.UUID `gorm:"type:uuid;not null"`
	OwnerID  uint      `gorm:"not null"` // user or group
	Type     string    `sql:"type:event_type"`
	Info     string
	DateTime time.Time `gorm:"not null"`
}

func (e *Event) BeforeCreate(scope *gorm.Scope) error {
	return scope.SetColumn("ID", uuid.NewV4())
}

func SaveEvent(issueId uuid.UUID, userId uint, info string, eventType string) error {
	return SaveEventWithDB(issueId, userId, info, eventType, GetDB())
}

func SaveEventWithDB(issueId uuid.UUID, userId uint, info string, eventType string, db *gorm.DB) error {
	return db.Save(&Event{
		IssueID:  issueId,
		OwnerID:  userId,
		Type:     eventType,
		Info:     info,
		DateTime: time.Now(),
	}).Error
}

func GetIssueEvents(issueId string) ([]*Event, error) {
	var events []*Event
	err := GetDB().Where("issue_id=?", issueId).Order("date_time").Find(&events).Error
	return events, err
}

func GetRedirectInitiatorId(issueId uuid.UUID) (uint, error) {
	var lastOwnerId []uint
	err := GetDB().Table("events").Where("issue_id=?", issueId).Offset(1).Limit(1).Order("date_time", true).Pluck("owner_id", &lastOwnerId).Error
	if err != nil {
		return 0, err
	}
	if len(lastOwnerId) == 0 {
		return 0, errors.New("last owner not found")
	}
	return lastOwnerId[0], nil
}

func CheckBelongIssue(userId uint, issueId string) (bool, error) {
	var hasRightsFlag []bool
	err := GetDB().Raw(`
select true
from events
where owner_id=?
  and issue_id=?
order by date_time desc
limit 1
`, userId, issueId).Scan(&hasRightsFlag).Error
	if err != nil {
		return false, err
	}
	return len(hasRightsFlag) == 1, nil
}
