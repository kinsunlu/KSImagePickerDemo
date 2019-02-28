//
//  KSImagePickerViewerController.h
//  kinsun
//
//  Created by kinsun on 2018/12/4.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSMediaViewerController.h"

NS_ASSUME_NONNULL_BEGIN

@class KSImagePickerItemModel;
@interface KSImagePickerViewerController : KSMediaViewerController

@property (nonatomic, getter=isMultipleSelected) BOOL multipleSelected;
@property (nonatomic, copy) NSUInteger (^didClickSelectButtonCallback)(NSUInteger index);
@property (nonatomic, copy) void (^didClickDoneButtonCallback)(KSImagePickerViewerController *controller, NSUInteger index);
@property (nonatomic, strong, readonly) NSArray <KSImagePickerItemModel *> *dataArray;

- (void)setDataArray:(NSArray <KSImagePickerItemModel *> *)dataArray currentIndex:(NSInteger)currentIndex;

- (void)dismissViewControllerAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
