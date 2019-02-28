//
//  KSImagePickerView.h
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSImagePickerNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerView : UIView

@property (nonatomic, weak, readonly) KSImagePickerNavigationView *navigationView;
@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, weak, readonly) UITableView *albumTableView;

@property (nonatomic, readonly) UIButton *previewButton;
@property (nonatomic, readonly) UIButton *doneButton;

@property (nonatomic, assign, getter=isShowAlbumList, readonly) BOOL showAlbumList;

- (void)chengedAlbumListStatus;

@end

NS_ASSUME_NONNULL_END
