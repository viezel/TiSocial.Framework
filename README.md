# TiSocial.Framework Module

## Description

The TiSocial.Framework Module extends the Appcelerator Titanium Mobile framework with the iOS6 social.framework. This enables sharing content to Facebook, Twitter and other platforms.

The module is licensed under the MIT license.


![SLComposeViewController](http://s7.postimage.org/tjrcwqtdn/SLCompose_View_Controller.png)
![UIActivityViewController](http://s14.postimage.org/y85v7ev1t/UIActivity_View_Controller.png)



## Referencing the module in your Titanium Mobile application ##

Simply add the following lines to your `tiapp.xml` file:

    <modules>
        <module platform="iphone">dk.napp.social</module>
    </modules>


## Reference

For more detailed code examples take a look into the example app

## Twitter

### Social.isTwitterSupported()
Returns *true* or *false*.  
false if no account has been defined (true in the 6.0 simulator) or the iOS Version doesn't support the Social Framework.

### Social.twitter(*{Object} options*)
`options` can have the following keys:

* *text* - the status message
* *image* - a local/remote path to an image you want to share
* *url* - a url you want to share

Each of these options is optional

### Social.twitterRequest(*{Object} options [, {Object} requestParameter]*)
`options`has the following keys:

* *requestType* - can be *GET*, *POST* or *DELETE*
* *url* - the url you want to request
* *callbackEvent* - optional - default: *twitterRequest* - how is the event called that is fired after request has succeeded?
* *accountWithIdentifier* - Identifier to select which account to request twitter with.

`requestParameter` is optional, but is build like this:

    {
        'screen_name': 'CBeloch'
    }

So *screen_name* is the parameter name / key and *CBeloch* is the value of the parameter

### Social.twitterAccountList()
Returns a list of twiiter accounts. use the EventListener `accountList` to capture this list.

```javascript
Social.addEventListener("accountList", function(e){
    Ti.API.info("Accounts:");
    accounts = e.accounts; //accounts
    Ti.API.info(accounts);
});
Social.twitterAccountList();
```

## Facebook

### Social.isFacebookSupported()
Returns *true* or *false*.  
false if no account has been defined (true in the 6.0 simulator) or the iOS Version doesn't support the Social Framework.

### Social.facebook(*{Object} options*)
`options` can have the following keys:

* *text* - the status message
* *image* - a local/remote path to an image you want to share
* *url* - a url you want to share

Each of these options is optional

### Social.facebookRequest(*{Object} options [, {Object} requestParameter]*)
`options` has the following keys:

* *requestType* - can be *GET*, *POST* or *DELETE*
* *url* - the url you want to request
* *appIdKey* - the appid of your facebook app
* *permissionsKey* - optional - a comma seperated string that contains the required permissions
* *callbackEvent* - optional - default: *facebookRequest* - how is the event called that is fired after request has succeeded?

`requestParameter` is optional, but is build like this:

    {
        fields: 'id,name,devices'
    }

So *fields* is the parameter name / key and *id,name,devices* is the value of the parameter

### Social.grantFacebookPermissions
Before you can send request to the Facebook API, you start by getting the users permissions.

```javascript
var fbAccount;
Social.grantFacebookPermissions({
    appIdKey:"YOUR_FB_APP_ID",
    permissionsKey: "email" //FB docs: https://developers.facebook.com/docs/reference/login/extended-permissions/
});
Social.addEventListener("facebookAccount", function(e){
    fbAccount = e.account; //now you have stored the FB account. You can then request facebook using the below method
});
```

### Social.requestFacebookWithIdentifier(*{Object} options [, {Object} requestParameter]*)

Request Facebook with a specific account.

```javascript
Social.requestFacebookWithIdentifier({
    requestType:"GET",
    accountWithIdentifier: fbAccount["identifier"], //start by granting facebook permissions
    url:"https://graph.facebook.com/me",
    callbackEvent: "facebookProfile",
}, {
    fields: 'id,name,location'
});
```

### Social.renewFacebookAccessToken

The accessToken will eventually be invalid, if you store the FB acccount in a App property or storage of some kind. This method can renew the accessToken, and make you able to request Facebook again.
This method rely on the same *facebookAccount* eventlistener, as `grantFacebookPermissions`.

```javascript
Social.renewFacebookAccessToken();
```

## Sina Weibo

### Social.isSinaWeiboSupported()
Returns *true* or *false*.  
false if no account has been defined (true in the 6.0 simulator) or the iOS Version doesn't support the Social Framework.

### Social.sinaweibo(*{Object} options*)
`options` can have the following keys:

* *text* - the status message
* *image* - a local/remote path to an image you want to share
* *url* - a url you want to share

Each of these options is optional

## UIActivityViewController

### Constants

* **ACTIVITY_FACEBOOK**: UIActivityTypePostToFacebook
* **ACTIVITY_TWITTER**: UIActivityTypePostToTwitter
* **ACTIVITY_WEIBO**: UIActivityTypePostToWeibo
* **ACTIVITY_MESSAGE**: UIActivityTypeMessage
* **ACTIVITY_MAIL**: UIActivityTypeMail
* **ACTIVITY_PRINT**: UIActivityTypePrint
* **ACTIVITY_COPY**: UIActivityTypeCopyToPasteboard
* **ACTIVITY_ASSIGN_CONTATCT**: UIActivityTypeAssignToContact
* **ACTIVITY_SAVE_CAMERA**: UIActivityTypeSaveToCameraRoll
* **ACTIVITY_READING_LIST**: UIActivityTypeAddToReadingList
* **ACTIVITY_FLICKR**: UIActivityTypePostToFlickr
* **ACTIVITY_VIMEO**: UIActivityTypePostToVimeo
* **ACTIVITY_AIRDROP**: UIActivityTypeAirDrop
* **ACTIVITY_TENCENT_WEIBO**: UIActivityTypePostToTencentWeibo
* **ACTIVITY_CUSTOM**: Custom Activities

### Events

* **complete**: Fired when the user completes using an Activity. Here, you can verify which activity the user has selected by checking the *activity* event property. When dealing with customActivities, you can get the *activityName* property.
* **cancelled**: Fired when user did not complete the request.

### Social.activityView()
The first required `options` argument can have the following keys:

* *text* - the status message
* *htmlText* - html message to use in the e-mail activity (requires emailIsHTML = true). If null will use the "text" message
* *url* - a url you want to share
* *image* - a local/remote path to an image you want to share
* *removeIcons* - customise the dialog by removing unwanted icons.
* *emailIsHTML* - Optional boolean flag that tells if email content should be in html format.
* *subject* - a subject to be used when sharing through email
* *platformAppendText* - an object with custom strings to add to different share providers. Possible values are: "twitter", "message", "whatsapp" or the id of the extension like "com.buffer.buffer.BufferComposeExtension". Facebook is not included, because the new FacebookSDK only allows for sharing URLs.

The second optional argument is an array with objects. Use this to create custom UIActivities.
The posibilties are almost endless. have a look at: *http://uiactivities.com* for inspiration.

```javascript
Social.activityView({
    text:"share like a king!",
    subject:"I would like to share this with you",
    image:"pin.png",
    removeIcons:"print,sms,copy,contact,camera,mail",
    emailIsHTML : false,

    platformAppendText: {
        twitter: ' via @twitter #twitter',
        message: ' via www.example.com',
        whatsapp: ' via 555-1234567',
        'com.buffer.buffer.BufferComposeExtension': ' via Buffer'
    }

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
        image:"safari.png"
    }
]);
```

### Social.activityPopover() (iPad only)
The first required `options` argument can have the following keys:

* *text* - the status message
* *htmlText* - html message to use in the e-mail activity (requires emailIsHTML = true). If null will use the "text" message
* *url* - a url you want to share
* *image* - a local/remote path to an image you want to share
* *removeIcons* - customise the dialog by removing unwanted icons.
* *view* - the source button
* *emailIsHTML* - Optional boolean flag that tells if email content should be in html format.
* *subject* - a subject to be used when sharing through email
* *platformAppendText* - an object with custom strings to add to different share providers. Possible values are: "twitter", "message", "whatsapp" or the id of the extension like "com.buffer.buffer.BufferComposeExtension". Facebook is not included, because the new FacebookSDK only allows for sharing URLs.

The second optional argument is an array with objects. Use this to create custom UIActivities.

See `Social.activityView()`.

## Example of usage

### FollowMe Button
`example/follow_on_twitter.js` contains an example on how to implement a "Follow Me" button.
It takes an account the os version and for iOS 5 will try to open the profile page in another application that exits on the device.

Please check the *Example* section in the file.



## Changelog

***v.1.8.2***

* Support HTML text for email and plain text for other activities   

***v.1.8.1***

* Added support for iOS8 Popover (@adesugbaa)

***v.1.8.0***

* Avoiding conflict with new Facebook module (#129)

***v.1.7.10***

* Added missing URL option to iPad activity sheet
* Added subject for email as mentioned in #112
* Fixed a potential memory leak

***v.1.7.9***

* Fixed issue with popover not showing on iPad

***v1.7.8***

* Added support for 64-bit. Previous attempt was incorrect.

***v1.7.7***

* Added support for email only html customization

***v1.7.6***

* Added support for 64-bit

**v1.7.5**  

* Built with SDK 3.4.0, works on iOS 8. Changed project to use ARC, removed iOS 5 support (some deprecated stuff)

**v1.7.4**  

* Remove iOS8- specific build flags

**v1.7.3**  

* Bugfix for unsupported iOS6 sharing types

**v1.7.2**  

* Added url property for activityView to support Reading List
* fixed image sharing

**v1.7.1**  

* Added new activities in iOS7: `ACTIVITY_READING_LIST`, `ACTIVITY_FLICKR`, `ACTIVITY_VIMEO`, `ACTIVITY_AIRDROP ` & `ACTIVITY_TENCENT_WEIBO`
* Added callback on custom activities

**v1.7.0**  

* Added support iOS7

**v1.6.2**  

* Added support to verify what activity was choiced by user in *complete* event
* Create constants to each default activity
* Documentation changes

**v1.6.1**  

* Added userId to `twitterAccountList()`  
* Bugfix for Twitter iOS5 error handling.

**v1.6.0**  

* Added custom UIActivity. You can create your own sharing option for activityView in seconds.   
* Added `grantFacebookPermissions()`, `renewFacebookAccessToken()` and `requestFacebookWithIdentifier()` for giving you a greater control of when to promt the enduser with permissions.  
* Added platform property to objects returned to eventListeners. Twiiter, Facebook and activityView.  

**v1.5.5**  

* Added Facebook accessToken output on `requestFacebook()`.  
* Added better error handling. error eventListener return the reason as a string in e.message.  

**v1.5.4**  

* Added `twitterAccountList()` and `accountWithIdentifier`.  

**v1.5.3**  

* Added UIActivityViewController popOver for iPad use: `activityPopover()`.    

**v1.5.2**  

* Added raw data callback response for `requestTwitter()`.    

**v1.5.1**  

* Bugfixes.  
* Added `isRequestTwitterSupported()` for iOS6 check.  

**v1.5**  

* UIActivityViewController implemented.
* Improved image filepath finder (bundle, data, remote, url)

**v1.4**  

* Support for iOS5 Twiiter Framework.

**v1.3**  

* Different parameter setup for `requestFacebook()` and `requestTwitter()`.    
* Now supporting Wall posting and more request parameter.  

**v1.2**    

* Added support to share image from downloaded remote images in cache or documents folders.  
* Added support to share image from image urls.   

**v1.1**    

* SLRequest methods implemented. `requestFacebook()` and `requestTwitter()`.

**v1.0**    

* Initial Implementation of SLComposeViewController.


## Author

**Mads Møller**  
web: http://www.napp.dk  
email: mm@napp.dk  
twitter: @nappdev  

## Contributors

**Christopher Beloch**  
twitter: @CBeloch

**Jongeun Lee**  
twitter: @yomybaby

**Daniel Tamas**  
twitter: @dan_tamas

**Rafael Kellermann Streit**  
twitter: @rafaelks

**Joseandro Luiz**  
twitter: @joseandroluiz

**Carlos Zinato**  
twitter: @chmiiller

## License

    Copyright (c) 2010-2013 Mads Møller

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
