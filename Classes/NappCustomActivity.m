/**
 * Module developed by Napp CMS
 * Mads Møller
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */

#import "NappCustomActivity.h"

@interface NappCustomActivity()

@property (copy, nonatomic) NSArray *activityItems;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) TiModule *module;

@end

@implementation NappCustomActivity


#pragma mark - Hierarchy
#pragma mark UIActivity

- (NSString *)activityType
{
    return self.type;
}

- (NSString *)activityTitle
{
    return self.title;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    self.activityItems = activityItems;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (UIImage *)activityImage
{
    return self.image;
}

- (UIViewController *)activityViewController {
    NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys: self.title,@"title", self.type,@"type", nil];
    [self.module fireEvent:@"customActivity" withObject:event];
    [self activityDidFinish:YES];
    return nil;
}

#pragma mark - Self
#pragma mark NappCustomActivity

- (UIViewController *)performWithActivityItems:(NSArray *)activityItems {
    [self activityDidFinish:YES];
}

-(id)initWithSettings:(NSDictionary *)dict{
    self = [super init];
    if(self) {
        self.type = [dict objectForKey:@"type"];
        self.title = [dict objectForKey:@"title"];
        self.image = [dict objectForKey:@"image"];
        self.module = [dict objectForKey:@"module"];
    }
    return(self);
}

@end
