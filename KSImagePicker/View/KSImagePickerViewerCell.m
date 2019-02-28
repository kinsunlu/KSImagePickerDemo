//
//  KSImagePickerViewerCell.m
//  kinsun
//
//  Created by kinsun on 2018/12/4.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerViewerCell.h"
#import "KSLayout.h"

@implementation KSImagePickerViewerCell
@dynamic mainView, data;

- (void)initCell {
    [super initCell];

    UIImageView *imageView = [[UIImageView alloc] init];
    [self.scrollView addSubview:imageView];
    self.mainView = imageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self settingImageViewFrameWithImage:self.mainView.image];
}

- (void)setData:(KSImagePickerItemModel *)data {
    [super setData:data];
    UIScrollView *scrollView = self.scrollView;
    scrollView.contentSize = scrollView.bounds.size;
    scrollView.contentOffset = CGPointZero;
    
    UIImageView *imageView = self.mainView;
    imageView.transform = CGAffineTransformIdentity;
    
    PHAsset *asset = data.asset;
    CGSize size = self.bounds.size;
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:KSImagePickerItemModel.pictureViewerOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [weakSelf settingImageViewFrameWithImage:result];
        imageView.image = result;
    }];
}

- (void)settingImageViewFrameWithImage:(UIImage *)image {
    if (image != nil) {
        UIScrollView *scrollView = self.scrollView;
        UIImageView *imageView = self.mainView;
        k_creatFrameElement;
        k_creatSizeElementOfSize(scrollView.bounds.size);
        CGSize size = image.size;
        viewW = windowWidth; viewH = size.height/size.width*viewW;
        if (viewH < windowHeight) {
            viewH = windowHeight;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
        } else {
            imageView.contentMode = UIViewContentModeScaleToFill;
        }
        k_settingFrame(imageView);
        scrollView.contentSize = imageView.bounds.size;
    }
}

- (CGRect)mainViewFrameInSuperView {
    UIImageView *imageView = self.mainView;
    UIScrollView *scrollView = self.scrollView;
    return [KSMediaViewerController transitionThumbViewFrameInSuperView:scrollView atImage:imageView.image];
}

@end
