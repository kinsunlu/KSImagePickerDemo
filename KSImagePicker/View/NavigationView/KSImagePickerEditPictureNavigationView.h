//
//  KSImagePickerEditPictureNavigationView.h
//  KSImagePickerDemo
//
//  Created by kinsun on 2019/2/28.
//  Copyright © 2019年 kinsun. All rights reserved.
//

#import "KSNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerEditPictureNavigationView : KSNavigationView

@property (nonatomic) NSString *title;
@property (nonatomic, weak, readonly) UILabel *titleLabel;
@property (nonatomic, weak, readonly) UIButton *doneButton;

@end

NS_ASSUME_NONNULL_END
