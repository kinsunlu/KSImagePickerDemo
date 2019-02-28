//
//  KSImagePickerAlbumCell.m
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerAlbumCell.h"
#import "KSLayout.h"

@implementation KSImagePickerAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    UIImageView *imageView = self.imageView;
    imageView.image = [UIImage imageNamed:@"icon_transparent"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    UILabel *textLabel = self.textLabel;
    textLabel.font = [UIFont systemFontOfSize:18.f];
    textLabel.textColor = UIColor.blackColor;
    
    UILabel *detailTextLabel = self.detailTextLabel;
    detailTextLabel.font = [UIFont systemFontOfSize:15.f];
    detailTextLabel.textColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    k_creatSizeElementOfSize(self.contentView.bounds.size);
    
    UIImageView *imageView = self.imageView;
    viewW = viewH = 70.f; viewX = 18.f; viewY = 9.f;
    k_settingFrame(imageView);
    
    UILabel *textLabel = self.textLabel;
    viewX = CGRectGetMaxX(imageView.frame)+12.f; viewW = windowWidth-viewX-18.f; viewH = (windowHeight-18.f)*0.5f;
    k_settingFrame(textLabel);
    
    UILabel *detailTextLabel = self.detailTextLabel;
    viewY = CGRectGetMaxY(textLabel.frame);
    k_settingFrame(detailTextLabel);
}

- (void)setAlbumModel:(KSImagePickerAlbumModel *)albumModel {
    _albumModel = albumModel;
    KSImagePickerItemModel *itemModel = albumModel.assetList.lastObject;
    __weak typeof(self) weakSelf = self;
    [[PHImageManager defaultManager] requestImageForAsset:itemModel.asset targetSize:(CGSize){70.f, 70.f} contentMode:PHImageContentModeAspectFill options:KSImagePickerItemModel.pictureViewerOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.imageView.image = result;
    }];
    self.textLabel.text = albumModel.albumTitle;
    self.detailTextLabel.text = [NSNumber numberWithUnsignedInteger:albumModel.assetList.count].stringValue;
}

@end
