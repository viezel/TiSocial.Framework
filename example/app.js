var win = Ti.UI.createWindow({backgroundColor:'white'});

var btnContainer = Ti.UI.createView({layout:"vertical"});

var fbbtn = Ti.UI.createButton({
	width:150,
	height:35,
	top:15,
	title:"Facebook"
});
btnContainer.add(fbbtn);

var fbrequestbtn = Ti.UI.createButton({
	width:150,
	height:35,
	top:15,
	title:"Facebook Request"
});
btnContainer.add(fbrequestbtn);

var tweetbtn = Ti.UI.createButton({
	width:150,
	height:35,
	top:15,
	title:"Twitter"
});
btnContainer.add(tweetbtn);

var tweetrequestbtn = Ti.UI.createButton({
	width:150,
	height:35,
	top:15,
	title:"Twitter Request"
});
btnContainer.add(tweetrequestbtn);

win.add(btnContainer);

if (Titanium.Platform.name == 'iPhone OS'){
	//iOS Only
	
	var Social = require('dk.napp.social');
	Ti.API.info("module is => " + Social);

	fbbtn.addEventListener("click", function(){	
		if(Social.isFacebookSupported()){ //min iOS6 required
			Social.facebook({
				text:"<3 appcelerator",
				//image:"pin.png", //local resource folder image
				image:"http://static.appcelerator.com/images/header/appc_logo200.png", //url image
				url:"http://www.napp.dk"
			});
		} else {
			//implement Ti.Facebook Method - iOS5
		}
	});
	
	fbrequestbtn.addEventListener("click", function(){	
		if(Social.isFacebookSupported()){ //min iOS6 required
			Social.requestFacebook({
				requestType:"GET",
				url:"https://graph.facebook.com/me/feed",
				appIdKey:"YOUR_FB_APP_ID",
				permissionsKey:"publish_stream"
			});
		} else {
			//implement Ti.Facebook Method - iOS5
		}
	});
	
	tweetbtn.addEventListener("click", function(){	
		if(Social.isTwitterSupported()){ //min iOS6 required
			Social.twitter({
				text:"initial tweet message",
				image:"pin.png",
				url:"http://www.napp.dk"
			});
		} else {
			//implement iOS5 Twitter method
		}
	});
	
	tweetrequestbtn.addEventListener("click", function(){	
		if(Social.isTwitterSupported()){ //min iOS6 required
			Social.requestTwitter({
				requestType:"GET",
				url:"https://api.twitter.com/1/statuses/user_timeline.json",
				requestParameterKey:"screen_name",
				requestParameterVariable:"nappdev"
			});
		} else {
			//implement iOS5 Twitter method
		}
	});
	
	Social.addEventListener("twitterRequest", function(e){
		Ti.API.info("twitterRequest: "+e.success);	
		Ti.API.info(e.response);
	});
	
	Social.addEventListener("facebookRequest", function(e){
		Ti.API.info("facebookRequest: "+e.success);	
		Ti.API.info(e.response);
	});
	
	Social.addEventListener("complete", function(e){
		Ti.API.info("complete: "+e.success);	
	});
	
	Social.addEventListener("error", function(e){
		Ti.API.info("error: "+e.success);	
		Ti.API.info(e.status);	
	});
	
	Social.addEventListener("cancelled", function(e){
		Ti.API.info("cancelled");	
	});
}

win.open();