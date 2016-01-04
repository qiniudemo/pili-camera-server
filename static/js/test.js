function getwith(to, p) {  

    var myForm = document.createElement("getForm");  

    myForm.method = "get";  
    myForm.action = to;  

    for ( var k in p) {  
        var myInput = document.createElement("getInput");  
        myInput.setAttribute("name", k);  
        myInput.setAttribute("value", p[k]);  
        myForm.appendChild(myInput);  
    }  

    document.body.appendChild(myForm);  
    alert("2")
    try {
    	myForm.submit();
	} catch (e) {
		 alert("3")
		 alert(e)
	}
    alert("3")
    document.body.removeChild(myForm);  

}  

function showdiv(targetid,objN){
   
      var target=document.getElementById(targetid);
            if (target.style.display=="block"){
                target.style.display="none";

            } else {
                target.style.display="block";
            }
   
}

function hides(ids) {
 //$(document.getElementById("initButton")).hide();
 alertsnow()
 document.getElementById("initDb").style.display="none";
}

function hideComponents() {
	hides("initButton")
}

function alertsnow() {
	alert("弹出窗口")


}

function initilizeSystem() {
	alert("0")

}