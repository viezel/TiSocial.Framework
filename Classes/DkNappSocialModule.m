/**
 * Module developed by Napp CMS
 * Mads Møller
 * 
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "DkNappSocialModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiApp.h"

//include Social and Accounts Frameworks
#import <Social/Social.h>
#import <Accounts/Accounts.h>

//for iOS5 twitter framework
#import <Twitter/Twitter.h>

@implementation DkNappSocialModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"8152d7fc-6edb-4c40-8d6f-bc2cef87bc1a";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"dk.napp.social";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

-(NSNumber*)isNetworkSupported:(NSString *)service {
    BOOL available = NO;
    if(NSClassFromString(@"SLComposeViewController")){
        if([SLComposeViewController isAvailableForServiceType:service]) {
            available=YES;
        }
    }
    return NUMBOOL(available); //This can call this to let them know if this feature is supported
}

-(NSNumber*)isActivitySupported {
    BOOL available = NO;
    if(NSClassFromString(@"UIActivityViewController")){
        available=YES;
    }
    return NUMBOOL(available); //This can call this to let them know if this feature is supported
}

-(NSNumber*)isTwitterSupported:(id)args {
    if(NSClassFromString(@"SLComposeViewController") != nil){
        return [self isNetworkSupported:SLServiceTypeTwitter];
    }else if(NSClassFromString(@"TWTweetComposeViewController") != nil){
        return NUMBOOL(YES);
    }else{
        return NUMBOOL(NO);
    }
}

-(NSNumber*)isFacebookSupported:(id)args {
    return [TiUtils isIOS6OrGreater]?[self isNetworkSupported:SLServiceTypeFacebook]:NUMBOOL(NO);
}

-(NSNumber*)isSinaWeiboSupported:(id)args {
    return [TiUtils isIOS6OrGreater]?[self isNetworkSupported:SLServiceTypeSinaWeibo]:NUMBOOL(NO);
}

-(NSNumber*)isActivityViewSupported:(id)args {
    return [TiUtils isIOS6OrGreater]?[self isActivitySupported]:NUMBOOL(NO);
}

-(UIImage *)findImage:(NSString *)imagePath
{
    if(imagePath != nil){
        UIImage *image = nil;
        
        // Load the image from the application assets
        NSString *fileNamePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imagePath];;
        image = [UIImage imageWithContentsOfFile:fileNamePath];
        if (image != nil) {
            //NSLog(@"application asset image found");
            return image;
        }
        
        //Load local image by extracting the filename without extension
        NSString* newImagePath = [[imagePath lastPathComponent] stringByDeletingPathExtension];
        image = [UIImage imageNamed:newImagePath];
        if(image != nil){
            //NSLog(@"local filepath extration image found");
            return image;
        }
        
        //image from URL
        image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
        if(image != nil){
            //NSLog(@"image from URL found");
            return image;
        }
        
        //load remote image
        image = [UIImage imageWithContentsOfFile:imagePath];
        if(image != nil){
            //NSLog(@"remote image found");
            return image;
        }
        NSLog(@"image NOT found");
    }
    return nil;
}



-(void)shareToNetwork:(NSString *)service args:(id)args {
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
 
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:service];
    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultCancelled) {
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",nil];
            [self fireEvent:@"cancelled" withObject:event];
        } else {
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",nil];
            [self fireEvent:@"complete" withObject:event];
        }
        [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler = myBlock;
    
    //get the properties from javascript
    NSString * shareText = [TiUtils stringValue:@"text" properties:args def:nil];
    NSString * shareUrl = [TiUtils stringValue:@"url" properties:args def:nil];
    NSString * shareImage = [TiUtils stringValue:@"image" properties:args def:nil];
    
    BOOL animated = [TiUtils boolValue:@"animated" properties:args def:YES];
    
    if (shareText != nil) {
        [controller setInitialText:shareText];
    }
    
    if (shareUrl != nil) {
        [controller addURL:[NSURL URLWithString:shareUrl]];
    }
    
    if (shareImage != nil) {
        [controller addImage: [self findImage:shareImage]];
    }
    
    [[TiApp app] showModalController:controller animated:animated];

}

/*
 *  Facebook
 */

-(void)facebook:(id)args{
    ENSURE_UI_THREAD(facebook, args);
    [self shareToNetwork:SLServiceTypeFacebook args:args];
}


