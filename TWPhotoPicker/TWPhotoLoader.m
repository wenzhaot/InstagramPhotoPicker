//
//  TWImageLoader.m
//  Pods
//
//  Created by Emar on 4/30/15.
//
//

#import "TWPhotoLoader.h"

@interface TWPhotoLoader ()
@property (strong, nonatomic) NSMutableArray *allPhotos;
@property (readwrite, copy, nonatomic) void(^loadBlock)(NSArray *photos, NSError *error);
@end



@implementation TWPhotoLoader

+ (TWPhotoLoader *)sharedLoader {
    static TWPhotoLoader *loader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[TWPhotoLoader alloc] init];
    });
    return loader;
}

- (void)loadAllPhotos:(void (^)(NSArray *photos, NSError *error))completion {
    
    [self.allPhotos removeAllObjects]; /* added this line to remove assets duplication*/
    [self setLoadBlock:completion];
    [self startLoading];
}

-(void)startLoading {
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:self.assetsCollection options:fetchOptions];
    //
    if ([fetchResult count] > 0) {
        for (PHAsset *asset in fetchResult) {
            TWPhoto *photo = [TWPhoto new];
            photo.asset = asset;
            [self.allPhotos insertObject:photo atIndex:0];
        }
    }
    //
    self.loadBlock(self.allPhotos, nil);
}

- (NSMutableArray *)allPhotos {
    if (_allPhotos == nil) {
        _allPhotos = [NSMutableArray array];
    }
    return _allPhotos;
}

-(PHAssetCollection *)assetsCollection {
    if (!_assetsCollection) {
        PHFetchResult *result = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        _assetsCollection = result.firstObject;
    }
    return _assetsCollection;
}

@end
