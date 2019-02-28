//
//  KSImagePickerSelectIndicator.h
//  kinsun
//
//  Created by kinsun on 2019/1/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerSelectIndicator : UIControl

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, getter=isMultipleSelected) BOOL multipleSelected;

@end

NS_ASSUME_NONNULL_END
