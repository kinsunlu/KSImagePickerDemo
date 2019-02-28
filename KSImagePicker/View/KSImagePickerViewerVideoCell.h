//
//  KSImagePickerViewerVideoCell.h
//  kinsun
//
//  Created by kinsun on 2018/12/11.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSMediaViewerCell.h"
#import "KSVideoPlayerLiteView.h"
#import "KSImagePickerItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerViewerVideoCell : KSMediaViewerCell

@property (nonatomic, weak) KSVideoPlayerLiteView *mainView;
@property (nonatomic, strong) KSImagePickerItemModel *data;

@end

NS_ASSUME_NONNULL_END
