

#import <UIKit/UIKit.h>
@import Photos;

@interface TWPhoto : NSObject

@property (nonatomic, readonly) UIImage *thumbnailImage;
@property (nonatomic, readonly) UIImage *originalImage;

@property (nonatomic, strong)   PHAsset *asset;

@end
