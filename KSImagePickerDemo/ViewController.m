//
//  ViewController.m
//  KSImagePickerDemo
//
//  Created by kinsun on 2019/2/28.
//  Copyright © 2019年 kinsun. All rights reserved.
//

#import "ViewController.h"
#import "KSVideoPlayerLiteView.h"
#import "KSLayout.h"
#import "KSNavigationController.h"
#import "KSImagePickerController.h"
#import "KSImagePickerItemModel.h"

@interface ViewController () <KSImagePickerControllerDelegate>

@property (nonatomic, strong) UIScrollView *view;

@end

@implementation ViewController {
    __weak UIImageView *_imageView;
    __weak UIButton *_pictrueButton;
    __weak KSVideoPlayerLiteView *_videoView;
    __weak UIButton *_videoButton;
}
@dynamic view;

- (void)loadView {
    UIScrollView *scrollView = UIScrollView.alloc.init;
    scrollView.backgroundColor = UIColor.whiteColor;
    
    UIImageView *imageView = UIImageView.alloc.init;
    imageView.backgroundColor = UIColor.lightGrayColor;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    CALayer *layer = imageView.layer;
    layer.borderColor = UIColor.blackColor.CGColor;
    layer.borderWidth = 1.f;
    [scrollView addSubview:imageView];
    _imageView = imageView;
    
    UIButton *pictrueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pictrueButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [pictrueButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [pictrueButton setTitle:@"选择照片" forState:UIControlStateNormal];
    [pictrueButton addTarget:self action:@selector(didClickPictrueButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:pictrueButton];
    _pictrueButton = pictrueButton;
    
    KSVideoPlayerLiteView *videoView = KSVideoPlayerLiteView.alloc.init;
    videoView.videoGravity = KSVideoLayerGravityResizeAspect;
    CALayer *videoLayer = videoView.layer;
    videoLayer.borderColor = UIColor.blackColor.CGColor;
    videoLayer.borderWidth = 1.f;
    [scrollView addSubview:videoView];
    _videoView = videoView;
    
    UIButton *videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    videoButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [videoButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [videoButton setTitle:@"选择视频" forState:UIControlStateNormal];
    [videoButton addTarget:self action:@selector(didClickVideoButton:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:videoButton];
    _videoButton = videoButton;
    
    self.view = scrollView;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIScrollView *view = self.view;
    k_creatFrameElement;
    CGFloat windowWidth = view.bounds.size.width;
    
    CGFloat egdeMarginH = 20.f;
    CGFloat egdeMarginV = 40.f;
    viewX = egdeMarginH; viewY = egdeMarginV;
    viewW = windowWidth-egdeMarginH*2.f;
    viewH = ceil(viewW*1.3f);
    k_settingFrame(_imageView);
    
    viewY = CGRectGetMaxY(_imageView.frame);
    viewH = _pictrueButton.titleLabel.font.lineHeight+20.f;
    k_settingFrame(_pictrueButton);
    
    viewY = CGRectGetMaxY(_pictrueButton.frame);
    viewH = floor(viewW*.5625f);
    k_settingFrame(_videoView);
    
    viewY = CGRectGetMaxY(_videoView.frame);
    viewH = _videoButton.titleLabel.font.lineHeight+20.f;
    k_settingFrame(_videoButton);
    
    view.contentSize = (CGSize){0.f, CGRectGetMaxY(_videoButton.frame)+egdeMarginV};
}

- (void)didClickPictrueButton:(UIButton *)pictrueButton {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择模式" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *normal = [UIAlertAction actionWithTitle:@"单选模式(带编辑照片)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *normalString = @"Normal";
        NSString *circularString = @"Circular";
        
        void (^handler)(UIAlertAction *) = ^(UIAlertAction *action) {
            KSImagePickerEditPictureStyle style = action.title == normalString ? KSImagePickerEditPictureStyleNormal : KSImagePickerEditPictureStyleCircular;
            KSImagePickerController *ctl = [KSImagePickerController.alloc initWithEditPictureStyle:style];
            ctl.delegate = weakSelf;
            KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        };
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择PHImagePickerEditPictureStyle" message:@"PHImagePickerEditPictureStyleNormal为正常模式。\nPHImagePickerEditPictureStyleCircular为圆圈模式，一般用于选择用户头像。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *normal = [UIAlertAction actionWithTitle:normalString style:UIAlertActionStyleDefault handler:handler];
        [alert addAction:normal];
        
        UIAlertAction *circular = [UIAlertAction actionWithTitle:circularString style:UIAlertActionStyleDefault handler:handler];
        [alert addAction:circular];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
    [alert addAction:normal];
    
    UIAlertAction *circular = [UIAlertAction actionWithTitle:@"多选模式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入多选数量" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        __weak __block UITextField *k_textField = nil;
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.text = @"9";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            k_textField = textField;
        }];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSInteger number = k_textField.text.integerValue;
            KSImagePickerController *ctl = [KSImagePickerController.alloc initWithMediaType:KSImagePickerMediaTypePicture maxItemCount:number];
            ctl.delegate = weakSelf;
            KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
            [weakSelf presentViewController:nav animated:YES completion:nil];
        }];
        [alert addAction:ok];
        
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
    [alert addAction:circular];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didClickVideoButton:(UIButton *)videoButton {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入最大选择数量" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __block UITextField *k_textField = nil;
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = @"1";
        textField.keyboardType = UIKeyboardTypeNumberPad;
        k_textField = textField;
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger number = k_textField.text.integerValue;
        KSImagePickerController *ctl = [KSImagePickerController.alloc initWithMediaType:KSImagePickerMediaTypeVideo maxItemCount:number];
        ctl.delegate = weakSelf;
        KSNavigationController *nav = [KSNavigationController.alloc initWithRootViewController:ctl];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    }];
    [alert addAction:ok];
    
    [weakSelf presentViewController:alert animated:YES completion:nil];
}

