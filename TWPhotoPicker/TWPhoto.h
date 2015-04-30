

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TWPhoto : NSObject

@property (nonatomic, readonly) UIImage *thumbnailImage;
@property (nonatomic, readonly) UIImage *originalImage;

@property (nonatomic, strong) ALAsset *asset;

@end
