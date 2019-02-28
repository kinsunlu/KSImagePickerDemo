//
//  KSImagePickerView.m
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerView.h"
#import "KSImagePickerToolBar.h"
#import "KSLayout.h"

@implementation KSImagePickerView {
    __weak UICollectionViewFlowLayout *_layout;
    __weak UIView *_toolBarSafeAreaView;
    __weak KSImagePickerToolBar *_toolBar;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = UIColor.whiteColor;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout = layout;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    collectionView.backgroundColor = UIColor.clearColor;
    collectionView.alwaysBounceVertical = YES;
    [self addSubview:collectionView];
    _collectionView = collectionView;
    
    UIColor *whiteColor = UIColor.whiteColor;
    
    UIView *toolBarSafeAreaView = [[UIView alloc] init];
    toolBarSafeAreaView.backgroundColor = whiteColor;
    [self addSubview:toolBarSafeAreaView];
    _toolBarSafeAreaView = toolBarSafeAreaView;
    
    KSImagePickerToolBar *toolBar = [[KSImagePickerToolBar alloc] init];
    [toolBarSafeAreaView addSubview:toolBar];
    _toolBar = toolBar;
    
    UITableView *albumTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    albumTableView.backgroundColor = whiteColor;
    if (@available(iOS 11.0, *)) {
        albumTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    albumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    albumTableView.rowHeight = 88.f;
    [self addSubview:albumTableView];
    _albumTableView = albumTableView;
    
    KSImagePickerNavigationView *navigationView = KSImagePickerNavigationView.alloc.init;
    [self addSubview:navigationView];
    _navigationView = navigationView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatSelfSizeElement;
    k_creatFrameElement;
    CGRect layoutFrame;
    if (@available(iOS 11.0, *)) {
        layoutFrame = self.safeAreaLayoutGuide.layoutFrame;
    } else {
        CGFloat s_height = UIApplication.sharedApplication.statusBarFrame.size.height+44.f;
        layoutFrame = (CGRect){0.f, s_height, windowWidth, windowHeight-s_height};
    }
    viewW = windowWidth; viewH = layoutFrame.origin.y;
    k_settingFrame(_navigationView);
    
    CGFloat safeBottomMargin = windowHeight-CGRectGetMaxY(layoutFrame);
    viewW = windowWidth; viewH = 48.f+safeBottomMargin; viewY = windowHeight-viewH;
    k_settingFrame(_toolBarSafeAreaView);
    
    viewY = 0.f; viewH = 48.f;
    k_settingFrame(_toolBar);
    
    CGFloat margin = 3.f;
    NSUInteger columnCount = 4;
    CGFloat itemW = floor((windowWidth-margin*(columnCount-1))/columnCount), itemH = itemW;
    UICollectionViewFlowLayout *layout = _layout;
    layout.itemSize = (CGSize){itemW, itemH};
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    layout.sectionInset = UIEdgeInsetsZero;
    
    _collectionView.frame = self.bounds;
    UIEdgeInsets inset = (UIEdgeInsets){_navigationView.frame.size.height, 0.f, _toolBarSafeAreaView.frame.size.height, 0.f};
    _collectionView.contentInset = inset;
    _collectionView.scrollIndicatorInsets = inset;
    
    _albumTableView.frame = self.bounds;
    CGRect frame = _albumTableView.frame;
    frame.origin.y = -windowHeight;
    _albumTableView.frame = frame;
    _albumTableView.contentInset = inset;
    _albumTableView.scrollIndicatorInsets = inset;
}

- (void)chengedAlbumListStatus {
    if (_showAlbumList) {
        [self hiddenAlbumList];
        _showAlbumList = NO;
    } else {
        [self showAlbumList];
        _showAlbumList = YES;
    }
}

- (void)showAlbumList {
    CGRect frame = _albumTableView.frame;
    frame.origin.y = 0.f;
    __weak UITableView *weakView = _albumTableView;
    [UIView animateWithDuration:0.2f animations:^{
        weakView.frame = frame;
    }];
}

- (void)hiddenAlbumList {
    CGRect frame = _albumTableView.frame;
    frame.origin.y = -self.bounds.size.height;
    __weak UITableView *weakView = _albumTableView;
    [UIView animateWithDuration:0.2f animations:^{
        weakView.frame = frame;
    }];
}

- (UIButton *)previewButton {
    return _toolBar.previewButton;
}

- (UIButton *)doneButton {
    return _toolBar.doneButton;
}

@end
