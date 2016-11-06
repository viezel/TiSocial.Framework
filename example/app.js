var win = Ti.UI.createWindow({
    backgroundColor:'white',
    layout: "vertical"
});

var btnContainer = Ti.UI.createScrollView();



var activityPopoverBtn = Ti.UI.createButton({
    width:100,
    left: 50,
    height:35,
    top:115,
    bubble: false,
    title:"Activity PopOver (iPad)"
});
btnContainer.add(activityPopoverBtn);
var activityPopoverBtnTwo = Ti.UI.createButton({
    width:100,
    right: 50,
    height:35,
    top:115,
    bubble: false,
    title:"Activity PopOver (iPad)"
});
btnContainer.add(activityPopoverBtnTwo);

var seperatorView = Ti.UI.createView({
    height: 250,
    backgroundColor: "red"
});

var view = Ti.UI.createView({
    height: Ti.UI.SIZE,
    layout:"vertical"
});
view.add(btnContainer);

win.add(seperatorView);
win.add(view);

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
        

    Social.addEventListener("facebookAccount", function(e){ 
        Ti.API.info("facebookAccount: "+e.success); 
        fbAccount = e.account;
        Ti.API.info(e); 
    });
    
            var popover = Ti.UI.iPad.createPopover({
                contentView: Ti.UI.createLabel({
                  text: 'Hello World!',
                  font: {
                    fontSize: 40
                  }
                })
              });
            

    activityPopoverBtnTwo.addEventListener("click", function(e){
        
            Ti.API.info("e.source.rect.x:: " + e.source.rect.x);
            Ti.API.info("e.source.rect.y:: " + e.source.rect.y);
            
            
            Ti.API.info("e.x:: " + e.x);
            Ti.API.info("e.y:: " + e.y);
            
            
            Ti.API.info("e.activityPopoverBtn.rect.x:: " + activityPopoverBtn.rect.x);
            Ti.API.info("e.activityPopoverBtn.rect.y:: " + activityPopoverBtn.rect.y);
            
              popover.show({
                view: e.source,
                animated: false,
                arrowDirection: Ti.UI.iPad.POPOVER_ARROW_DIRECTION_DOWN
              });
                 
    });
    activityPopoverBtn.addEventListener("click", function(e){
        Ti.API.info("E:: " + JSON.stringify(e));
        if(Social.isActivityViewSupported()){ //min iOS6 required
       
            Ti.API.info("e.source.rect.x:: " + e.source.rect.x);
            Ti.API.info("e.source.rect.y:: " + e.source.rect.y);
            
            
            Ti.API.info("e.x:: " + e.x);
            Ti.API.info("e.y:: " + e.y);
            
            
            Ti.API.info("e.activityPopoverBtn.rect.x:: " + activityPopoverBtn.rect.x);
            Ti.API.info("e.activityPopoverBtn.rect.y:: " + activityPopoverBtn.rect.y);
            
            
            Social.activityPopover({
                text:"share like a king!",
                image:"pin.png",
                removeIcons:"print,sms,copy,contact,camera,mail",
                view: e.source //source button
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

win.open();