var win = Ti.UI.createWindow({backgroundColor:'white'});

var btnContainer = Ti.UI.createScrollView({layout:"vertical"});

var requestPermissionsBtn = Ti.UI.createButton({
	width:300,
	height:35,
	top:15,
	title:"1. Request Facebook Permissions"
});
btnContainer.add(requestPermissionsBtn);

var fbIdentifierRequestBtn = Ti.UI.createButton({
	width:300,
	height:35,
	top:15,
	title:"2. Facebook Identifier Request"
});
btnContainer.add(fbIdentifierRequestBtn);


var renewFacebookAccessTokenBtn = Ti.UI.createButton({
	width:300,
	height:35,
	top:15,
	title:"3. Facebook Renew Access Token"
});
btnContainer.add(renewFacebookAccessTokenBtn);



var fbbtn = Ti.UI.createButton({
	width:200,
	height:35,
	top:15,
	title:"Facebook composer"
});
btnContainer.add(fbbtn);

var fbrequestbtn = Ti.UI.createButton({
	width:200,
	height:35,
	top:15,
	title:"Facebook Request"
});
btnContainer.add(fbrequestbtn);

var tweetbtn = Ti.UI.createButton({
	width:200,
	height:35,
	top:15,
	title:"Twitter composer"
});
btnContainer.add(tweetbtn);

var tweetrequestbtn = Ti.UI.createButton({
	width:200,
	height:35,
	top:15,
	title:"Twitter Request"
});
btnContainer.add(tweetrequestbtn);

var tweetRequestSelectedBtn = Ti.UI.createButton({
	width:Ti.UI.SIZE,
	height:35,
	top:15,
	title:"Twitter Request (selected account)"
});
btnContainer.add(tweetRequestSelectedBtn);

var weibobtn = Ti.UI.createButton({
    width:200,
    height:35,
    top:15,
    title:"Sina Weibo"
});
btnContainer.add(weibobtn);

var activitybtn = Ti.UI.createButton({
    width:200,
    height:35,
    top:15,
    title:"Activity View"
});
btnContainer.add(activitybtn);

var customactivitybtn = Ti.UI.createButton({
    width:200,
    height:35,
    top:15,
    title:"Custom Activity View"
});
btnContainer.add(customactivitybtn);

var activityPopoverBtn = Ti.UI.createButton({
    width:200,
    height:35,
    top:15,
    title:"Activity PopOver (iPad)"
});
btnContainer.add(activityPopoverBtn);

win.add(btnContainer);

