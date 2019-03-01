//
//  KSImagePickerViewerController.m
//  kinsun
//
//  Created by kinsun on 2018/12/4.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerViewerController.h"
#import "KSImagePickerViewerView.h"
#import "KSImagePickerViewerCell.h"
#import "KSImagePickerViewerVideoCell.h"

#import "KSImagePickerAlbumModel.h"

@interface KSImagePickerViewerController ()

@property (nonatomic, strong) KSImagePickerViewerView *view;

@end

@implementation KSImagePickerViewerController
@dynamic view, dataArray;

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES];
}

- (void)dismissViewControllerAnimated:(BOOL)animated {
    if (self.navigationController == nil) {
        [self dismissViewControllerAnimated:animated completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

static NSString * const k_iden1 = @"KSImagePickerViewerCell";
static NSString * const k_iden2 = @"KSImagePickerViewerVideoCell";
- (KSMediaViewerView *)loadMediaViewerView {
    KSImagePickerViewerView *view = [[KSImagePickerViewerView alloc] init];
    
    KSImagePickerViewerNavigationView *navigationView = view.navigationView;
    [navigationView.backButton addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    KSImagePickerSelectIndicator *selectIndicator = navigationView.selectIndicator;
    BOOL selectIndicatorHidden = _didClickDoneButtonCallback == nil;
    if (selectIndicatorHidden) {
        selectIndicator.hidden = selectIndicatorHidden;
    } else {
        selectIndicator.multipleSelected = _multipleSelected;
        [selectIndicator addTarget:self action:@selector(didClickSelectIndicator:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton *doneButton = view.doneButton;
    doneButton.enabled = YES;
    [doneButton addTarget:self action:@selector(didClickButton) forControlEvents:UIControlEventTouchUpInside];
    UICollectionView *collectionView = view.collectionView;
    [collectionView registerClass:KSImagePickerViewerCell.class forCellWithReuseIdentifier:k_iden1];
    [collectionView registerClass:KSImagePickerViewerVideoCell.class forCellWithReuseIdentifier:k_iden2];
    return view;
}

- (void)didClickSelectIndicator:(KSImagePickerSelectIndicator *)selectIndicator {
    if (_didClickSelectButtonCallback != nil) {
        selectIndicator.index = _didClickSelectButtonCallback(self.currentIndex);
    }
}

- (void)didClickButton {
    if (_didClickDoneButtonCallback != nil) {
        _didClickDoneButtonCallback(self, self.currentIndex);
    }
}

- (KSMediaViewerCell *)mediaViewerCellAtIndexPath:(NSIndexPath *)indexPath data:(KSImagePickerItemModel *)data ofCollectionView:(UICollectionView *)collectionView {
    switch (data.asset.mediaType) {
        case PHAssetMediaTypeImage:
            return [collectionView dequeueReusableCellWithReuseIdentifier:k_iden1 forIndexPath:indexPath];
        case PHAssetMediaTypeVideo:
            return [collectionView dequeueReusableCellWithReuseIdentifier:k_iden2 forIndexPath:indexPath];
        default:
            return nil;
    }
}

- (void)didClickViewCurrentItem {
    KSImagePickerViewerView *view = self.view;
    BOOL isFullScreen = !view.isFullScreen;
    view.fullScreen = isFullScreen;
//    [self setStatusBarHidden:isFullScreen withAnimation:UIStatusBarAnimationSlide];
}

- (void)mediaViewerCellWillBeganPan {
    [super mediaViewerCellWillBeganPan];
    self.view.fullScreen = YES;
}

- (void)currentIndexDidChanged:(NSInteger)currentIndex {
    [super currentIndexDidChanged:currentIndex];
    KSImagePickerViewerVideoCell *cell = self.currentCell;
    if ([cell isKindOfClass:KSImagePickerViewerVideoCell.class]) {
        [cell.mainView play];
    }
    NSArray <KSImagePickerItemModel *> *dataArray = self.dataArray;
    KSImagePickerItemModel *data = [dataArray objectAtIndex:currentIndex];
    self.view.navigationView.selectIndicator.index = data.index;
    self.view.pageString = [NSString stringWithFormat:@"%td/%td", currentIndex+1, dataArray.count];
}

- (void)setDataArray:(NSArray <KSImagePickerItemModel *> *)dataArray currentIndex:(NSInteger)currentIndex {
    [super setDataArray:dataArray currentIndex:currentIndex];
}

- (UIImage *)currentThumb {
    return [self.dataArray objectAtIndex:self.currentIndex].thumb;
}

- (void)setMultipleSelected:(BOOL)multipleSelected {
    _multipleSelected = multipleSelected;
    if (self.viewLoaded) {
        self.view.navigationView.selectIndicator.multipleSelected = multipleSelected;
    }
}

@end
