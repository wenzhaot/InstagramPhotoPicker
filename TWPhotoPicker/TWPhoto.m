//
//  TWPhoto.m
//  Pods
//
//  Created by Emar on 4/30/15.
//
//

#import "TWPhoto.h"

@implementation TWPhoto

- (UIImage *)thumbnailImage {
    __block UIImage *blockThumbnailImage = nil;
    //
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    // Set target image size
    NSInteger retinaMultiplier = [UIScreen mainScreen].scale;
    CGSize retinaSquare = CGSizeMake(300,300);
    //
    [[PHImageManager defaultManager]
     requestImageForAsset:(PHAsset *)_asset
     targetSize:retinaSquare
     contentMode:PHImageContentModeAspectFill
     options:options
     resultHandler:^(UIImage *result, NSDictionary *info) {
         blockThumbnailImage =[UIImage imageWithCGImage:result.CGImage scale:retinaMultiplier orientation:result.imageOrientation];
     }];
    // Wait until image not retrived
    while (!blockThumbnailImage) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return blockThumbnailImage;
}

- (UIImage *)originalImage {
    __block UIImage *blockOriginalImage = nil;
    //
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = true; // // this one is key
    //
    [[PHImageManager defaultManager]
     requestImageForAsset:(PHAsset *)_asset
     targetSize:PHImageManagerMaximumSize
     contentMode:PHImageContentModeAspectFill
     options:options
     resultHandler:^(UIImage *result, NSDictionary *info) {
         blockOriginalImage = result;
     }];
    // Wait until image not retrived
    while (!blockOriginalImage) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    return blockOriginalImage;
}

@end
