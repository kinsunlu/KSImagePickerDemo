//
//  KSImagePickerCameraCell.m
//  kinsun
//
//  Created by kinsun on 2018/12/3.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerCameraCell.h"
#import <AVKit/AVKit.h>

@implementation KSImagePickerCameraCell {
    AVCaptureSession *_captureSession;
    __weak AVCaptureVideoPreviewLayer *_previewLayer;
    
    UIView *_maskView;
}

- (void)initView {
    UIView *contentView = self.contentView;

#if !TARGET_IPHONE_SIMULATOR
    AVCaptureSession *captureSession = [[AVCaptureSession alloc] init];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPresetLow]) {
        captureSession.sessionPreset = AVCaptureSessionPresetLow;
    }
    _captureSession = captureSession;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].firstObject;
    NSError *error = nil;
    AVCaptureDeviceInput *captureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    if ([captureSession canAddInput:captureDeviceInput]) {
        [captureSession addInput:captureDeviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:captureSession];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [contentView.layer addSublayer:previewLayer];
    _previewLayer = previewLayer;

#endif
    
    UIView *maskView = [[UIView alloc] init];
    maskView.backgroundColor = UIColor.blackColor;
    maskView.hidden = YES;
    [contentView addSubview:maskView];
    _maskView = maskView;
    
    [super initView];
    
    UIImageView *imageView = self.imageView;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"icon_ImagePicker_camera"];
    imageView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.3f];

#if !TARGET_IPHONE_SIMULATOR
    [captureSession startRunning];
#endif
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _maskView.frame = self.contentView.bounds;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    _previewLayer.frame = self.contentView.layer.bounds;
}

- (void)setLoseFocus:(BOOL)loseFocus {
    [super setLoseFocus:loseFocus];
    _maskView.hidden = !loseFocus;
    self.imageView.alpha = loseFocus ? 0.5f : 1.f;
}

- (void)dealloc {
    [_captureSession stopRunning];
}

@end
