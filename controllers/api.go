package controllers

import (
	"cam_server/models"
	//	"encoding/json"
	"errors"
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/pili-engineering/pili-sdk-go/pili"
//	"reflect"
)

const (
	ACCESS_KEY = "_dJU6nq83rkE-NMYuQxg5b6my7vslNTJyNeMxYpD"
	SECRET_KEY = "k2r_CC4blZM-sKvJxRaxtn-jK7LnokyegPKkNBDl"
	HUB_NAME   = "linqibin"
)

type ApiController struct {
	beego.Controller
}

const resSucess string = "success"
const resFail string = "fail"

/*
type operationState struct {
	op_name string
	op_state string
}


func newOpState(name string, state string) * operationState{
	return &operationState{name, state}
}
*/
func CreateDataBase() error {
	name := "default"
	force := true
	verbose := true
	err := orm.RunSyncdb(name, force, verbose)
	if nil != err {
		beego.Error(err)
		return err
	}
	return nil
}

func (c *ApiController) responseWithState(state string, args ...interface{}) {

	argMap := make(map[string]interface{})
	argMap["state"] = state

	if args != nil {
		argMap["result"] = args
	}
	c.Data["json"] = argMap
	c.ServeJson()
}

func (c *ApiController) getPiliStreamByName(streamName string) (stream pili.Stream, err error) {
	cam, err := c.getCamByStreamName(streamName)
	if err != nil {
		return stream, err
	}
	credentials := pili.NewCredentials(ACCESS_KEY, SECRET_KEY)

	hub := pili.NewHub(credentials, HUB_NAME)
	stream, err = hub.GetStream(cam.StreamId)

	return stream, err
}

func (c *ApiController) deleteAllStream() error {
	var cams []*models.CameraStreams
	o := orm.NewOrm()
	num, err := o.QueryTable("CameraStreams").All(&cams)
	if err != nil {
		return err
	}
	if num == 0 {
		return nil
	}

	for i := 0; int64(i) < num; i++ {
		stream, err := c.getPiliStreamByName(cams[i].StreamName)
		if err != nil {
			beego.Debug("getPiliStreamByName")
			return err
		}
		if _, err = stream.Delete(); err != nil {
			beego.Debug("Delete")
			return err
		}
	}
	return nil

}
func (c *ApiController) InitDb() {

	c.deleteAllStream()

	err := CreateDataBase()

	//c.Data["json"] = map[string]interface{}{"stream_name": cam.StreamName, "publish_url": cam.PublishUrl}
	//c.ServeJson()

	if err != nil {
		//c.Ctx.WriteString("Init db error")
		c.responseWithState(resFail)
		return
	}

	c.responseWithState(resSucess)
}

func (c *ApiController) setStreamInformation(stream *pili.Stream, cam *models.CameraStreams) {

	LiveHlsUrl, _ := stream.HlsLiveUrls()

	cam.LiveHlsUrl = LiveHlsUrl["ORIGIN"]
	cam.PublishKey = stream.PublishKey
	cam.PublishUrl = stream.RtmpPublishUrl()
	cam.StreamId = stream.Id
	cam.StreamState = stream.Disabled
}

func (c *ApiController) delCamByStreamName(name string) error {
	cam, err := c.getCamByStreamName(name)
	if err != nil {
		return err
	}

	o := orm.NewOrm()

	num, err := o.Delete(cam)

	if err != nil {
		return err
	}

	if num != 1 {
		beego.Warn("num != 1  maybe error happen")
	}

	return nil
}

