#import "NappItemProvider.h"

@implementation NappItemProvider

@synthesize customText = _customText;
@synthesize customTextMail = _customTextMail;

@synthesize shareURL = _shareURL;
@synthesize platformAppendText = _platformAppendText;

@synthesize URL = _URL; // facebook only allowes one URL and a image, URL must be NSURL testje


- (id)initWithPlaceholderItem:(id)placeholderItem
{
    return [super initWithPlaceholderItem:placeholderItem];
}

- (id)item
{
    return @"";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    
    NSString *text;
    NSURL *url;
    
    NSLog(@"[INFO] activityType: %@", activityType);

    
    // mail
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        
        if(_customTextMail) {
            text = [NSString stringWithFormat:@"%@%@%@", @"<html><head></head><body>", _customTextMail, @"</body></html>"];
            NSLog(@"[INFO] Sharing the following as HTML %@",text);
        } else {
            text = _customText;
        }

        return text;
    }
    
    if(_platformAppendText == nil) {
        return text = _customText;
    }
    
    // twitter
    if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
  
        return [_customText stringByAppendingString:[_platformAppendText objectForKey:@"twitter"]];
        
    }
    
    // facebook
    // no additional data supported, so return only URL
    else if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        
        url = _URL;
        return url;
    }
    
    // message
    else if ([activityType isEqualToString:UIActivityTypeMessage]) {
        
        return [_customText stringByAppendingString:[_platformAppendText objectForKey:@"message"]];
    }

    else if ([activityType isEqualToString:@"net.whatsapp.WhatsApp.ShareExtension"]) {
        
        return [_customText stringByAppendingString:[_platformAppendText objectForKey:@"whatsapp"]];
        
    }
    
    // Fallback, check if activityType exists in platformAppendText
    else if([_platformAppendText objectForKey:activityType] != nil) {
        return [_customText stringByAppendingString:[_platformAppendText objectForKey:activityType]];
    }
    
    return text = _customText;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}
@end