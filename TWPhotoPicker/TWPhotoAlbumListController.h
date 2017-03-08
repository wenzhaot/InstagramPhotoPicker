//
//  TWPhotoAlbumListController.h
//  Speis
//
//  Created by Pawan on 26/12/16.
//  Copyright © 2016 Pawan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@protocol PhotoAlbumDelegate <NSObject>
-(void)didFinishWithAlbumSelection:(PHAssetCollection *)selectedAlbum;
@end

@interface TWPhotoAlbumListController : UITableViewController
@property (nonatomic, weak) id <PhotoAlbumDelegate> delegate;
@end
