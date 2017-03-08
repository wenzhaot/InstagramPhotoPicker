//
//  TWImageLoader.h
//  Pods
//
//  Created by Emar on 4/30/15.
//
//

#import <Foundation/Foundation.h>
#import "TWPhoto.h"

@interface TWPhotoLoader : NSObject
@property (strong, nonatomic) PHAssetCollection *assetsCollection;

//
+ (TWPhotoLoader *)sharedLoader;
- (void)loadAllPhotos:(void (^)(NSArray *photos, NSError *error))completion;

@end
