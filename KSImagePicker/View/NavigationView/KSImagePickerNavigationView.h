//
//  KSImagePickerNavigationView.h
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerNavigationView : KSNavigationView

@property (nonatomic, weak, readonly) UIControl *centerButton;
@property (nonatomic) NSString *title;

@end

NS_ASSUME_NONNULL_END
