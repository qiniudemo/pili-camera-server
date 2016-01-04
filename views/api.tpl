  	<!DOCTYPE html>

<html>
<head>
<script language="JavaScript" type="text/JavaScript" src="/static/js/jquery.min.js"> </script>

<script language="JavaScript" type="text/JavaScript">
	function hideFunc(elid) {
		var obj = document.getElementById(elid)
		obj.style.display="none"
	}

	function hideAll() {
		hideFunc("publish_url_show")
		//hideFunc("hlslive_url_show")
		//hideFunc("stream_status_show")
		hideFunc("segment_show")
		//hideFunc("list_stream_show")
		//hideFunc("playback_url_showss")
		//hideFunc("getsnot_show")
		//hideFunc("get_video_cut_show")
	}

	function makeHerf(src, name) {
		var obj = "<a href=\"" + src + ">" + name + "\a>"
		return obj
	}
	function showFunc(elid) {
		var obj = document.getElementById(elid)
		obj.style.display="block"
	}

	onload = hideAll


$(document).ready(function(){
	//alert("ready")

	$('#initButton').click(function(){
		$.ajax({
			type:"GET",
			url:"/api/init_db",
			dataType:"json",
			success:function(data){

				if (data["state"] == "success") {
					alert("初始化系统成功")
				} else {
					alert("初始化失败")
				}
			}
		});
		return false;
	});

	$('#new_device').click(function(){
		var device_name = $("#new_device_device_name").val();
		var stream_name = $("#new_device_stream_name").val();

		var dst_url = "/api/new_device" + "?" + "device_name" + "=" + device_name + "&" +"stream_name=" + stream_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){

				if (data["state"] == "success") {
					alert("新增设备成功")
				} else {
					alert("新增设备失败")
				}
			}
		});
		return false
	});
	$('#get_publish_url').click(function(){
		var stream_name = $("#publish_stream_name").val();

		var dst_url = "/api/get_publish_url" + "?"+"stream_name=" + stream_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					$('#publish_url_content').html(data["result"][0]["publish_url"])
					showFunc("publish_url_show")
				} else {
					alert("获取流失败")
					return false
				}
			}
		});

		dst_url = "/api/get_hlsplay_url" + "?"+"stream_name=" + stream_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				
				if (data["state"] == "success") {
					var html = data["result"][0]["hls_playlive_url"]
					$('#hlslive_url_content').attr("href", data["result"][0]["hls_playlive_url"])
					showFunc("hlslive_url_show")
				} else {
					alert("获取流失败")
					return false 
				}
			}
		});


		dst_url = "/api/get_status" + "?"+"stream_name=" + stream_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					 //<label for="">创建时间:</label><label for="" id="stream_create_time"></label><br>
 					//<label for="">连接状态:</label><label for="" id="stream_is_connected"></label><br>
 					//<label for="">比特率:</label><label for="" id="stream_bit_rate"></label><br>
					$('#stream_is_connected').html(data["result"][0]["status"]["status"])
					$('#stream_bit_rate').html(data["result"][0]["status"]["bytesPerSecond"])
					showFunc("stream_status_show")
				} else {
					alert("获取流失败")
					return false
				}
			}
		});

		var seg_start = "";
		var seg_end = "";
		var seg_limit = "";
		var dst_url = "/api/list_segments" + "?" +"stream_name=" + stream_name + "&" + "start=" + seg_start + "&end=" + seg_end + "&" + "limit="+seg_limit;
		//alert(dst_url)
		$.ajax({

			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					 //<label for="">创建时间:</label><label for="" id="stream_create_time"></label><br>
 					//<label for="">连接状态:</label><label for="" id="stream_is_connected"></label><br>
 					//<label for="">比特率:</label><label for="" id="stream_bit_rate"></label><br>
			
					var dest = data["result"][0]["segments"]["segments"];
					//alert(dest.length)
					var html = '';
					html += '<table>';
					html += ('<tr>' + '<td>开始时间</td>' + '<td>结束时间</td>' + '</tr>');
					for(var i = 0; i<dest.length ;i++){
						html += ('<tr>' + '<td>' + dest[i]["start"] + '</td>' + '<td>' + dest[i]["end"] + '</td>' + '</tr>');
					}

					html += '</table>';
					$('#segment_show_content').html(html)
					showFunc("segment_show")
				} else {
					alert("获取段失败")
					return false
				}
			}
		});
  		/**********************************************************************************/
		return false;
	});
	$('#get_hlslive_url').click(function(){
		var stream_name = $("#hlslive_stream_name").val();

		var dst_url = "/api/get_hlsplay_url" + "?"+"stream_name=" + stream_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					//$('#hlslive_url_content').html(data["result"][0]["hls_playlive_url"])
					var html = data["result"][0]["hls_playlive_url"]
					$('#hlslive_url_content').attr("href", data["result"][0]["hls_playlive_url"])
					//$('#hlslive_url_content').html(data["result"][0]["hls_playlive_url"])
					//alert(html)
					showFunc("hlslive_url_show")
				} else {
					alert("获取流失败")
				}
			}
		});
		return false;
	});

	$('#enable_stream_button').click(function(){
		var stream_name = $("#enable_stream_name").val();
		var dst_url = "/api/start_stream" + "?" +"stream_name=" + stream_name;
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)

				if (data["state"] == "success") {
					alert("启动流成功")
				} else {
					alert("启动流失败")
				}
			}
		});
		return false;
	});
	$('#disable_stream_button').click(function(){
		var stream_name = $("#disable_stream_name").val();
		var dst_url = "/api/stop_stream" + "?" +"stream_name=" + stream_name;
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)

				if (data["state"] == "success") {
					alert("停止流成功")
				} else {
					alert("停止流失败")
				}
			}
		});
		return false;
	});

	$('#status_stream_name_button').click(function(){
		var stream_name = $("#status_stream_name").val();

		var dst_url = "/api/get_status" + "?"+"stream_name=" + stream_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					 //<label for="">创建时间:</label><label for="" id="stream_create_time"></label><br>
 					//<label for="">连接状态:</label><label for="" id="stream_is_connected"></label><br>
 					//<label for="">比特率:</label><label for="" id="stream_bit_rate"></label><br>
					$('#stream_create_time').html(data["result"][0]["status"]["startFrom"])
					$('#stream_is_connected').html(data["result"][0]["status"]["status"])
					$('#stream_bit_rate').html(data["result"][0]["status"]["bytesPerSecond"])
					showFunc("stream_status_show")
				} else {
					alert("获取流失败")
				}
			}
		});
  		return false
  	});
  	$('#delete_stream_button').click(function(){
		var stream_name = $("#delete_stream_name").val();
		var device_name = $("#delete_device_name").val();
		var dst_url = "/api/del_device" + "?" + "device_name" + "=" + device_name + "&" +"stream_name=" + stream_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					 //<label for="">创建时间:</label><label for="" id="stream_create_time"></label><br>
 					//<label for="">连接状态:</label><label for="" id="stream_is_connected"></label><br>
 					//<label for="">比特率:</label><label for="" id="stream_bit_rate"></label><br>
					alert("删除流成功")
				} else {
					alert("删除流失败")
				}
			}
		});
		return false;
	});
  	$('#list_segments_button').click(function(){
		var stream_name = $("#seg_stream_name").val();
		var seg_start = "";
		var seg_end = "";
		var seg_limit = "";
		var dst_url = "/api/list_segments" + "?" +"stream_name=" + stream_name + "&" + "start=" + seg_start + "&end=" + seg_end + "&" + "limit="+seg_limit;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					 //<label for="">创建时间:</label><label for="" id="stream_create_time"></label><br>
 					//<label for="">连接状态:</label><label for="" id="stream_is_connected"></label><br>
 					//<label for="">比特率:</label><label for="" id="stream_bit_rate"></label><br>
			
					var dest = data["result"][0]["segments"]["segments"];
					//alert(dest.length)
					var html = '';
					html += '<table>';
					html += ('<tr>' + '<td>开始时间</td>' + '<td>结束时间</td>' + '</tr>');
					for(var i = 0; i<dest.length ;i++){
						html += ('<tr>' + '<td>' + dest[i]["start"] + '</td>' + '<td>' + dest[i]["end"] + '</td>' + '</tr>');
					}

					html += '</table>';
					$('#segment_show_content').html(html)
					showFunc("segment_show")
				} else {
					alert("获取段失败")
				}
			}
		});
		return false;
	});
  	$('#list_stream_button').click(function(){

		var dst_url = "/api/list_stream";
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)
				
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					 //<label for="">创建时间:</label><label for="" id="stream_create_time"></label><br>
 					//<label for="">连接状态:</label><label for="" id="stream_is_connected"></label><br>
 					//<label for="">比特率:</label><label for="" id="stream_bit_rate"></label><br>
			
					var dest = data["result"][0]["streams"];
					//alert(dest.length)
					var html = '';
					html += '<table>';
					html += ('<tr>' + '<td>设备名称</td>' + '<td>流名称</td>' + '<td>发布流URL</td>' + '<td>直播流URL</td>' + '</tr>');
					for(var i = 0; i<dest.length ;i++){
						html += ('<tr>' + '<td>' + dest[i]["DeviceId"] + '</td>' + '<td>' + dest[i]["StreamName"] + '</td>' + '</td>' + '<td>' + dest[i]["PublishUrl"] + '</td>' + '<td>' + dest[i]["LiveHlsUrl"] + '</td>'+ '</tr>');
					}

					html += '</table>';
					$('#list_stream_show').html(html)
					showFunc("list_stream_show")
				} else {
					alert("获取流信息失败")
				}
			}
		});
		return false;
	});

	 $('#get_playback_url_button').click(function(){
		var stream_name = $("#playback_stream_name").val();
		var seg_start = $("#playback_start").val();;
		var seg_end = $("#playback_end").val();;
		var seg_limit = "";
		var dst_url = "/api/get_playback_url" + "?" +"stream_name=" + stream_name + "&" + "start=" + seg_start + "&end=" + seg_end + "&" + "limit="+seg_limit;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){
				//alert("15")
				//var music="<ul>";
				//i表示在data中的索引位置，n表示包含的信息的对象
				//$.each(data,function(i,n){
					//获取对象中属性为optionsValue的值				
				//	music+="<li>"+n+i+"</li>";
				//});
				//alert(data["state"])

				//music+="</ul>";
				//alert(music)
				//alert("1")
				if (data["state"] == "success") {
					//alert("获取流成功")
					//alert(data["result"][0]["publish_url"])
					 //<label for="">创建时间:</label><label for="" id="stream_create_time"></label><br>
 					//<label for="">连接状态:</label><label for="" id="stream_is_connected"></label><br>
 					//<label for="">比特率:</label><label for="" id="stream_bit_rate"></label><br>
					//alert(data["result"][0]["hls_playback_url"])
					var src = data["result"][0]["hls_playback_url"]["ORIGIN"] + "?" + "start=" + data["result"][0]["hls_playback_url"]["start"] + "&end=" +  data["result"][0]["hls_playback_url"]["end"]
					//alert(src)
					$('#playback_url_content').attr("href", src)
					$('#playback_url_content').html(src)
					//$('#playback_url_content').html(data["result"][0]["hls_playback_url"]["ORIGIN"])	
				} else {
					alert("获取段失败")
				}
			}
		});
		return false
	});

	/*
			<div>
			<form action="/api/get_snot" method="get">
				<label for="">截图</label><br>
				<label for="">流名称:</label><input type="text" name="stream_name" id="getsnot_stream_name" class="input" placeholder="text"><br>
				<label for="">截图时间:</label><input type="text" name="start" id="getsnot_time" class="input" placeholder="text"><br>
				<label for="">截图格式:</label><input type="text" name="end" id="getsnot_format" class="input" placeholder="text"><br>
				</label><button type="button" id="getsnot_button">获取</button>
			</form>
 		</div>

 		<div id="getsnot_show">
 			<!--<label for="">点播流名称:</label>--><a herf="www.baidu.com" id="getsnot_content">点击播放</a><br>
 		</div>	
 		<br><br>
	*/
	$('#getsnot_button').click(function(){
		var stream_name = $("#getsnot_stream_name").val();
		var time = $("#getsnot_time").val();;
		var pic_format = $("#getsnot_format").val();;
		var pic_name = $("#getsnot_name").val();;

		var dst_url = "/api/get_snot" + "?" +"stream_name=" + stream_name + "&" + "time=" + time + "&pic_format=" + pic_format + "&" + "pic_name="+pic_name;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){

				if (data["state"] == "success") {
					var src = data["result"][0]["target_url"]
					//alert(src)
					$('#getsnot_content').attr("href", src)
					$('#getsnot_content').html(src)
					//$('#playback_url_content').html(data["result"][0]["hls_playback_url"]["ORIGIN"])
					showFunc("getsnot_content")
	
				} else {
					alert("截图失败")
				}
			}
		});
		return false
	});

		$('#get_video_cut_button').click(function(){
		var stream_name = $("#get_video_cut_stream_name").val();
		var start = $("#get_video_cut_start").val();
		var end = $("#get_video_cut_end").val();;
		var pic_format = $("#get_video_cut_format").val();;
		var pic_name = $("#get_video_cut_name").val();;

		var dst_url = "/api/get_video_cut" + "?" +"stream_name=" + stream_name + "&" + "start=" + start + "&end=" + end+ "&video_name=" + pic_name + "&" + "video_format="+pic_format;
		//alert(dst_url)
		$.ajax({
			type:"GET",
			url:dst_url,
			dataType:"json",
			success:function(data){

				if (data["state"] == "success") {
					var src = data["result"][0]["save_result"]["targetUrl"]
					//alert(src)
					$('#get_video_cut_content').attr("href", src)
					$('#get_video_cut_content').html(src)
					//$('#playback_url_content').html(data["result"][0]["hls_playback_url"]["ORIGIN"])	
				} else {
					alert("截频失败")
				}
			}
		});
		return false
	});
});

