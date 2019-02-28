//
//  KSImagePickerViewerView.m
//  kinsun
//
//  Created by kinsun on 2018/12/4.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerViewerView.h"
#import "KSImagePickerToolBar.h"
#import "KSLayout.h"

@implementation KSImagePickerViewerView {
    __weak UIView *_toolBarSafeAreaView;
    __weak KSImagePickerToolBar *_bottomBar;
}

- (void)initView {
    [super initView];
    UIView *toolBarSafeAreaView = [[UIView alloc] init];
    toolBarSafeAreaView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5f];
    [self addSubview:toolBarSafeAreaView];
    _toolBarSafeAreaView = toolBarSafeAreaView;
    
    KSImagePickerToolBar *bottomBar = [[KSImagePickerToolBar alloc] initWithStyle:KSImagePickerToolBarStylePageNumber];
    [toolBarSafeAreaView addSubview:bottomBar];
    _bottomBar = bottomBar;
    
    KSImagePickerViewerNavigationView *navigationView = KSImagePickerViewerNavigationView.alloc.init;
    [self addSubview:navigationView];
    _navigationView = navigationView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    k_creatSizeElementOfSize(size);
    k_creatFrameElement;
    CGRect layoutFrame;
    if (@available(iOS 11.0, *)) {
        layoutFrame = self.safeAreaLayoutGuide.layoutFrame;
    } else {
        CGFloat s_height = UIApplication.sharedApplication.statusBarFrame.size.height+44.f;
        layoutFrame = (CGRect){0.f, s_height, windowWidth, windowHeight-s_height};
    }
    viewW = windowWidth; viewH = layoutFrame.origin.y;
    if (viewH == UIApplication.sharedApplication.statusBarFrame.size.height) {
        viewH += 44.f;
    }
    k_settingFrame(_navigationView);
    
    CGFloat safeBottomMargin = windowHeight-CGRectGetMaxY(layoutFrame);
    viewW = windowWidth; viewH = 48.f+safeBottomMargin; viewY = windowHeight-viewH;
    k_settingFrame(_toolBarSafeAreaView);
    
    viewY = 0.f; viewH = 48.f;
    k_settingFrame(_bottomBar);
}

- (void)setFullScreen:(BOOL)fullScreen {
    if (_fullScreen != fullScreen) {
        _fullScreen = fullScreen;
        
        KSImagePickerViewerNavigationView *navigationView = self.navigationView;
        navigationView.hidden = fullScreen;
        CATransition *trans = [CATransition animation];
        trans.duration = 0.3f;
        trans.type = kCATransitionPush;
        trans.subtype = fullScreen ? kCATransitionFromTop : kCATransitionFromBottom;
        [navigationView.layer addAnimation:trans forKey:nil];
        
        trans.subtype = fullScreen ? kCATransitionFromBottom : kCATransitionFromTop;
        _toolBarSafeAreaView.hidden = fullScreen;
        [_toolBarSafeAreaView.layer addAnimation:trans forKey:nil];
    }
}

- (void)setPageString:(NSString *)pageString {
    _bottomBar.pageNumberLabel.text = pageString;
    [self setNeedsLayout];
}

- (NSString *)pageString {
    return _bottomBar.pageNumberLabel.text;
}

- (UIButton *)doneButton {
    return _bottomBar.doneButton;
}

@end
