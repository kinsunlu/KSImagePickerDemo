//
//  KSImagePickerViewerView.h
//  kinsun
//
//  Created by kinsun on 2018/12/4.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSMediaViewerView.h"
#import "KSImagePickerViewerNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerViewerView : KSMediaViewerView

@property (nonatomic, weak, readonly) KSImagePickerViewerNavigationView *navigationView;
@property (nonatomic, weak, readonly) UIButton *doneButton;

@property (nonatomic, assign, getter=isFullScreen) BOOL fullScreen;
@property (nonatomic) NSString *pageString;

@end

NS_ASSUME_NONNULL_END
