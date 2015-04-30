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
    return [UIImage imageWithCGImage:self.asset.thumbnail];
}

- (UIImage *)originalImage {
    return [UIImage imageWithCGImage:self.asset.defaultRepresentation.fullResolutionImage
                               scale:self.asset.defaultRepresentation.scale
                         orientation:(UIImageOrientation)self.asset.defaultRepresentation.orientation];
}

@end
