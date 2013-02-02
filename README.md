# TiSocial.Framework Module

## Description

The TiSocial.Framework Module extends the Appcelerator Titanium Mobile framework with the iOS6 social.framework. This enables sharing content to Facebook, Twitter and other platforms.

The module is licensed under the MIT license.


![SLComposeViewController](http://s7.postimage.org/tjrcwqtdn/SLCompose_View_Controller.png)
![UIActivityViewController](http://s14.postimage.org/y85v7ev1t/UIActivity_View_Controller.png)



## Referencing the module in your Titanium Mobile application ##

Simply add the following lines to your `tiapp.xml` file:
    
    <modules>
        <module version="1.5" platform="iphone">dk.napp.social</module> 
    </modules>


## Reference

For more detailed code examples take a look into the example app

### Twitter

#### Social.isTwitterSupported()
Returns *true* or *false*.  
false if no account has been defined (true in the 6.0 simulator) or the iOS Version doesn't support the Social Framework.

#### Social.twitter(*{Object} options*)
`options` can have the following keys:

* *text* - the status message
* *image* - a local/remote path to an image you want to share
* *url* - a url you want to share

Each of these options is optional

#### Social.twitterRequest(*{Object} options [, {Object} requestParameter]*)
`options`has the following keys:

* *requestType* - can be *GET*, *POST* or *DELETE*
* *url* - the url you want to request
* *callbackEvent* - optional - default: *facebookRequest* - how is the event called that is fired after request has succeeded?

`requestParameter` is optional, but is build like this:

	{
		'screen_name': 'C_BHole'
	}

So *screen_name* is the parameter name / key and *C_BHole* is the value of the parameter

### Facebook

#### Social.isFacebookSupported()
Returns *true* or *false*.  
false if no account has been defined (true in the 6.0 simulator) or the iOS Version doesn't support the Social Framework.

#### Social.facebook(*{Object} options*)
`options` can have the following keys:

* *text* - the status message
* *image* - a local/remote path to an image you want to share
* *url* - a url you want to share

Each of these options is optional

#### Social.facebookRequest(*{Object} options [, {Object} requestParameter]*)
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

### Sina Weibo

#### Social.isSinaWeiboSupported()
Returns *true* or *false*.  
false if no account has been defined (true in the 6.0 simulator) or the iOS Version doesn't support the Social Framework.

#### Social.sinaweibo(*{Object} options*)
`options` can have the following keys:

* *text* - the status message
* *image* - a local/remote path to an image you want to share
* *url* - a url you want to share

Each of these options is optional


### UIActivityViewController

#### Social.activityView()
`options` can have the following keys:

* *text* - the status message
* *image* - a local/remote path to an image you want to share
* *removeIcons* - customise the dialog by removing unwanted icons.

## Changelog

**v1.5.1**
Bugfixes.
Added `isRequestTwitterSupported()` for iOS6 check

**v1.5**
UIActivityViewController implemented.
Improved image filepath finder (bundle, data, remote, url)

**v1.4**  
Support for iOS5 Twiiter Framework.

**v1.3**  
Different parameter setup for `requestFacebook()` and `requestTwitter()`.  
Now supporting Wall posting and more request parameter.

**v1.2**  
Added support to share image from downloaded remote images in cache or documents folders.
Added support to share image from image urls. 

**v1.1**  
SLRequest methods implemented. `requestFacebook()` and `requestTwitter()`. 

**v1.0**  
Initial Implementation of SLComposeViewController. 


## Author

**Mads Møller**  
web: http://www.napp.dk  
email: mm@napp.dk  
twitter: @nappdev  

## Contributors

**Christopher Beloch**  
twitter: @C_BHole

**Jongeun Lee**  
twitter: @yomybaby

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