package routers

import (
	"cam_server/controllers"

	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &controllers.MainController{})
	beego.Router("/api/init_db", &controllers.ApiController{}, "get:InitDb")
	beego.Router("/api/get_publish_url", &controllers.ApiController{}, "get:GetPublishUrl")
	beego.Router("/api/new_device", &controllers.ApiController{}, "get:NewDevice")
	beego.Router("/api/del_device", &controllers.ApiController{}, "get:DelDevice")
	beego.Router("/api/get_hlsplay_url", &controllers.ApiController{}, "get:GetHlsPlayUrl")
	beego.Router("/api/start_stream", &controllers.ApiController{}, "get:StartStream")
	beego.Router("/api/stop_stream", &controllers.ApiController{}, "get:StopStream")
	beego.Router("/api/get_status", &controllers.ApiController{}, "get:GetStatus")
	beego.Router("/api/list_stream", &controllers.ApiController{}, "get:ListStream")
	beego.Router("/api/list_segments", &controllers.ApiController{}, "get:ListSegments")
	beego.Router("/api/del_device", &controllers.ApiController{}, "get:DelDevice")
	beego.Router("/api/get_playback_url", &controllers.ApiController{}, "get:GetHlsPlayBackUrl")
	beego.Router("/api/get_video_cut", &controllers.ApiController{}, "get:GetVideoCut")
	beego.Router("/api/get_snot", &controllers.ApiController{}, "get:GetSnot")
	
}
