package models

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	_ "github.com/mattn/go-sqlite3"
)

type CameraStreams struct {
	Id          int
	DeviceId    string `orm:"unique"`
	StreamName  string `orm:"unique"`
	StreamId    string
	PublishUrl  string
	LiveHlsUrl  string
	PublishKey  string
	StreamState bool // ture enable    false not
}

func init() {
	orm.RegisterDriver("sqlite", orm.DR_Sqlite)
	orm.RegisterDataBase("default", "sqlite3", "data.db")
	orm.RegisterModel(new(CameraStreams))
	beego.Debug("init")
}