func (c *ApiController) DelDevice() {
	beego.Debug("DelDevice")
	streamName := c.GetString("stream_name", "")

	deviceName := c.GetString("device_name", "")

	if streamName == "" || deviceName == "" {
		c.responseWithState(resFail)
		return
	}

	stream, err := c.getPiliStreamByName(streamName)

	if err != nil {
		beego.Error(err, "	streamName:"+streamName)
		c.responseWithState(resFail)
		return
	}

	_, err = stream.Delete()

	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}

	err = c.delCamByStreamName(streamName)
	if nil != err {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}

	c.responseWithState(resSucess)
}
func (c *ApiController) NewDevice() {
	beego.Debug("NewDevice")

	deviceName := c.GetString("device_name", "")
	streamName := c.GetString("stream_name", "")
	if deviceName == "" || streamName == "" {
		c.responseWithState(resFail)
		return
	}

	o := orm.NewOrm()
	exist := o.QueryTable("CameraStreams").Filter("StreamName", streamName).Exist()
	exist = exist || o.QueryTable("CameraStreams").Filter("DeviceId", deviceName).Exist()
	if exist {
		c.responseWithState(resFail)
		return
	}

	credentials := pili.NewCredentials(ACCESS_KEY, SECRET_KEY)
	hub := pili.NewHub(credentials, HUB_NAME)

	// Create a new stream
	options := pili.OptionalArguments{ // optional
		Title:           streamName, // optional, auto-generated as default
		PublishKey:      "",         // optional, auto-generated as default
		PublishSecurity: "static",   // optional, can be "dynamic" or "static", "dynamic" as default
	}
	stream, err := hub.CreateStream(options)
	if err != nil {
		c.responseWithState(resFail)
		beego.Error(err)
		return
	}

	beego.Debug("stream_state!!!!!! :", stream.Disabled)

	camera := new(models.CameraStreams)
	camera.DeviceId = deviceName
	camera.StreamName = streamName
	camera.StreamState = false
	c.setStreamInformation(&stream, camera)

	beego.Debug(camera)

	_, err = o.Insert(camera)

	if err != nil {
		c.responseWithState(resFail)
		stream.Delete()
		beego.Error(err)
		return
	}

	c.responseWithState(resSucess)
}

func (c *ApiController) getCamByStreamName(streamName string) (*models.CameraStreams, error) {
	var cams []*models.CameraStreams
	o := orm.NewOrm()
	num, err := o.QueryTable("CameraStreams").Filter("StreamName", streamName).All(&cams)

	if err != nil {
		return nil, err
	}
	if num == 0 {
		return nil, errors.New("No such device")
	}
	return cams[0], nil
}

func (c *ApiController) GetPublishUrl() {
	beego.Debug("GetPublishHandler")

	streamName := c.GetString("stream_name", "")

	if "" == streamName {
		c.responseWithState(resFail)
		return
	}
	beego.Debug(streamName)

	cam, err := c.getCamByStreamName(streamName)

	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}

	beego.Debug(*cam)

	c.responseWithState(resSucess, map[string]interface{}{"stream_name": cam.StreamName, "publish_url": cam.PublishUrl})
	return
}

func (c *ApiController) GetHlsPlayUrl() {
	beego.Debug("GetHlsPlayUrl")

	streamName := c.GetString("stream_name", "")
	if "" == streamName {
		beego.Error("Error happen")
		c.responseWithState(resFail)
		return
	}

	cam, err := c.getCamByStreamName(streamName)

	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}
	c.responseWithState(resSucess, map[string]interface{}{"stream_name": cam.StreamName, "hls_playlive_url": cam.LiveHlsUrl})
}

func (c *ApiController) GetHlsPlayBackUrl() {
	beego.Debug("GetHlsPlayBackUrl")
	streamName := c.GetString("stream_name", "")
	start, err0 := c.GetInt64("start")
	end, err1 := c.GetInt64("end")
	if "" == streamName || err0 != nil || err1 != nil {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}

	stream, err := c.getPiliStreamByName(streamName)
	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}
	
	urls := make(map[string]string)
	urls["ORIGIN"] = fmt.Sprintf("http://%s/%s/%s.m3u8", stream.Hosts.Playback["hls"], stream.Hub, stream.Title)
	urls["start"] =  fmt.Sprintf("%d", start)
	urls["end"] =  fmt.Sprintf("%d", end)
	
	/*
	urls, err := stream.HlsPlaybackUrls(int64(start), int64(end))
	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}
	*/
	beego.Debug(urls)
	c.responseWithState(resSucess, map[string]interface{}{"stream_name": streamName, "hls_playback_url": urls})
	return
}


func (c * ApiController) GetVideoCut() {
	beego.Debug("GetVideoCut")
	
	streamName := c.GetString("stream_name", "")
	videoName   := c.GetString("video_name", "")
	streamFormat   := c.GetString("video_format", "")
	start, err1 := c.GetInt32("start")
	end, err2 := c.GetInt32("end")
	if (streamName == "" || streamFormat == "" || err1 != nil || err2 != nil) {
		beego.Error(err1, err2)
		c.responseWithState(resFail)	
		return
	}
	
	stream, err := c.getPiliStreamByName(streamName)
	

	if (err != nil) {
		beego.Debug(err)
		c.responseWithState(resFail)
		return		
	}	
	options := pili.OptionalArguments{
	//	NotifyUrl: "http://remote_callback_url",
	} // optional
	saveAsRes, err := stream.SaveAs(videoName, streamFormat, int64(start), int64(end), options)
	if err != nil {
		fmt.Println("Error:", err)
	}
	
	beego.Debug("saveAsRes:", saveAsRes)
	
	c.responseWithState(resSucess, map[string]interface{}{"stream_name": streamName, "save_result": saveAsRes})
	
}