- (void)imagePicker:(KSImagePickerController *)imagePicker didFinishSelectedAssetModelArray:(NSArray<KSImagePickerItemModel *> *)assetModelArray ofMediaType:(KSImagePickerMediaType)mediatype {
    switch (mediatype) {
        case KSImagePickerMediaTypePicture: {
            PHAsset *asset = assetModelArray.firstObject.asset;
            CGSize size = self.view.bounds.size;
            PHImageManager *mgr = PHImageManager.defaultManager;
            __weak typeof(_imageView) weakView = _imageView;
            [mgr requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:KSImagePickerItemModel.pictureViewerOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                weakView.image = result;
            }];
        }
            break;
        case KSImagePickerMediaTypeVideo: {
            PHAsset *asset = assetModelArray.firstObject.asset;
            PHImageManager *mgr = PHImageManager.defaultManager;
            __weak typeof(self) weakSelf = self;
            [mgr requestAVAssetForVideo:asset options:KSImagePickerItemModel.videoOptions resultHandler:^(AVAsset *urlAsset, AVAudioMix *audioMix, NSDictionary *info) {
                [weakSelf setVideoAsset:urlAsset];
            }];
        }
            break;
    }
}

- (void)imagePicker:(KSImagePickerController *)imagePicker didFinishSelectedImageArray:(NSArray<UIImage *> *)imageArray {
    _imageView.image = imageArray.firstObject;
}

- (void)imagePicker:(KSImagePickerController *)imagePicker didFinishSelectedVideoArray:(NSArray<AVURLAsset *> *)videoArray {
    [self setVideoAsset:videoArray.firstObject];
}

- (void)setVideoAsset:(AVAsset *)videoAsset {
    __weak typeof(_videoView) weakView = _videoView;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakView.playerItem = [[AVPlayerItem alloc] initWithAsset:videoAsset];
        [weakView play];
    });
}

@end
