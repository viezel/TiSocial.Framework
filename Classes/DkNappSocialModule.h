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
}
@end