func (c *ApiController) GetSnot() {
	beego.Debug("GetSnot")

	streamName := c.GetString("stream_name", "")
	picName := c.GetString("pic_name", "")
	picFormat := c.GetString("pic_format", "")
	time, err := c.GetInt64("time")
	notifyUrl := c.GetString("notify_url", "")

	if "" == streamName || "" == picName || picFormat == "" {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}
	stream, err := c.getPiliStreamByName(streamName)
	

	if (err != nil) {
		beego.Debug(err)
		c.responseWithState(resFail)
		return		
	}	
	
	options := pili.OptionalArguments{
		Time:      time, // optional, int64, in second, unit timestamp
		NotifyUrl: notifyUrl,
	}

	snapshotRes, err := stream.Snapshot(picName, picFormat, options)
	if err != nil {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}
	c.responseWithState(resSucess, map[string]interface{}{"target_url": snapshotRes.TargetUrl, "persist_id": snapshotRes.PersistentId})
	return
}

func (c *ApiController) updateCamState(streamName string, state bool) error {
	cam, err := c.getCamByStreamName(streamName)
	if err != nil {
		return err
	}
	cam.StreamState = state

	_, err = orm.NewOrm().Update(cam)
	if err != nil {
		beego.Error(err)
		return err
	}
	return nil
}

func (c *ApiController) StartStream() {
	beego.Debug("StartStream")

	streamName := c.GetString("stream_name", "")

	if "" == streamName {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}
	stream, err := c.getPiliStreamByName(streamName)
	if nil != err {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}

	beego.Debug("stream_state:", stream.Disabled)

	stream, err = stream.Enable()

	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
	}

	err = c.updateCamState(streamName, true)
	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
	}

	c.responseWithState(resSucess)

}

func (c *ApiController) StopStream() {
	beego.Debug("StopStream")
	streamName := c.GetString("stream_name", "")
	if "" == streamName {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}
	stream, err := c.getPiliStreamByName(streamName)
	if nil != err {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}
	stream, err = stream.Disable()
	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}

	err = c.updateCamState(streamName, false)
	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
	}

	c.responseWithState(resSucess)
}

func (c *ApiController) ListStream() {
	beego.Debug("ListStream")

	var cams []*models.CameraStreams
	o := orm.NewOrm()
	num, err := o.QueryTable("CameraStreams").All(&cams)

	if err != nil || num == 0 {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}
	c.responseWithState(resSucess, map[string]interface{}{"streams": cams})
	return
}

func (c *ApiController) ListSegments() {
	beego.Debug("ListSegments")

	streamName := c.GetString("stream_name", "")
	if "" == streamName {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}
	start, _ := c.GetInt64("start")
	end, _ := c.GetInt64("end")
	limit, _ := c.GetInt64("limit")

	beego.Debug(streamName, start, end, limit)

	stream, err := c.getPiliStreamByName(streamName)
	if nil != err {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}
	beego.Debug("Param is", start, end, limit)
	options := pili.OptionalArguments{ // optional
		Start: start,       // optional, in second, unix timestamp
		End:   end,         // optional, in second, unix timestamp
		Limit: uint(limit), // optional, uint
	}
	segments, err := stream.Segments(options)

	
	if err != nil {
		beego.Error(err)
		c.responseWithState(resFail)
		return
	}
	c.responseWithState(resSucess, map[string]interface{}{"segments": segments})

	return

}

func (c *ApiController) GetStatus() {
	beego.Debug("GetStatus")
	streamName := c.GetString("stream_name", "")
	if "" == streamName {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}

	stream, err := c.getPiliStreamByName(streamName)

	if err != nil {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}
	status, err := stream.Status()

	if err != nil {
		beego.Error("Param error")
		c.responseWithState(resFail)
		return
	}
	c.responseWithState(resSucess, map[string]interface{}{"status": status})

	return
}
