//
//  KSNavigationView.h
//  KSImagePickerDemo
//
//  Created by kinsun on 2019/2/28.
//  Copyright © 2019年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KSNavigationViewStyle) {
    KSNavigationViewStyleLight = 0,
    KSNavigationViewStyleDark,
    KSNavigationViewStyleClear
};

NS_ASSUME_NONNULL_BEGIN

@interface KSNavigationView : UIView

@property (nonatomic, assign) KSNavigationViewStyle style;//默认KSNavigationViewStyleDark
@property (nonatomic, weak, readonly) UIButton *backButton;

- (void)willFinishInit;

@end

NS_ASSUME_NONNULL_END
