//
//  KSImagePickerViewerNavigationView.h
//  kinsun
//
//  Created by kinsun on 2019/1/7.
//

#import "KSNavigationView.h"
#import "KSImagePickerSelectIndicator.h"

NS_ASSUME_NONNULL_BEGIN

@interface KSImagePickerViewerNavigationView : KSNavigationView

@property (nonatomic, weak, readonly) KSImagePickerSelectIndicator *selectIndicator;

@end

NS_ASSUME_NONNULL_END
