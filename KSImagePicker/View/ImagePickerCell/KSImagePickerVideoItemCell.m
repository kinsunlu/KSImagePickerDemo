//
//  KSImagePickerVideoItemCell.m
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerVideoItemCell.h"
#import "KSLayout.h"

@interface _KSIPVideoInfomationView : UIView

@property (nonatomic) NSString *text;

@end

@implementation _KSIPVideoInfomationView {
    __weak CAGradientLayer *_gradientLayer;
    __weak CALayer *_videoIndLayer;
    __weak CATextLayer *_textLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    UIColor *clearColor = UIColor.clearColor;
    self.backgroundColor = clearColor;
    
    CALayer *layer = self.layer;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor.blackColor colorWithAlphaComponent:0.8f].CGColor, (__bridge id)clearColor.CGColor];
    gradientLayer.startPoint = (CGPoint){0.5f, 1.f};
    gradientLayer.endPoint = (CGPoint){0.5f, 0.f};
    gradientLayer.locations = @[[NSNumber numberWithInteger:0], [NSNumber numberWithInteger:1]];
    [layer addSublayer:gradientLayer];
    _gradientLayer = gradientLayer;
    
    CALayer *videoIndLayer = [CALayer layer];
    videoIndLayer.contents = (id)[UIImage imageNamed:@"icon_ImagePicker_play"].CGImage;
    [layer addSublayer:videoIndLayer];
    _videoIndLayer = videoIndLayer;
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.wrapped = YES;
    textLayer.alignmentMode = kCAAlignmentRight;
    textLayer.contentsScale = k_SCREEN_SCALE;
    UIFont *font = [UIFont systemFontOfSize:12.f];
    CFStringRef fontCFString = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontCFString);
    textLayer.font = fontRef;
    CGFontRelease(fontRef);
    textLayer.fontSize = font.pointSize;
    textLayer.foregroundColor = UIColor.whiteColor.CGColor;
    [layer addSublayer:textLayer];
    _textLayer = textLayer;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    CGRect bounds = layer.bounds;
    _gradientLayer.frame = bounds;
    k_creatFrameElement;
    k_creatSizeElementOfSize(bounds.size);
    CGFloat margin = 8.f;
    viewW = viewH = 12.f; viewX = margin; viewY = (windowHeight-viewH)*0.5f;
    k_settingFrame(_videoIndLayer);
    
    viewX = CGRectGetMaxX(_videoIndLayer.frame); viewW = windowWidth-viewX-margin;
    viewH = _textLayer.fontSize; viewY = (windowHeight-viewH)*0.5f-1.f;
    k_settingFrame(_textLayer);
}

- (void)setText:(NSString *)text {
    _textLayer.string = text;
}

- (NSString *)text {
    return _textLayer.string;
}

@end

@implementation KSImagePickerVideoItemCell {
    __weak _KSIPVideoInfomationView *_infoView;
}

- (void)initView {
    [super initView];
    UIView *contentView = self.contentView;
    
    _KSIPVideoInfomationView *infoView = [[_KSIPVideoInfomationView alloc] init];
    [contentView addSubview:infoView];
    _infoView = infoView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    k_creatSizeElementOfSize(self.contentView.bounds.size);
    viewW = windowWidth; viewH = 20.f; viewX = 0.f; viewY = windowHeight-viewH;
    k_settingFrame(_infoView);
}

- (void)setItemModel:(KSImagePickerItemModel *)itemModel {
    [super setItemModel:itemModel];
    NSTimeInterval duration = itemModel.asset.duration;
    _infoView.text = [NSString stringWithFormat:@"%02.0f:%02td", duration/60.f, (NSInteger)duration%60];
}

@end
