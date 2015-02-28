//
//  TWImageScrollView.h
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWImageScrollView : UIScrollView

- (void)displayImage:(UIImage *)image;

- (UIImage *)capture;

@end
