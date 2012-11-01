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

var weibobtn = Ti.UI.createButton({
    width:100,
    height:30,
    top:150,
    title:"Sina Weibo"
});
win.add(weibobtn);


if (Titanium.Platform.name == 'iPhone OS'){
	//iOS Only
	
	var Social = require('dk.napp.social');
	Ti.API.info("module is => " + Social);
	
    console.log("Facebook available: " + Social.isFacebookSupported());
    console.log("Twitter available: " + Social.isTwitterSupported());
    console.log("SinaWeibo available: " + Social.isSinaWeiboSupported());
    
    
	fbbtn.addEventListener("click", function(){	
		if(Social.isFacebookSupported()){ //min iOS6 required
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
		if(Social.isTwitterSupported()){ //min iOS6 required
			Social.twitter({
				text:"initial tweet message",
				image:"pin.png",
				url:"http://www.napp.dk"
			});
		} else {
			//implement iOS5 Twitter method..
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
	
	Social.addEventListener("complete", function(e){
		Ti.API.info("complete: "+e.success);	
	});
	
	Social.addEventListener("cancelled", function(e){
		Ti.API.info("cancelled");	
	});
}

win.open();