-(void)requestFacebook:(id)args{
    NSDictionary *arguments = [args objectAtIndex:0];
    
    // Defaults
    NSDictionary *requestParameter = nil;
    NSArray *permissionsArray = nil;
    
    if([args count] > 1){
        requestParameter = [args objectAtIndex:1];
    }

    if(accountStore == nil){
        accountStore =  [[ACAccountStore alloc] init];
    }

    NSLog(@"[INFO] Requesting Facebook");
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *appId = [arguments objectForKey:@"appIdKey"];
    NSString *permissions = [arguments objectForKey:@"permissionsKey"];
    NSString *callbackEventName = [TiUtils stringValue:@"callbackEvent" properties:arguments def:@"facebookRequest"];
    
    
    // Append permissions
    if(permissions) {
       permissionsArray = [permissions componentsSeparatedByString:@","];
    }
    
    NSDictionary *options = @{
        ACFacebookAppIdKey: appId,
        ACFacebookAudienceKey: ACFacebookAudienceEveryone,
        ACFacebookPermissionsKey: permissionsArray
    };
    
    
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error){
        if (granted){
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            
            if ([arrayOfAccounts count] > 0) {
                ACAccount *fbAccount = [arrayOfAccounts lastObject];
                
                //requestType: GET, POST, DELETE
                NSInteger facebookRequestMethod = SLRequestMethodPOST;
                NSString *requestType = [[TiUtils stringValue:@"requestType" properties:arguments def:@"POST"] uppercaseString];
                
                if( [requestType isEqualToString:@"POST"] ){
                    facebookRequestMethod = SLRequestMethodPOST;
                } else if( [requestType isEqualToString:@"GET"] ){
                    facebookRequestMethod = SLRequestMethodGET;
                } else if( [requestType isEqualToString:@"DELETE"] ) {
                    facebookRequestMethod = SLRequestMethodDELETE;
                } else {
                    NSLog(@"[Social] no valid request method found - using POST");
                }
                
                //args
                NSString *requestURL = [arguments objectForKey:@"url"];
                
                if(requestURL != nil ){
 
                    SLRequest *fbRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                                   requestMethod:facebookRequestMethod
                                                                             URL:[NSURL URLWithString:requestURL]
                                                                      parameters:requestParameter];
                    [fbRequest setAccount:fbAccount];
                    [fbRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                        NSNumber *isSuccess;
                                        
                        if ([urlResponse statusCode] == 200) {
                            isSuccess = NUMBOOL(YES);
                        } else {
                            isSuccess = NUMBOOL(NO);
                        }
                        
                        NSArray *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys: isSuccess,@"success", response,@"response", nil];
                        [self fireEvent:callbackEventName withObject:event];
                    }];
                    
                } else {
                    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",@"Missing arguments",@"status",nil];
                    [self fireEvent:@"error" withObject:event];
                }
            }
        } else {
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",@"No account",@"status",nil];
            [self fireEvent:@"error" withObject:event];
        }
    }];
}



///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//                  TWITTER API
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////

-(void)twitter:(id)args{
    ENSURE_UI_THREAD(twitter, args);
    
    if(NSClassFromString(@"SLComposeViewController") != nil){
        [self shareToNetwork:SLServiceTypeTwitter args:args];
    }else{
        //iOS5 Support
        
        ENSURE_SINGLE_ARG(args, NSDictionary);
        
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            
            NSString *url = [args objectForKey:@"url"];
            NSString *message = [args objectForKey:@"text"];
            
            if (message != nil) {
                [tweetSheet setInitialText: message];
            }
            
            if (url != nil) {
                [tweetSheet addURL:[TiUtils toURL:url proxy:nil]];
            }
            
            tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result) {
	
			    if (result == TWTweetComposeViewControllerResultCancelled) {
			        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",nil];
			        [self fireEvent:@"cancelled" withObject:event];
			    } else {
			        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",nil];
			        [self fireEvent:@"complete" withObject:event];
			    }
	
	
	
                [[TiApp app] hideModalController:tweetSheet animated:YES];
                [tweetSheet release];
            };
            
            [[TiApp app] showModalController:tweetSheet animated:YES];
        }
    }
}

/**
 * args[0] - requestType, url
 * args[1] - requestParameter
 *
 */
