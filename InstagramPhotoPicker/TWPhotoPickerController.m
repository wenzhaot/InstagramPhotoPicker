//
//  TWPhotoPickerController.m
//  InstagramPhotoPicker
//
//  Created by Emar on 12/4/14.
//  Copyright (c) 2014 wenzhaot. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "TWPhotoPickerController.h"
#import "TWPhotoCollectionViewCell.h"
#import "TWImageScrollView.h"

@interface TWPhotoPickerController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    CGFloat beginOriginY;
}
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) TWImageScrollView *imageScrollView;

@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) UICollectionView *collectionView;
@end

@implementation TWPhotoPickerController

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.topView];
    [self.view insertSubview:self.collectionView belowSubview:self.topView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadPhotos];
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

- (void)loadPhotos {
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
    };
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        if ([group numberOfAssets] > 0)
        {
            if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
            }
        }
        
        if (group == nil) {
            if (self.assets.count) {
                UIImage *image = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:0] defaultRepresentation] fullResolutionImage]];
                [self.imageScrollView displayImage:image];
            }
            [self.collectionView reloadData];
        }
        
        
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
        NSLog(@"Load Photos Error: %@", error);
    }];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIView *)topView {
    if (_topView == nil) {
        CGFloat handleHeight = 44.0f;
        CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetWidth(self.view.bounds)+handleHeight*2);
        self.topView = [[UIView alloc] initWithFrame:rect];
        self.topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        self.topView.backgroundColor = [UIColor clearColor];
        self.topView.clipsToBounds = YES;
        
        rect = CGRectMake(0, 0, CGRectGetWidth(self.topView.bounds), handleHeight);
        UIView *navView = [[UIView alloc] initWithFrame:rect];
        navView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:.8f];
        [self.topView addSubview:navView];
        
        rect = CGRectMake(0, 0, 80, CGRectGetHeight(navView.bounds));
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = rect;
        [backBtn setTitle:@"Back" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:backBtn];
        
        rect = CGRectMake((CGRectGetWidth(navView.bounds)-100)/2, 0, 100, CGRectGetHeight(navView.bounds));
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:rect];
        titleLabel.text = @"选择";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [navView addSubview:titleLabel];
        
        rect = CGRectMake(0, CGRectGetHeight(self.topView.bounds)-handleHeight, CGRectGetWidth(self.topView.bounds), handleHeight);
        UIView *dragView = [[UIView alloc] initWithFrame:rect];
        dragView.backgroundColor = navView.backgroundColor;
        dragView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.topView addSubview:dragView];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [dragView addGestureRecognizer:panGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
        [dragView addGestureRecognizer:tapGesture];
        
        [tapGesture requireGestureRecognizerToFail:panGesture];
        
        rect = CGRectMake(0, handleHeight, CGRectGetWidth(self.topView.bounds), CGRectGetHeight(self.topView.bounds)-handleHeight*2);
        self.imageScrollView = [[TWImageScrollView alloc] initWithFrame:rect];
        [self.topView addSubview:self.imageScrollView];
        [self.topView sendSubviewToBack:self.imageScrollView];
    }
    return _topView;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize                     = CGSizeMake(78, 78);
        layout.sectionInset                 = UIEdgeInsetsMake(1.0, 2.0, 1.0, 2.0);
        layout.minimumInteritemSpacing      = 1.0;
        layout.minimumLineSpacing           = 1.0;
        
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.topView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.topView.bounds));
        self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        [self.collectionView registerClass:[TWPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"TWPhotoCollectionViewCell"];
    }
    return _collectionView;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state)
    {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGRect topFrame = self.topView.frame;
            CGFloat endOriginY = self.topView.frame.origin.y;
            if (endOriginY > beginOriginY) {
                topFrame.origin.y = (endOriginY - beginOriginY) >= 20 ? 0 : -(CGRectGetHeight(self.topView.bounds)-20-44);
            } else if (endOriginY < beginOriginY) {
                topFrame.origin.y = (beginOriginY - endOriginY) >= 20 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
            }
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            [UIView animateWithDuration:.3f animations:^{
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }];
            break;
        }
        case UIGestureRecognizerStateBegan:
        {
            beginOriginY = self.topView.frame.origin.y;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            CGRect topFrame = self.topView.frame;
            topFrame.origin.y = translation.y + beginOriginY;
            
            CGRect collectionFrame = self.collectionView.frame;
            collectionFrame.origin.y = CGRectGetMaxY(topFrame);
            collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
            
            if (topFrame.origin.y <= 0 && (topFrame.origin.y >= -(CGRectGetHeight(self.topView.bounds)-20-44))) {
                self.topView.frame = topFrame;
                self.collectionView.frame = collectionFrame;
            }
            
            break;
        }
        default:
            break;
    }
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGesture {
    CGRect topFrame = self.topView.frame;
    topFrame.origin.y = topFrame.origin.y == 0 ? -(CGRectGetHeight(self.topView.bounds)-20-44) : 0;
    
    CGRect collectionFrame = self.collectionView.frame;
    collectionFrame.origin.y = CGRectGetMaxY(topFrame);
    collectionFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(topFrame);
    [UIView animateWithDuration:.3f animations:^{
        self.topView.frame = topFrame;
        self.collectionView.frame = collectionFrame;
    }];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TWPhotoCollectionViewCell";
    
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:[[self.assets objectAtIndex:indexPath.row] thumbnail]];
    
    return cell;
}

#pragma mark - Collection View Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [UIImage imageWithCGImage:[[[self.assets objectAtIndex:indexPath.row] defaultRepresentation] fullResolutionImage]];
    [self.imageScrollView displayImage:image];
    if (self.topView.frame.origin.y != 0) {
        [self tapGestureAction:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
