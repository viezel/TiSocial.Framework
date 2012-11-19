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

var weibobtn = Ti.UI.createButton({
    width:150,
    height:35,
    top:15,
    title:"Sina Weibo"
});
btnContainer.add(weibobtn);

win.add(btnContainer);

if (Titanium.Platform.name == 'iPhone OS'){
	//iOS only module
	
	var Social = require('dk.napp.social');
	Ti.API.info("module is => " + Social);
	
    Ti.API.info("Facebook available: " + Social.isFacebookSupported());
    Ti.API.info("Twitter available: " + Social.isTwitterSupported());
    Ti.API.info("SinaWeibo available: " + Social.isSinaWeiboSupported());
    
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
                url:"https://graph.facebook.com/me",
                appIdKey:"YOUR_FB_APP_ID",
                callbackEvent: "facebookProfile",
                permissionsKey: "publish_stream"
			}, {
                fields: 'id,name,devices'
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
				url:"https://api.twitter.com/1/statuses/user_timeline.json"
			}, {
				'screen_name': 'nappdev'
			});
		} else {
			//implement iOS5 Twitter method
		}
	});
    
    weibobtn.addEventListener("click", function(){
        if(Social.isSinaWeiboSupported()){ //min iOS6 required
            Social.sinaweibo({
                text:"initial sinaweibo message",
                image:"pin.png",
                url:"http://www.napp.dk"
            });
        } else {
            //implement fallback..
        }
    });
	
	Social.addEventListener("twitterRequest", function(e){
		Ti.API.info("twitterRequest: "+e.success);	
		Ti.API.info(e.response);
	});
	
	Social.addEventListener("facebookProfile", function(e){
		Ti.API.info("facebook profile: "+e.success);	
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