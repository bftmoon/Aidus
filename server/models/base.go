package models

import (
	"fmt"
	"github.com/jinzhu/gorm"
	_ "github.com/jinzhu/gorm/dialects/postgres"
	"github.com/joho/godotenv"
	"golang.org/x/crypto/bcrypt"
	"os"
)

var db *gorm.DB

func init() {

	e := godotenv.Load()
	if e != nil {
		fmt.Print(e)
	}

	username := os.Getenv("db_user")
	password := os.Getenv("db_pass")
	dbName := os.Getenv("db_name")
	dbHost := os.Getenv("db_host")

	dbUri := fmt.Sprintf("host=%s user=%s dbname=%s sslmode=disable password=%s", dbHost, username, dbName, password)
	fmt.Println(dbUri)

	conn, err := gorm.Open("postgres", dbUri)
	if err != nil {
		fmt.Print(err)
	}

	db = conn
	db.LogMode(true)

	db.Debug().AutoMigrate(
		&Account{},
		&Event{},
		&Group{},
		&Issue{},
		&ParentService{},
		&Service{},
	)

	if os.Getenv("with_default_admin") == "true" {
		createDefaultUser()
	}
}

func GetDB() *gorm.DB {
	return db
}

func createDefaultUser() {
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte("adminpassw"), bcrypt.DefaultCost)
	db.Save(&Group{
		ID:   1,
		Name: "default",
	})
	db.Save(&Account{
		ID:       1,
		Login:    "admin",
		IsAdmin:  true,
		Password: string(hashedPassword),
		GroupID:  1,
	})
}
