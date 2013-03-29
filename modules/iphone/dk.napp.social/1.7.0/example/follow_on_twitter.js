/* 
By @dan_tamas. 

You will need the TiSocial.Framework module found here: https://github.com/viezel/TiSocial.Framework

tw_apps taken from here: https://github.com/chrismaddern/Follow-Me-On-Twitter-iOS-Button/blob/master/FollowMeButton.m by Chris Maddern.


Example:

var follow_tw = Titanium.UI.createButton({
    title:'Following ?',
    top:310,
    width:200,
    height:40,
	enabled:false
});


require('/backend/follow_on_twitter')({
	button:follow_tw,
	twitter_account:'dan_tamas',
	onFollow:function() {
		follow_tw.title = "Thnx for Following!";
		follow_tw.enabled = false;
	},
	onNotFollow: function() {
		follow_tw.enabled = true;
		follow_tw.title = 'Follow Me!'
	},
	onError: function(err) {
		if (err == 'No account') {
			follow_tw.enabled =  false;
			follow_tw.title = 'No Account Set'
		}
		else {
			alert(err);
		}
	}
});


*/







var tw_apps = [
	'twitter://user?screen_name={handle}', // Twitter
	'tweetbot:///user_profile/{handle}', // TweetBot
	'twitterrific:///profile?screen_name={handle}', // Twitteriffic
	'echofon:///user_timeline?{handle}', // Echofon              
	'twit:///user?screen_name={handle}', // Twittelator Pro
	'x-seesmic://twitter_profile?twitter_screen_name={handle}', // Seesmic
	'x-birdfeed://user?screen_name={handle}', // Birdfeed
	'tweetings:///user?screen_name={handle}', // Tweetings
	'simplytweet:?link=http://twitter.com/{handle}', // SimplyTweet
	'icebird://user?screen_name={handle}', // IceBird
	'fluttr://user/{handle}', // Fluttr
	'http://twitter.com/{handle}'
];

exports = function(params) {
	/*
		params.button  -  the button that will do the following
		params.twitter_account - the twitter account to be followed eg dan_tamas (without @ in front)
		params.onFollow -  callback to execute on following the user or if is already followed. This will trigger on iOS6 only
		params.onNotFollow -  callback to execute if the user is not followed. This will trigger on iOS6 only
		params.onError -  callback in case of an error. This will trigger on iOS6 only
		
		On iOS6 the button will have in fact 3 states: fetching follow status, following, not following
		On iOS5 the button will be "not following" only and will try to open a twitter application on the device
	*/

	var Social = require('dk.napp.social');

	if (Social.isTwitterSupported() && Social.isRequestTwitterSupported()) { //min iOS6 required
		Social.addEventListener("getFollow", function(e) { //default callback
			if (e.success && e.response[0] && e.response[0].connections.indexOf('following') > -1) {
				params.onFollow();
			} else {
				params.onNotFollow();
			}
		});

		Social.addEventListener("followMe", function(e) { //default callback
			if (e.success && e.response.following) {
				params.onFollow();
			} else {
				params.onNotFollow();
			}
		});

		Social.addEventListener("error", function(e){
			params.onError(e.status);
		});


		Social.requestTwitter({
			requestType:"GET",
			callbackEvent:'getFollow',
			url:"https://api.twitter.com/1.1/friendships/lookup.json"
			}, {
			'screen_name': params.twitter_account
		});
		
		Ti.API.info(97);
		
		
	}
	else {
		params.onNotFollow();
	}
	
	
	params.button.addEventListener('click', function(){
		if (Social.isRequestTwitterSupported()) { //min iOS6 required
			Social.requestTwitter({
				requestType:"POST",
				callbackEvent:'followMe',
				url:"https://api.twitter.com/1/friendships/create.json"
				}, {
				'screen_name': params.twitter_account
			});	
		}
		else {
			for (var i=0; i < tw_apps.length; i++) {
				var url = tw_apps[i].replace('{handle}',params.twitter_account);
				if (Ti.Platform.canOpenURL(url) ) {
					Ti.Platform.openURL(url);
					break;
				}
			};
		}
	});
};
