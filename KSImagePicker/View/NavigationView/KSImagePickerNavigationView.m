//
//  KSImagePickerNavigationView.m
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerNavigationView.h"
#import "KSTriangleIndicatorButton.h"
#import "KSLayout.h"

@implementation KSImagePickerNavigationView {
    __weak KSTriangleIndicatorButton *_centerButton;
}
@synthesize centerButton = _centerButton;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initView];
    }
    return self;
}

- (void)_initView {
    KSTriangleIndicatorButton *centerButton = [[KSTriangleIndicatorButton alloc] init];
    centerButton.font = [UIFont systemFontOfSize:18.f];
    centerButton.color = UIColor.blackColor;
    [self addSubview:centerButton];
    _centerButton = centerButton;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    CGFloat windowWidth = self.bounds.size.width;
    CGRect backButtonFrame = self.backButton.frame;
    
    viewY = backButtonFrame.origin.y;
    viewH = backButtonFrame.size.height;
    viewX = CGRectGetMaxX(backButtonFrame);
    CGFloat maxWidth = windowWidth-viewX*2.f;
    viewW = [_centerButton sizeThatFits:(CGSize){maxWidth, viewH}].width;
    viewX = (windowWidth-viewW)*0.5f;
    k_settingFrame(_centerButton);
}

- (void)setTitle:(NSString *)title {
    _centerButton.text = title;
    [self setNeedsLayout];
}

- (NSString *)title {
    return _centerButton.text;
}

@end