</script>


	</head>

	<body>

<script language="JavaScript" type="text/JavaScript" src="/static/js/test.js">
		//alert("0")
</script>


		<div id="initDb">
			<button type="button" id="initButton">初始化系统</button>
		</div>

		<form action="/api/new_device" method="get">
				<label for=""></label>
				<label for=""></label>
				<input type="text" name="device_name" id="new_device_device_name" class="input" placeholder="设备名称">
				<label for="label"></label>
				<input type="text" name="stream_name2" id="new_device_stream_name" class="input" placeholder="视频流名称">
				</label>
				<button type="button" id="new_device">
				新增视频流</button>
	</form>
 		</div>
 		<br>
		<div>
			<form action="/api/get_publish_url" method="get">
				<label for=""></label>
				<input type="text" name="stream_name" id="publish_stream_name" class="input" placeholder="流名称">
				</label>
				<button type="button" id="get_publish_url">获取流信息</button>
			</form>
 		</div>
	<div id="publish_url_show">
 			<label for="">发布流名称:</label><label for="" id="publish_url_content"></label>
 			<br><label>直播流：<a herf="www.baidu.com" id="hlslive_url_content">点击播放</a></label>
	  <div id="stream_status_show">
              <label for="label">连接状态:</label>
              <label for="label" id="stream_is_connected"></label>
              <br>
              <label for="label">比特率:</label>
              <label for="label" id="stream_bit_rate"></label>
              <br>
            </div>
 			<div id="segment_show">
              <label for="label">视频段信息:</label>
              <label for="label" id="segment_show_content"></label>
	  </div>
 			</div>	
 		<br>
		<div>
			<form action="/api/get_playback_url" method="get">
				<label for=""></label>
				<label for=""></label>
				<input type="text" name="stream_name" id="playback_stream_name" class="input" placeholder="视频流名称">
				<label for=""></label>
				<input type="text" name="start" id="playback_start" class="input" placeholder="开始时间">
				<label for=""></label>
				<input type="text" name="end" id="playback_end" class="input" placeholder="结束时间">
				</label>
				<button type="button" id="get_playback_url_button">点播</button>
			</form>
			<a id="playback_url_content"></a>
 		</div>

 		<br>


		<div>
			<form action="/api/get_snot" method="get">
				<label for=""></label>
				<label for=""></label>
				<input type="text" name="stream_name" id="getsnot_stream_name" class="input" placeholder="视频流名称">
				<label for=""></label>
				<input type="text" name="stream_name" id="getsnot_name" class="input" placeholder="图片名称">
				<label for=""></label>
				<input type="text" name="start" id="getsnot_time" class="input" placeholder="截图时间">
				<label for=""></label>
				<input type="text" name="end" id="getsnot_format" class="input" placeholder="截图格式(jpg/bmp)">
				</label>
				<button type="button" id="getsnot_button">截图</button>
			</form>
			<a id="getsnot_content"></a>
 		</div>
		<div>
			<form action="/api/get_video_cut" method="get">
				<label for=""></label>
				<br>
				<label for=""></label><input type="text" name="stream_name" id="get_video_cut_stream_name" class="input" placeholder="视频流名称">
				<label for=""></label><input type="text" name="stream_name" id="get_video_cut_name" class="input" placeholder="视频名称">
				<label for=""></label><input type="text" name="start" id="get_video_cut_start" class="input" placeholder="开始时间">
				<label for=""></label><input type="text" name="end" id="get_video_cut_end" class="input" placeholder="结束时间">
				<label for=""></label><input type="text" name="end" id="get_video_cut_format" class="input" placeholder="视频格式">
				</label>
				<button type="button" id="get_video_cut_button">另存视频段</button>
			</form>
			<a id="get_video_cut_content"></a>
 		</div>
	
 		<br>




 		<div>
			<form action="/api/start_stream" method="get">
				<label for=""></label>
				<input type="text" name="stream_name" id="enable_stream_name" class="input" placeholder="视频流名称">
				<button type="button" id="enable_stream_button">启动视频流</button>
			</form>
 		</div>	
 		<br>
	<div>
	  <form action="/api/stop_stream" method="get">
		  <label for=""></label>
				<input type="text" name="stream_name" id="disable_stream_name" class="input" placeholder="视频流名称">
		  <button type="button" id="disable_stream_button">停止视频流<br>
	  </button>
	  </form>
 		</div>	
 		<br>
	  <div><form action="/api/del_device" method="get">
				  <label for=""></label>
				  <input type="text" name="device_name" id="delete_device_name" class="input" placeholder="设备名称">
				  <label for=""></label>
				  <input type="text" name="stream_name" id="delete_stream_name" class="input" placeholder="视频名称">
				  <button type="button" id="delete_stream_button">删除视频流</button>
			</form>
	</div>	
 		

 		<br>
 		<br>





	</body>
</html>		