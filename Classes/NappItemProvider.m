#import "NappItemProvider.h"

@implementation NappItemProvider
@synthesize customText = _customText;
@synthesize customHtmlText = _customHtmlText;

- (void)dealloc {
  [_customText release];
  [_customHtmlText release];
  [_customTwitterText release];

  [super dealloc];
}

- (id)initWithPlaceholderItem:(id)placeholderItem {
  return [super initWithPlaceholderItem:placeholderItem];
}

- (id)item {
  return @"";
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
  if ([activityType isEqualToString:UIActivityTypeMail]) {
    NSString *text = [NSString stringWithFormat:@"%@%@%@", @"<html><head></head><body>", _customHtmlText, @"</body></html>"];
    NSLog(@"[INFO] Sharing the following as HTML %@", text);

    return text;
  } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
    NSString *customTwitterText = [NSString stringWithFormat:@"%@", _customTwitterText];
    return customTwitterText;
  } else {
    NSString *nonhtmltext = [NSString stringWithFormat:@"%@", _customText];
    return nonhtmltext;
  }

  return @"";
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
  return @"";
}
@end
