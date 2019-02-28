//
//  KSImagePickerToolBar.h
//  kinsun
//
//  Created by kinsun on 2019/1/7.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KSImagePickerToolBarStyle) {
    KSImagePickerToolBarStylePreview = 0,
    KSImagePickerToolBarStylePageNumber
};

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerToolBar : UIView

@property (nonatomic, assign, readonly) KSImagePickerToolBarStyle style;
/**
 KSImagePickerToolBarStylePageNumber only
 */
@property (nonatomic, weak, readonly) UILabel *pageNumberLabel;
/**
 KSImagePickerToolBarStylePreview only
 */
@property (nonatomic, weak, readonly) UIButton *previewButton;
@property (nonatomic, weak, readonly) UIButton *doneButton;

- (instancetype)initWithStyle:(KSImagePickerToolBarStyle)style;

@end

NS_ASSUME_NONNULL_END
