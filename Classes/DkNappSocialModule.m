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
-(NSNumber*)isNetworkSupported:(NSString *)service {
    BOOL available = NO;
    if(NSClassFromString(@"SLComposeViewController")){
        if([SLComposeViewController isAvailableForServiceType:service]) {
            available=YES;
        }
    }
    return NUMBOOL(available); //This can call this to let them know if this feature is supported
}

-(NSNumber*)isTwitterSupported:(id)args {
    return [self isNetworkSupported:SLServiceTypeTwitter];
}

-(NSNumber*)isFacebookSupported:(id)args {
    return [self isNetworkSupported:SLServiceTypeFacebook];
}

-(NSNumber*)isSinaWeiboSupported:(id)args {
    return [self isNetworkSupported:SLServiceTypeSinaWeibo];
}



-(void)shareToNetwork:(NSString *)service args:(id)args {
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    if([SLComposeViewController isAvailableForServiceType:service]) {
        
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
        controller.completionHandler =myBlock;
        
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
            [controller addImage:[UIImage imageNamed:shareImage]];
        }
        
        [[TiApp app] showModalController:controller animated:animated];
        
    }
    else{
        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"success",nil];
        [self fireEvent:@"error" withObject:event];
    }
}

-(void)facebook:(id)args{
    ENSURE_UI_THREAD(facebook, args);
    [self shareToNetwork:SLServiceTypeFacebook args:args];
}


-(void)requestFacebook:(id)args{
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    if(accountStore == nil){
        accountStore =  [[ACAccountStore alloc] init];
    }
    
    NSLog(@"[INFO] Requesting Facebook");
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSString *appId = [TiUtils stringValue:@"appIdKey" properties:args def:nil];
    NSString *permissionsKey = [TiUtils stringValue:@"permissionsKey" properties:args def:nil];
    
    NSDictionary *options = @{
        ACFacebookAppIdKey: appId,
        ACFacebookAudienceKey: ACFacebookAudienceEveryone,
        ACFacebookPermissionsKey: @[permissionsKey]
    };
    
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error){
        if (granted){
            NSArray *arrayOfAccounts = [accountStore accountsWithAccountType:accountType];
            
            NSLog(@"[INFO] Number of Facebook Accounts: %@", [arrayOfAccounts count]);
            
            if ([arrayOfAccounts count] > 0) {
                ACAccount *fbAccount = [arrayOfAccounts lastObject];
                
                //requestType: GET, POST, DELETE
                NSInteger facebookRequestMethod = SLRequestMethodPOST;
                NSString *requestType = [[TiUtils stringValue:@"requestType" properties:args def:@"POST"] uppercaseString];
                
                NSLog(@"[INFO] Request type: %@", requestType);

                if( [requestType isEqualToString:@"POST"] ){
                    facebookRequestMethod = SLRequestMethodPOST;
                } else if( [requestType isEqualToString:@"GET"] ){
                    facebookRequestMethod = SLRequestMethodGET;
                } else {
                    facebookRequestMethod = SLRequestMethodDELETE;
                }
                
                //args
                NSString *requestURL = [TiUtils stringValue:@"url" properties:args def:nil];
                
                NSLog(@"[INFO] Request URL: %@", requestURL);
                
                if(requestURL != nil ){
 
                    SLRequest *fbRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                                   requestMethod:facebookRequestMethod
                                                                             URL:[NSURL URLWithString:requestURL]
                                                                      parameters:nil];
                    [fbRequest setAccount:fbAccount];
                    [fbRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error){
                        NSNumber *isSuccess;
                        if ([urlResponse statusCode] == 200) {
                            isSuccess = NUMBOOL(YES);
                        } else {
                            isSuccess = NUMBOOL(NO);
                        }
                        //NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                        NSArray *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                        NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys: isSuccess,@"success", response,@"response", nil];
                        [self fireEvent:@"facebookRequest" withObject:event];
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
    [self shareToNetwork:SLServiceTypeTwitter args:args];
}

-(void)sinaweibo:(id)args{
    ENSURE_UI_THREAD(sinaweibo, args);
    [self shareToNetwork:SLServiceTypeSinaWeibo args:args];
}

/**
 * requestType, url, requestParameterKey, requestParameterVariable
 *
 */
-(void)requestTwitter:(id)args {
    ENSURE_SINGLE_ARG_OR_NIL(args, NSDictionary);
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted == YES){
            NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
            if ([arrayOfAccounts count] > 0) {
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                
                //requestType: GET, POST, DELETE
                NSInteger twRequestMethod = SLRequestMethodPOST;
                NSString *requestType = [[TiUtils stringValue:@"requestType" properties:args def:@"POST"] uppercaseString];
                if( [requestType isEqualToString:@"POST"] ){
                    twRequestMethod = SLRequestMethodPOST;
                } else if( [requestType isEqualToString:@"GET"] ){
                    twRequestMethod = SLRequestMethodGET;
                } else {
                    twRequestMethod = SLRequestMethodDELETE;
                }
                
                //args
                NSString *requestURL = [TiUtils stringValue:@"url" properties:args def:nil];
                NSString *requestParameterKey = [TiUtils stringValue:@"requestParameterKey" properties:args def:nil];
                NSString *requestParameterVariable = [TiUtils stringValue:@"requestParameterVariable" properties:args def:nil];
                
                if(requestURL != nil && requestParameterKey != nil && requestParameterVariable != nil ){
                    
                    NSDictionary *param = @{requestParameterKey: requestParameterVariable};
                    SLRequest *twitterRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                                            requestMethod:twRequestMethod
                                                                            URL:[NSURL URLWithString:requestURL]
                                                                            parameters:param];
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
                         [self fireEvent:@"twitterRequest" withObject:event];
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

@end