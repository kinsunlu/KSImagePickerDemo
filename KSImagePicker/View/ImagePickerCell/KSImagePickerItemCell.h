//
//  KSImagePickerItemCell.h
//  kinsun
//
//  Created by kinsun on 2018/12/2.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerItemCell : KSImagePickerBaseCell

@property (nonatomic, getter=isMultipleSelected) BOOL multipleSelected;

@property (nonatomic, copy) NSUInteger (^didSelectedItem)(__kindof KSImagePickerItemCell *cell);

@end

NS_ASSUME_NONNULL_END
