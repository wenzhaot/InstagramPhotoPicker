//
//  TWPhotoCollectionViewCell.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import "TWPhotoCollectionViewCell.h"

@implementation TWPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.imageView.layer.borderColor = [UIColor blueColor].CGColor;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    self.imageView.layer.borderWidth = selected ? 2 : 0;
}

@end
