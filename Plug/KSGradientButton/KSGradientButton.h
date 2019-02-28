//
//  KSGradientButton.h
//  kinsun
//
//  Created by kinsun on 2018/11/27.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSGradientButton : UIButton

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;

@end

NS_ASSUME_NONNULL_END
