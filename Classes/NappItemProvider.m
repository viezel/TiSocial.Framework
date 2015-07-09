#import "NappItemProvider.h"

@implementation NappItemProvider
@synthesize customText = _customText;
@synthesize customHtmlText = _customHtmlText;

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
    if ([activityType isEqualToString:UIActivityTypeMail]) {
        NSString *text = [NSString stringWithFormat:@"%@%@%@", @"<html><head></head><body>", _customHtmlText, @"</body></html>"];
        NSLog(@"[INFO] Sharing the following as HTML %@",text);
        
        return text;
    }else{
    	NSString *nonhtmltext = [NSString stringWithFormat:@"%@", _customText];
        return nonhtmltext;
    }
    
    return @"";
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}
@end