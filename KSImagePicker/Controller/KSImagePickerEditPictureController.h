//
//  KSImagePickerEditPictureController.h
//  kinsun
//
//  Created by kinsun on 2018/12/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class KSImagePickerEditPictureController, KSImagePickerItemModel, KSImagePickerController;
@protocol KSImagePickerEditPictureDelegate <NSObject>

- (void)imagePickerEditPicture:(KSImagePickerEditPictureController *)imagePickerEditPicture didFinishSelectedImage:(UIImage *)image assetModel:(KSImagePickerItemModel *)assetModel;

@end

@interface KSImagePickerEditPictureController : UIViewController

@property (nonatomic, assign, getter=isCircularMask) BOOL circularMask;
@property (nonatomic, strong) KSImagePickerItemModel *model;
@property (nonatomic, weak) KSImagePickerController <KSImagePickerEditPictureDelegate> *delegate;

@end

NS_ASSUME_NONNULL_END
