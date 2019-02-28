//
//  KSNavigationView.m
//  KSImagePickerDemo
//
//  Created by kinsun on 2019/2/28.
//  Copyright © 2019年 kinsun. All rights reserved.
//

#import "KSNavigationView.h"
#import "KSLayout.h"

@interface KSNavigationView ()

@property (nonatomic, strong, readonly, class) UIImage *_whiteBackIconImage;
@property (nonatomic, strong, readonly, class) UIImage *_blackBackIconImage;

@end

@implementation KSNavigationView {
    __weak UIView *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self willFinishInit];
        self.style = KSNavigationViewStyleLight;
    }
    return self;
}

- (void)willFinishInit {
    self.tintColor = UIColor.whiteColor;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.imageView.contentMode = UIViewContentModeLeft;
    backButton.imageEdgeInsets = (UIEdgeInsets){0.f, 0.f, 0.f, -10.f};
    [self addSubview:backButton];
    _backButton = backButton;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.userInteractionEnabled = NO;
    [self addSubview:lineView];
    _lineView = lineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    k_creatSelfSizeElement;
    
    CGFloat statusBarHeight = CGRectGetMaxY(UIApplication.sharedApplication.statusBarFrame);
    viewY = statusBarHeight; viewW = 60.f; viewH = windowHeight-viewY;
    k_settingFrame(_backButton);
    
    viewX = 0.f; viewH = 0.5f; viewW = windowWidth; viewY = windowHeight-viewH;
    k_settingFrame(_lineView);
}

- (void)setStyle:(KSNavigationViewStyle)style {
    _style = style;
    UIImage *image = nil;
    switch (style) {
        case KSNavigationViewStyleLight:
            self.backgroundColor = UIColor.whiteColor;
            _lineView.backgroundColor = UIColor.lightGrayColor;
            _lineView.hidden = NO;
            image = [self.class _blackBackIconImage];
            break;
        case KSNavigationViewStyleDark:
            self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
            _lineView.backgroundColor = UIColor.whiteColor;
            _lineView.hidden = NO;
            image = self.class._whiteBackIconImage;
            break;
        case KSNavigationViewStyleClear:
            self.backgroundColor = UIColor.clearColor;
            _lineView.hidden = YES;
            image = self.class._whiteBackIconImage;
            break;
    }
    [self.backButton setImage:image forState:UIControlStateNormal];
}

static UIImage *k_whiteBackIconImage = nil;
+ (UIImage *)_whiteBackIconImage {
    if (k_whiteBackIconImage == nil) {
        k_whiteBackIconImage = [self._blackBackIconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return k_whiteBackIconImage;
}

static UIImage *k_blackBackIconImage = nil;
+ (UIImage *)_blackBackIconImage {
    if (k_blackBackIconImage == nil) {
        k_blackBackIconImage = [UIImage imageNamed:@"icon_navigation_back"];
    }
    return k_blackBackIconImage;
}

@end
