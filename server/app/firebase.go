package app

import (
	"context"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"
	"github.com/prometheus/common/log"
	"google.golang.org/api/option"
)

var fcmClient *messaging.Client

func init() {
	opt := option.WithCredentialsFile("firebase_key.json")
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		log.Error(err.Error())
		return
	}
	fcmClient, err = app.Messaging(context.Background())
	if err != nil {
		log.Error(err.Error())
	}
}

func SendNotification(mobileTokens []string, priority string, title string) error {
	message := &messaging.MulticastMessage{
		Notification: &messaging.Notification{
			Title: title,
			Body:  "Приоритет: " + priority,
		},
		Data: map[string]string{
			"click_action": "FLUTTER_NOTIFICATION_CLICK",
			"id":           "1",
			"status":       "done",
		},
		Tokens: mobileTokens,
	}
	br, err := fcmClient.SendMulticast(context.Background(), message)
	if err != nil {
		log.Error(err.Error())
		return err
	}
	log.Info("Messaging: success - ", br.SuccessCount, ", failure - ", br.FailureCount)
	return nil
}
