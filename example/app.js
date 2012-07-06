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


var Social = require('dk.napp.social');
Ti.API.info("module is => " + Social);

fbbtn.addEventListener("click", function(){	
	Social.facebook({
		text:"test fb",
		image:"pin.png",
		url:"http://www.napp.dk"
	});
});

tweetbtn.addEventListener("click", function(){	
	Social.twitter({
		text:"test tweet",
		image:"pin.png",
		url:"http://www.napp.dk"
	});
});

Social.addEventListener("complete", function(e){
	Ti.API.info("complete: "+e.success);	
});

Social.addEventListener("cancelled", function(e){
	Ti.API.info("cancelled");	
});

win.open();