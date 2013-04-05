/**
 * Module developed by Napp CMS
 * Mads Møller
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import <Accounts/Accounts.h>

@interface DkNappSocialModule : TiModule
{
    ACAccountStore* accountStore;
	UIPopoverController *popoverController;
}

@property(nonatomic,readonly) NSNumber *ACTIVITY_FACEBOOK;
@property(nonatomic,readonly) NSNumber *ACTIVITY_TWITTER;
@property(nonatomic,readonly) NSNumber *ACTIVITY_WEIBO;
@property(nonatomic,readonly) NSNumber *ACTIVITY_MESSAGE;
@property(nonatomic,readonly) NSNumber *ACTIVITY_MAIL;
@property(nonatomic,readonly) NSNumber *ACTIVITY_PRINT;
@property(nonatomic,readonly) NSNumber *ACTIVITY_COPY;
@property(nonatomic,readonly) NSNumber *ACTIVITY_ASSIGN_CONTATCT;
@property(nonatomic,readonly) NSNumber *ACTIVITY_SAVE_CAMERA;
@property(nonatomic,readonly) NSNumber *ACTIVITY_CUSTOM;

@end
