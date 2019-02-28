//
//  KSImagePickerViewerVideoCell.m
//  kinsun
//
//  Created by kinsun on 2018/12/11.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerViewerVideoCell.h"

@implementation KSImagePickerViewerVideoCell
@dynamic mainView, data;

- (void)initCell {
    [super initCell];
    UIScrollView *scrollView = self.scrollView;
    scrollView.maximumZoomScale = 1.f;
    
    KSVideoPlayerLiteView *player = [[KSVideoPlayerLiteView alloc] init];
    player.coverView.contentMode = UIViewContentModeScaleAspectFit;
    __weak typeof(self) weakSelf = self;
    [player setVideoPlaybackFinished:^{
        [weakSelf.mainView play];
    }];
    [scrollView addSubview:player];
    self.mainView = player;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.mainView.frame = self.scrollView.bounds;
}

- (void)setData:(KSImagePickerItemModel *)data {
    [super setData:data];
    PHAsset *asset = data.asset;
    CGSize size = self.bounds.size;
    PHImageManager *mgr = PHImageManager.defaultManager;
    __weak typeof(self) weakSelf = self;
    [mgr requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:KSImagePickerItemModel.pictureViewerOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [weakSelf setImage:result];
    }];
    [mgr requestAVAssetForVideo:asset options:KSImagePickerItemModel.videoOptions resultHandler:^(AVAsset *urlAsset, AVAudioMix *audioMix, NSDictionary *info) {
        [weakSelf setVideoAsset:urlAsset];
    }];
}

- (void)setImage:(UIImage *)image {
    self.mainView.coverView.image = image;
}

- (void)setVideoAsset:(AVAsset *)videoAsset {
    dispatch_async(dispatch_get_main_queue(), ^{
        KSVideoPlayerLiteView *player = self.mainView;
        player.playerItem = [[AVPlayerItem alloc] initWithAsset:videoAsset];
        [player play];
    });
}

- (CGRect)mainViewFrameInSuperView {
    KSVideoPlayerLiteView *player = self.mainView;
    UIView *wrapperView = self.superview;
    UIView *view = wrapperView.superview;
    CGRect frame = [self.scrollView convertRect:player.frame toView:view];
    return frame;
}

@end
