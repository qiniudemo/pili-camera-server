package main

import (
	_ "cam_server/models"
	_ "cam_server/routers"

	"github.com/astaxie/beego"
)

func init() {
	beego.SetLevel(beego.LevelDebug)
}

func main() {
	beego.Run()
}
