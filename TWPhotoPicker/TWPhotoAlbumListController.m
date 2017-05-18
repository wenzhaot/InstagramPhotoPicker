//
//  TWPhotoAlbumListController.m
//  Speis
//
//  Created by Pawan on 26/12/16.
//  Copyright © 2016 Pawan. All rights reserved.
//

#import "TWPhotoAlbumListController.h"

static NSString *cellIdentifier = @"AlbumListCell";

@interface TWPhotoAlbumListController ()
@property (nonatomic) NSMutableArray *assetCollections;
@end

@implementation TWPhotoAlbumListController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    _assetCollections = [NSMutableArray array];
    
    //
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    
    // Get smart album list
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
        // Check if collection has images
        PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
        fetchOptions.predicate = [NSPredicate predicateWithFormat:@"mediaType == %d",PHAssetMediaTypeImage];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:fetchOptions];
        //
        if (fetchResult.count > 0) {
            [self.assetCollections addObject:collection];
        }
        if (stop) {
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.assetCollections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Fetch images
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHAssetCollection *assetCollection = [self.assetCollections objectAtIndex:indexPath.row];
    PHFetchResult *fetchResult = [PHAsset fetchKeyAssetsInAssetCollection:assetCollection options:fetchOptions];
    //
    PHAsset *asset = [fetchResult firstObject];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    //
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat dimension = 100.0f;
    CGSize size = CGSizeMake(dimension*scale, dimension*scale);
    //
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        cell.imageView.image = result;
    }];
    
    cell.textLabel.text = assetCollection.localizedTitle;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *assetCollection = [self.assetCollections objectAtIndex:indexPath.row];
    [self.delegate didFinishWithAlbumSelection:assetCollection];
}
@end
