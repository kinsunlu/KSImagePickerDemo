//
//  KSImagePickerItemCell.m
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerItemCell.h"
#import "KSImagePickerSelectIndicator.h"
#import "KSLayout.h"

@implementation KSImagePickerItemCell {
    __weak CALayer *_shelterLayer;
    __weak KSImagePickerSelectIndicator *_indView;
}

- (void)initView {
    [super initView];
    UIView *contentView = self.contentView;
    
    KSImagePickerSelectIndicator *indView = [[KSImagePickerSelectIndicator alloc] init];
    [indView addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:indView];
    _indView = indView;
    
    CALayer *shelterLayer = [CALayer layer];
    shelterLayer.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.5f].CGColor;
    shelterLayer.hidden = YES;
    [self.contentView.layer addSublayer:shelterLayer];
    _shelterLayer = shelterLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    viewW = viewH = 36.f; viewX = self.contentView.bounds.size.width-viewW;
    k_settingFrame(_indView);
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    _shelterLayer.frame = self.contentView.layer.bounds;
}

- (void)selectedItem:(KSImagePickerSelectIndicator *)ind {
    if (_didSelectedItem != nil) {
        NSUInteger index = _didSelectedItem(self);
        ind.index = index;
        self.itemModel.index = index;
    }
}

- (void)setItemModel:(KSImagePickerItemModel *)itemModel {
    [super setItemModel:itemModel];
    UIImage *thumb = itemModel.thumb;
    if (thumb == nil) {
        __weak typeof(self) weakSelf = self;
        [[PHImageManager defaultManager] requestImageForAsset:itemModel.asset targetSize:KSImagePickerItemModel.thumbSize contentMode:PHImageContentModeAspectFit options:KSImagePickerItemModel.pictureViewerOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [weakSelf updateThumb:result];
        }];
    } else {
        self.imageView.image = thumb;
    }
    _indView.index = itemModel.index;
}

- (void)updateThumb:(UIImage *)thumb {
    self.itemModel.thumb = thumb;
    self.imageView.image = thumb;
}


- (void)setLoseFocus:(BOOL)loseFocus {
    [super setLoseFocus:loseFocus];
    _shelterLayer.hidden = !loseFocus;
}

- (void)setMultipleSelected:(BOOL)multipleSelected {
    _indView.multipleSelected = multipleSelected;
}

- (BOOL)isMultipleSelected {
    return _indView.isMultipleSelected;
}

@end
