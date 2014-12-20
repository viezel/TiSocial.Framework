#import "NappItemProvider.h"

@implementation NappItemProvider
@synthesize customText = _customText;

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
        NSString *text = [NSString stringWithFormat:@"%@%@%@", @"<html><head></head><body>", _customText, @"</body></html>"];
        NSLog(@"[INFO] Sharing the following as HTML %@",text);
        
        return text;
    }
    
    return @"";
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"";
}
@end