#import <UIKit/UIKit.h>

@interface NappItemProvider : UIActivityItemProvider
@property (nonatomic, strong) NSString *customText;
@property (nonatomic, strong) NSString *customHtmlText;
@property (nonatomic, strong) NSString *customTwitterText;
@property (nonatomic, strong) NSString *customFacebookText;
@end