if (Titanium.Platform.name == 'iPhone OS'){
	//iOS only module
	
	var Social = require('dk.napp.social');
	Ti.API.info("module is => " + Social);
	
    Ti.API.info("Facebook available: " + Social.isFacebookSupported());
    Ti.API.info("Twitter available: " + Social.isTwitterSupported());
    Ti.API.info("SinaWeibo available: " + Social.isSinaWeiboSupported());
    
    // find all Twitter accounts on this phone
    if(Social.isRequestTwitterSupported()){ //min iOS6 required
	    var accounts = []; 
	    Social.addEventListener("accountList", function(e){
	    	Ti.API.info("Accounts:");
	    	accounts = e.accounts; //accounts
	    	Ti.API.info(accounts);
	    });
	    
	    Social.twitterAccountList();
    }
        
    tweetRequestSelectedBtn.addEventListener("click", function(e){
    	if(Social.isRequestTwitterSupported()){ //min iOS6 required
			Social.requestTwitter({
				requestType:"GET",
				url:"https://api.twitter.com/1/statuses/mentions.json",
				accountWithIdentifier: accounts[0].identifier //this first user
			}, {
				screen_name: accounts[0].username
			});
		}
    });
    
	fbbtn.addEventListener("click", function(){	
		if(Social.isFacebookSupported()){ //min iOS6 required
			Social.facebook({
				text:"<3 appcelerator",
				image:"pin.png", //local resource folder image
				//image:"https://secure.gravatar.com/avatar/01d8a2b8546d6479cf4323d72cbed363?s=420&d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-org-420.png", //url image
				url:"http://www.napp.dk"
			});
		} else {
			//implement Ti.Facebook Method - iOS5
		}
	});
	
	var fbAccount;
	
	// Get the facebook permissions once.
	requestPermissionsBtn.addEventListener("click", function(){	
		if(Social.isFacebookSupported()){ //min iOS6 required
			Social.grantFacebookPermissions({
                appIdKey:"YOUR_FB_APP_ID",
                permissionsKey: "email" //FB docs: https://developers.facebook.com/docs/reference/login/extended-permissions/
			});
		} 
	});
	
	Social.addEventListener("facebookAccount", function(e){ 
		Ti.API.info("facebookAccount: "+e.success);	
		fbAccount = e.account;
		Ti.API.info(e); 
	});
	
	fbIdentifierRequestBtn.addEventListener("click", function(){
		Social.requestFacebookWithIdentifier({
            requestType:"GET",
            accountWithIdentifier: fbAccount["identifier"], //start by granting facebook permissions 
            url:"https://graph.facebook.com/me",
            callbackEvent: "facebookProfile",
		}, {
            fields: 'id,name,location'
		});
	});
	
	
	// once permissions have been granted, its only necessary to renew the account credentials. 
	renewFacebookAccessTokenBtn.addEventListener("click", function(){	
		Social.renewFacebookAccessToken();
	});
	
	
	
	//use the Graph API Explorer for much more info: https://developers.facebook.com/tools/explorer
	
	fbrequestbtn.addEventListener("click", function(){	
		if(Social.isFacebookSupported()){ //min iOS6 required
			Social.requestFacebook({
                requestType:"GET",
                url:"https://graph.facebook.com/me",
                appIdKey:"YOUR_FB_APP_ID",
                callbackEvent: "facebookProfile",
                permissionsKey: "email" //FB docs: https://developers.facebook.com/docs/reference/login/extended-permissions/
			}, {
                fields: 'id,name,location'
			});
		} else {
			//implement Ti.Facebook Method - iOS5
		}
	});
	
	tweetbtn.addEventListener("click", function(){	
		if(Social.isTwitterSupported()){ //min iOS5 required
			Social.twitter({
				text:"initial tweet message",
				image:"pin.png",
				url:"http://www.napp.dk"
			});
		} 
	});
	
	tweetrequestbtn.addEventListener("click", function(){	
		if(Social.isRequestTwitterSupported()){ //min iOS6 required
			Social.requestTwitter({
				requestType:"GET",
				url:"https://api.twitter.com/1/statuses/user_timeline.json"
			}, {
				screen_name: 'nappdev'
			});
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
    
    
    activitybtn.addEventListener("click", function(){
        if(Social.isActivityViewSupported()){ //min iOS6 required
            Social.activityView({
                text:"share like a king!",
                image:"pin.png"
            });
        } else {
            //implement fallback sharing..
        }
    });
    
    customactivitybtn.addEventListener("click", function(){
        if(Social.isActivityViewSupported()){ //min iOS6 required
            Social.activityView({
                text:"share like a king!",
                image:"pin.png",
                removeIcons:"print,sms,copy,contact,camera,mail"
            },[
            	{
            		title:"Custom Share",
            		type:"hello.world",
            		image:"pin.png",
            		callback: function(e) {
						alert("You chose me!");
					}
            	},
            	{
            		title:"Open in Safari",
            		type:"open.safari",
            		image:"safari.png",
            		callback: function(e) {
            			Ti.Platform.openURL("http://www.napp.dk");
            		}
            	}
            ]);
        } else {
            //implement fallback sharing..
        }
    });
    
    activityPopoverBtn.addEventListener("click", function(e){
        if(Social.isActivityViewSupported()){ //min iOS6 required
            Social.activityPopover({
                text:"share like a king!",
                image:"pin.png",
                removeIcons:"print,sms,copy,contact,camera,mail",
                view: activityPopoverBtn //source button
            });
        } else {
            //implement fallback sharing..
        }
    });
    
	
	Social.addEventListener("twitterRequest", function(e){ //default callback
		Ti.API.info("twitterRequest: "+e.success);	
		Ti.API.info(e.response); //json
		Ti.API.info(e.rawResponse); //raw data - this is a string
	});
	
	
	
	Social.addEventListener("facebookRequest", function(e){ //default callback
		Ti.API.info("facebookRequest: "+e.success);	
		Ti.API.info(e); 
	});
	
	Social.addEventListener("facebookProfile", function(e){
		Ti.API.info("facebook profile: "+e.success);	
		Ti.API.info(e.response); //json
	});
	
	Social.addEventListener("complete", function(e){
		Ti.API.info("complete: " + e.success);
		console.log(e);

		if (e.platform == "activityView" || e.platform == "activityPopover") {
			switch (e.activity) {
				case Social.ACTIVITY_TWITTER:
					Ti.API.info("User is shared on Twitter");
					break;

				case Social.ACTIVITY_CUSTOM:
					Ti.API.info("This is a customActivity: " + e.activityName);
					break;
			}
		}
	});
	
	Social.addEventListener("error", function(e){
		Ti.API.info("error:");	
		Ti.API.info(e);	
	});
	
	Social.addEventListener("cancelled", function(e){
		Ti.API.info("cancelled:");
		Ti.API.info(e);		
	});
	
	
	Social.addEventListener("customActivity", function(e){
		Ti.API.info("customActivity");	
		Ti.API.info(e);	
		
	});
}

win.open();