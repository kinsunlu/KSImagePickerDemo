//
//  KSImagePickerController.h
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KSImagePickerMediaType) {
    KSImagePickerMediaTypePicture   = 1,
    KSImagePickerMediaTypeVideo     = 2
};

typedef NS_ENUM(NSInteger, KSImagePickerEditPictureStyle) {
    KSImagePickerEditPictureStyleNormal = 0,
    KSImagePickerEditPictureStyleCircular
};


@class KSImagePickerItemModel, KSImagePickerController, AVURLAsset;
@protocol KSImagePickerControllerDelegate <NSObject>

@optional
- (void)imagePicker:(KSImagePickerController *)imagePicker didFinishSelectedAssetModelArray:(NSArray <KSImagePickerItemModel *> *)assetModelArray ofMediaType:(KSImagePickerMediaType)mediatype;

- (void)imagePicker:(KSImagePickerController *)imagePicker didFinishSelectedImageArray:(NSArray <UIImage *> *)imageArray;

- (void)imagePicker:(KSImagePickerController *)imagePicker didFinishSelectedVideoArray:(NSArray <AVURLAsset *> *)videoArray;

@end

@interface KSImagePickerController : UIViewController

@property (nonatomic, assign, readonly) KSImagePickerEditPictureStyle editPictureStyle;
@property (nonatomic, assign, readonly) KSImagePickerMediaType mediaType;
@property (nonatomic, assign, readonly) NSUInteger maxItemCount;
@property (nonatomic, weak) id <KSImagePickerControllerDelegate> delegate;

- (instancetype)initWithMediaType:(KSImagePickerMediaType)mediaType;
- (instancetype)initWithMediaType:(KSImagePickerMediaType)mediaType maxItemCount:(NSUInteger)maxItemCount;
- (instancetype)initWithEditPictureStyle:(KSImagePickerEditPictureStyle)editPictureStyle;

@end

@interface KSImagePickerController (Authority)

+ (void)authorityCheckUpWithController:(UIViewController *)controller type:(KSImagePickerMediaType)type completionHandler:(void(^)(KSImagePickerMediaType type))completionHandler cancelHandler:(nullable void (^)(UIAlertAction *action))cancelHandler ;

+ (void)authorityAlertWithController:(UIViewController *)controller name:(NSString*)name cancelHandler:(nullable void (^)(UIAlertAction *action))cancelHandler;

+ (void)authorityAVMediaTypeAudioCheckUpWithController:(UIViewController *)controller completionHandler:(nullable void(^)(BOOL isOpen))completionHandler cancelHandler:(nullable void (^)(UIAlertAction *action))cancelHandler;

@end

NS_ASSUME_NONNULL_END
