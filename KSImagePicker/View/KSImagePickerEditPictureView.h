//
//  KSImagePickerEditPictureView.h
//  kinsun
//
//  Created by kinsun on 2018/12/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSImagePickerEditPictureNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerEditPictureView : UIView

@property (nonatomic, weak, readonly) KSImagePickerEditPictureNavigationView *navigationView;
@property (nonatomic, getter=isCircularMask) BOOL circularMask;
@property (nonatomic, weak, readonly) UIImageView *imageView;
@property (nonatomic, readonly) CGRect contentRect;

- (void)snapshotWithOperation:(void(^)(void))operation;

@end

NS_ASSUME_NONNULL_END
