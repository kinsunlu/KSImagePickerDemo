//
//  KSImagePickerEditPictureNavigationView.m
//  KSImagePickerDemo
//
//  Created by kinsun on 2019/2/28.
//  Copyright © 2019年 kinsun. All rights reserved.
//

#import "KSImagePickerEditPictureNavigationView.h"
#import "KSLayout.h"

@implementation KSImagePickerEditPictureNavigationView

- (void)willFinishInit {
    [super willFinishInit];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    titleLabel.textColor = UIColor.whiteColor;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [doneButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    _doneButton = doneButton;
    [self addSubview:doneButton];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    CGFloat windowWidth = self.bounds.size.width;
    CGRect backButtonFrame = self.backButton.frame;
    
    viewY = backButtonFrame.origin.y;
    viewH = backButtonFrame.size.height;
    viewW = [_doneButton sizeThatFits:(CGSize){windowWidth, viewH}].width+40.f;
    viewX = windowWidth-viewW;
    k_settingFrame(_doneButton);
    
    viewX = MAX(_doneButton.bounds.size.width, backButtonFrame.size.width);
    viewW = windowWidth-viewX*2.f;
    k_settingFrame(_titleLabel);
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (NSString *)title {
    return _titleLabel.text;
}

@end
