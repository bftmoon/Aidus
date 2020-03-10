package models

import (
	"encoding/json"
	"github.com/jinzhu/gorm"
	"github.com/jinzhu/gorm/dialects/postgres"
	"github.com/satori/go.uuid"
	"time"
)

type Issue struct {
	ID        uuid.UUID `gorm:"type:uuid;primary_key;"`
	Title     string    `gorm:"not null"`
	ServiceID uuid.UUID `gorm:"type:uuid; not null"`
	Severity  string    `sql:"type:severity";gorm:"not null"`
	Labels    postgres.Jsonb
}

type IssueJson struct {
	ID    uuid.UUID
	Title string
	//ServiceID uuid.UUID
	Severity string
	Labels   postgres.Jsonb

	Description      string
	OpenedAt         time.Time
	UpdatedAt        time.Time
	Status           string
	ParentServiceURL string
}

type IssueForList struct {
	ID        uuid.UUID
	Title     string
	Severity  string
	Status    string
	UpdatedAt time.Time
}

func (issue *Issue) BeforeCreate(scope *gorm.Scope) error {
	return scope.SetColumn("ID", uuid.NewV4())
}

func (i *IssueJson) AfterFind() (err error) {
	for _, value := range []string{EventAccepted, EventFix, EventDeclined} {
		if value == i.Status {
			i.Status = "in process"
			return
		}
	}
	return
}

func (i *IssueForList) AfterFind() (err error) {
	for _, value := range []string{EventAccepted, EventFix, EventDeclined} {
		if value == i.Status {
			i.Status = "in process"
			return
		}
	}
	return
}

func GetIssuesList(start uint64, limit uint64, userId uint, groupId uint) ([]*IssueForList, error) {
	issues := make([]*IssueForList, 0)
	//	err := GetDB().Table("issues").Raw(
	//		`
	//select i.id, title, severity, updated_at, e.type status
	//from (select issue_id, max(date_time) updated_at from events group by issue_id) last,
	//     events e,
	//     issues i
	//where e.issue_id = last.issue_id
	//  and updated_at = e.date_time
	//  and e.issue_id = i.id
	//  and (owner_id = ? and e.type = 'opened' or owner_id = ? and e.type != 'opened')
	//order by severity desc, updated_at desc offset ? limit ?
	//`, groupId, userId, start, limit).Find(&issues).Error
	err := GetDB().Table("issues i, events e, (select issue_id, max(date_time) updated_at from events group by issue_id) last").Select("i.id, title, severity, updated_at, e.type status").Where(" e.issue_id = last.issue_id and updated_at = e.date_time and e.issue_id = i.id and (owner_id = ? and e.type = 'opened' or owner_id = ? and e.type != 'opened')", groupId, userId).Order("severity desc, updated_at desc").Offset(start).Limit(limit).Find(&issues).Error
	return issues, err
}

func GetIssuesListWithStatus(start uint64, limit uint64, userId uint, groupId uint, status string) ([]*IssueForList, error) {
	issues := make([]*IssueForList, 0)
	query := GetDB().Table("issues i, events e, (select issue_id, max(date_time) updated_at from events group by issue_id) last").Select("i.id, title, severity, updated_at, e.type status").Where(" e.issue_id = last.issue_id and updated_at = e.date_time and e.issue_id = i.id and (owner_id = ? and e.type = 'opened' or owner_id = ? and e.type != 'opened')", groupId, userId).Order("severity desc, updated_at desc").Offset(start).Limit(limit)
	if status == "in process" {
		query = query.Where("e.type=? or e.type=? or e.type=?", EventDeclined, EventAccepted, EventFix)
	} else {
		query = query.Where("e.type=?", status)
	}
	err := query.Find(&issues).Error
	return issues, err
}

func GetIssue(issueId string) (*IssueJson, error) {
	issue := &IssueJson{}
	err := GetDB().Table("issues").Joins("join events o on issues.id=o.issue_id join events c on issues.id=c.issue_id join services s on service_id=s.id left join parent_services p on parent_service_id=p.id").Where("issues.id=? and o.type='opened'", issueId).Order("c.date_time desc").Select("issues.*, c.date_time updated_at, c.type Status, o.date_time opened_at, o.info description, url parent_service_url").Limit(1).Take(&issue).Error
	return issue, err
}

func SaveIssueWithDB(title string, serviceId uuid.UUID, severity string, labels []byte, db *gorm.DB) (uuid.UUID, error) {
	issue := &Issue{
		Title:     title,
		ServiceID: serviceId,
		Severity:  severity,
		Labels:    postgres.Jsonb{RawMessage: json.RawMessage(labels)},
	}
	err := db.Create(&issue).Error
	return issue.ID, err
}
