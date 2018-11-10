//
//  DkNappSocialImageProvider.m
//  social
//
//  Created by João Paulo Pinheiro Teixeira on 25/09/14.
//
//

#import "NappImageProvider.h"

@implementation NappImageProvider
@synthesize facebookImage = _facebookImage;
@synthesize twitterImage = _twitterImage;
@synthesize defaultImage = _defaultImage;

- (void)dealloc {
  [_facebookImage release];
  [_twitterImage release];
  [_defaultImage release];

  [super dealloc];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController
         itemForActivityType:(NSString *)activityType {

  if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
    NSLog(@"%@", _facebookImage);
    return [self findImage:_facebookImage];
  }
  if ([activityType isEqualToString:UIActivityTypePostToTwitter] && _twitterImage) {
    return [self findImage:_twitterImage];
  }

  return [self findImage:_defaultImage];
}

- (id)item {
  return @"";
}
- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
  return @"";
}

- (UIImage *)findImage:(NSString *)imagePath {
  if (imagePath != nil) {
    UIImage *image = nil;

    // Load the image from the application assets
    NSString *fileNamePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imagePath];
    ;
    image = [UIImage imageWithContentsOfFile:fileNamePath];
    if (image != nil) {
      return image;
    }

    //Load local image by extracting the filename without extension
    NSString *newImagePath = [[imagePath lastPathComponent] stringByDeletingPathExtension];
    image = [UIImage imageNamed:newImagePath];
    if (image != nil) {
      return image;
    }

    //image from URL
    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
    if (image != nil) {
      return image;
    }

    //load remote image
    image = [UIImage imageWithContentsOfFile:imagePath];
    if (image != nil) {
      return image;
    }
    NSLog(@"image NOT found");
  }
  return nil;
}

@end
