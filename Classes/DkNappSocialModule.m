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

//include SOCIAL.Framework
#import <Social/Social.h>

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

/**
 * These are the types available for communicating with the social.framework
 * SLServiceTypeFacebook,
 * SLServiceTypeTwitter,
 * SLServiceTypeSinaWeibo
 */

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


-(void)twitter:(id)args{
    ENSURE_UI_THREAD(twitter, args);
    [self shareToNetwork:SLServiceTypeTwitter args:args];
}

-(void)sinaweibo:(id)args{
    ENSURE_UI_THREAD(sinaweibo, args);
    [self shareToNetwork:SLServiceTypeSinaWeibo args:args];
}

@end