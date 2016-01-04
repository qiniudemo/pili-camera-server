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
		//hideFunc("initDb")
	}


	onload = hideAll


$(document).ready(function(){
	alert("ready")
	$('#initButton').click(function(){
		$.ajax({
			type:"GET",
			url:"/api/init_db",
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
					alert("初始化系统成功")
				}
			}
		});
		return false;
	});

	$('#initButton').click(function(){
		$.ajax({
			type:"GET",
			url:"/api/init_db",
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
					alert("初始化系统成功")
				}
			}
		});
		return false;
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






		<div>
			<form action="/api/init_db" method="get">
				<input type="submit" value="初始化数据库">
			</form>
		</div>
		<div>
		
		<form action="/api/new_device" method="get">
				<label for="">新增设备</label><br>
				<input type="text" name="device_name" id="" class="input" placeholder="text"><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="新增流">
			</form>
 		</div>
		<div>
			<form action="/api/get_publish_url" method="get">
				<label for="">获取发布流</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="获取设备流">
			</form>
 		</div>		
		<div>
			<form action="/api/get_hlsplay_url" method="get">
				<label for="">获取hls直播流</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="获取设备流">
			</form>
 		</div>	
		<div>
			<form action="/api/start_stream" method="get">
				<label for="">启用直播流</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="启用直播流">
			</form>
 		</div>		
		<div>
			<form action="/api/stop_stream" method="get">
				<label for="">停止直播流</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="停止直播流">
			</form>
 		</div>		
		<div>
			<form action="/api/get_status" method="get">
				<label for="">直播流状态</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="直播流状态">
			</form>
 		</div>	
		<div>
			<form action="/api/list_stream" method="get">
				<label for="">列出所有流</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="直播流状态">
			</form>
 		</div>
		<div>
			<form action="/api/list_segments" method="get">
				<label for="">列出所有段落</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="text" name="start" id="" class="input" placeholder="text"><br>
				<input type="text" name="end" id="" class="input" placeholder="text"><br>
				<input type="text" name="limit" id="" class="input" placeholder="text"><br>
				<input type="submit" value="列出所有段落">
			</form>
 		</div>
		<div>
			<form action="/api/del_device" method="get">
				<label for="">删除流</label><br>
				<input type="text" name="stream_name" id="" class="input" placeholder="text"><br>
				<input type="text" name="device_name" id="" class="input" placeholder="text"><br>
				<input type="submit" value="删除流">
			</form>
 		</div>
	</body>
</html>		