//
//  KSImagePickerToolBar.m
//  kinsun
//
//  Created by kinsun on 2019/1/7.
//

#import "KSImagePickerToolBar.h"
#import "KSGradientButton.h"
#import "KSLayout.h"

@implementation KSImagePickerToolBar {
    __weak UIView *_lineView;
}

- (instancetype)initWithStyle:(KSImagePickerToolBarStyle)style {
    return [self initWithFrame:CGRectZero style:style];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame style:KSImagePickerToolBarStylePreview];
}

- (instancetype)initWithFrame:(CGRect)frame style:(KSImagePickerToolBarStyle)style {
    if (self = [super initWithFrame:frame]) {
        _style = style;
        [self _initView];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = UIColor.clearColor;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColor.lightGrayColor;
    [self addSubview:lineView];
    _lineView = lineView;
    
    if (_style == KSImagePickerToolBarStylePreview) {
        UIButton *previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previewButton.enabled = NO;
        previewButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [previewButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [previewButton setTitleColor:[UIColor.blackColor colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
        [previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [self addSubview:previewButton];
        _previewButton = previewButton;
    } else {
        UILabel *pageNumberLabel = [[UILabel alloc] init];
        pageNumberLabel.font = [UIFont systemFontOfSize:16.f];
        pageNumberLabel.textColor = UIColor.whiteColor;
        [self addSubview:pageNumberLabel];
        _pageNumberLabel = pageNumberLabel;
    }
    
    KSGradientButton *doneButton = [KSGradientButton buttonWithType:UIButtonTypeCustom];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    doneButton.layer.masksToBounds = YES;
    doneButton.enabled = NO;
    [self addSubview:doneButton];
    _doneButton = doneButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    CGSize windowSize = self.bounds.size;
    k_creatSizeElementOfSize(windowSize);
    viewW = windowWidth; viewH = 0.5f;
    k_settingFrame(_lineView);
    
    CGSize size = [_doneButton sizeThatFits:windowSize];
    viewW = size.width+40.f; viewH = 28.f;
    viewX = windowWidth-viewW-18.f; viewY = (windowHeight-viewH)*0.5f;
    k_settingFrame(_doneButton);
    _doneButton.layer.cornerRadius = viewH*0.5f;
    
    if (_style == KSImagePickerToolBarStylePreview) {
        viewX = viewY = 0.f;
        size = [_previewButton sizeThatFits:windowSize];
        viewW = size.width+40.f; viewH = windowHeight;
        k_settingFrame(_previewButton);
    } else {
        viewX = 20.f; viewY = 0.f; viewH = windowHeight;
        viewW = _doneButton.frame.origin.x-viewX;
        k_settingFrame(_pageNumberLabel);
    }
}

@end