-(void)requestTwitter:(id)args {
    NSDictionary *arguments = [args objectAtIndex:0];
    
    // Defaults
    NSDictionary *requestParameter = nil;
    
    if([args count] > 1){
        requestParameter = [args objectAtIndex:1];
    }
    
    if(accountStore == nil){
        accountStore =  [[ACAccountStore alloc] init];
    }

    NSLog(@"[INFO] Requesting Twitter");
   
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
    
    NSString *callbackEventName = [TiUtils stringValue:@"callbackEvent" properties:arguments def:@"twitterRequest"];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted == YES){
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            
            if ([arrayOfAccounts count] > 0) {
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                
                //requestType: GET, POST, DELETE
                NSInteger requestMethod = SLRequestMethodPOST;
                NSString *requestType = [[TiUtils stringValue:@"requestType" properties:arguments def:@"POST"] uppercaseString];
                
                if( [requestType isEqualToString:@"POST"] ){
                    requestMethod = SLRequestMethodPOST;
                } else if( [requestType isEqualToString:@"GET"] ){
                    requestMethod = SLRequestMethodGET;
                } else if( [requestType isEqualToString:@"DELETE"] ) {
                    requestMethod = SLRequestMethodDELETE;
                } else {
                    NSLog(@"[Social] no valid request method found - using POST");
                }
                
                //args
                NSString *requestURL = [TiUtils stringValue:@"url" properties:arguments def:nil];
                
                if(requestURL != nil){
                    
                    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                            requestMethod:requestMethod
                                                                            URL:[NSURL URLWithString:requestURL]
                                                                            parameters:requestParameter];
                    [twitterRequest setAccount:twitterAccount];
                    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                         NSNumber *isSuccess;
                         if ([urlResponse statusCode] == 200) {
                             isSuccess = NUMBOOL(YES);
                         } else {
                             isSuccess = NUMBOOL(NO);
                         }
                         //NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                         NSArray *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                         NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys: isSuccess,@"success", response,@"response", nil];
                         [self fireEvent:callbackEventName withObject:event];
                     }];
                    
                } else {
                    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",@"Missing arguments",@"status",nil];
                    [self fireEvent:@"error" withObject:event];
                }
            }
        } else {
            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",@"No account",@"status",nil];
            [self fireEvent:@"error" withObject:event];
        }
    }];
}

/*
 *  Sina Weibo
 */

-(void)sinaweibo:(id)args{
    ENSURE_UI_THREAD(sinaweibo, args);
    [self shareToNetwork:SLServiceTypeSinaWeibo args:args];
}





///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
//                  UIActivityViewController
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////



-(void)activityView:(id)args{
    ENSURE_UI_THREAD(activityView, args);
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    //get the properties from javascript
    NSString * shareText = [TiUtils stringValue:@"text" properties:args def:@""];
    
    NSString * shareImage = [TiUtils stringValue:@"image" properties:args def:nil];
    NSString * removeIcons = [TiUtils stringValue:@"removeIcons" properties:args def:nil];
    
    UIImage *image = [self findImage:shareImage];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareText,image , nil];
    UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems: activityItems applicationActivities:nil];
    
    //custom
    if(removeIcons != nil){
        
        NSDictionary *iconMapping = @{
            @"twitter": UIActivityTypePostToTwitter,
            @"facebook": UIActivityTypePostToFacebook,
            @"mail": UIActivityTypeMail,
            @"sms": UIActivityTypeMessage,
            @"copy": UIActivityTypeCopyToPasteboard,
            @"contact": UIActivityTypeAssignToContact,
            @"weibo": UIActivityTypePostToWeibo,
            @"print": UIActivityTypePrint,
            @"camera": UIActivityTypeSaveToCameraRoll
            
        };
        
        NSArray *icons = [removeIcons componentsSeparatedByString:@","];
        NSMutableArray *excludedIcons = [[NSMutableArray alloc] init];
        for( int i = 0; i < [icons count]; i++ )
        {
            NSString * str = [icons objectAtIndex:i];
            [excludedIcons addObject:[iconMapping objectForKey:str]];
        }
        [avc setExcludedActivityTypes:excludedIcons];
    }
    
    [avc setCompletionHandler:^(NSString *act, BOOL done)
     {
         if (!done) {
             NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",nil];
             [self fireEvent:@"cancelled" withObject:event];
         } else {
             NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"success",nil];
             [self fireEvent:@"complete" withObject:event];
         }
         
         
     }];
    
    [[TiApp app] showModalController:avc animated:YES];
}

@end