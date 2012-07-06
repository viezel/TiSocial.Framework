var win = Ti.UI.createWindow({backgroundColor:'white'});
var fbbtn = Ti.UI.createButton({
	width:100,
	height:30,
	top:30,
	title:"Facebook"
});
win.add(fbbtn);

var tweetbtn = Ti.UI.createButton({
	width:100,
	height:30,
	top:90,
	title:"Twitter"
});
win.add(tweetbtn);


if (Titanium.Platform.name == 'iPhone OS'){
	//iOS Only
	
	var Social = require('dk.napp.social');
	Ti.API.info("module is => " + Social);
	
	fbbtn.addEventListener("click", function(){	
		if(Social.isFacebookSupported){ //min iOS6 required
			Social.facebook({
				text:"initial fb share text",
				image:"pin.png",
				url:"http://www.napp.dk"
			});
		} else {
			//implement Ti.Facebook Method
		}
	});
	
	tweetbtn.addEventListener("click", function(){	
		if(Social.isTwitterSupported){ //min iOS6 required
			Social.twitter({
				text:"initial tweet message",
				image:"pin.png",
				url:"http://www.napp.dk"
			});
		} else {
			//implement iOS5 Twitter method..
		}
	});
	
	Social.addEventListener("complete", function(e){
		Ti.API.info("complete: "+e.success);	
	});
	
	Social.addEventListener("cancelled", function(e){
		Ti.API.info("cancelled");	
	});
}

win.open();