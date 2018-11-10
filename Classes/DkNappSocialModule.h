/**
 * Module developed by Napp CMS
 * Mads Møller
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "TiModule.h"
#import "TiViewController.h"
#import <Accounts/Accounts.h>

@interface DkNappSocialModule : TiModule <UIPopoverControllerDelegate, UIPopoverPresentationControllerDelegate> {
  ACAccountStore *accountStore;
  CGRect popoverRect;
  UIPopoverController *popoverController;
  UIViewController *viewController;
  id senderButton;
}

@property (nonatomic, readonly) NSString *ACTIVITY_FACEBOOK;
@property (nonatomic, readonly) NSString *ACTIVITY_TWITTER;
@property (nonatomic, readonly) NSString *ACTIVITY_WEIBO;
@property (nonatomic, readonly) NSString *ACTIVITY_MESSAGE;
@property (nonatomic, readonly) NSString *ACTIVITY_MAIL;
@property (nonatomic, readonly) NSString *ACTIVITY_PRINT;
@property (nonatomic, readonly) NSString *ACTIVITY_COPY;
@property (nonatomic, readonly) NSString *ACTIVITY_ASSIGN_CONTACT;
@property (nonatomic, readonly) NSString *ACTIVITY_SAVE_CAMERA;
@property (nonatomic, readonly) NSString *ACTIVITY_READING_LIST;
@property (nonatomic, readonly) NSString *ACTIVITY_FLICKR;
@property (nonatomic, readonly) NSString *ACTIVITY_VIMEO;
@property (nonatomic, readonly) NSString *ACTIVITY_AIRDROP;
@property (nonatomic, readonly) NSString *ACTIVITY_TENCENT_WEIBO;
@property (nonatomic, readonly) NSString *ACTIVITY_OPEN_IN_IBOOKS;
@property (nonatomic, readonly) NSString *ACTIVITY_MARKUP_AS_PDF;
@property (nonatomic, readonly) NSString *ACTIVITY_CUSTOM;

@end
