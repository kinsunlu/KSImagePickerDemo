//
//  KSImagePickerViewerNavigationView.m
//  kinsun
//
//  Created by kinsun on 2019/1/7.
//

#import "KSImagePickerViewerNavigationView.h"
#import "KSLayout.h"

@implementation KSImagePickerViewerNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.style = KSNavigationViewStyleDark;
    }
    return self;
}

- (void)willFinishInit {
    [super willFinishInit];
    KSImagePickerSelectIndicator *indView = [[KSImagePickerSelectIndicator alloc] init];
    [self addSubview:indView];
    _selectIndicator = indView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    CGRect backButtonFrame = self.backButton.frame;
    viewW = 60.f; viewH = backButtonFrame.size.height;
    viewY = backButtonFrame.origin.y; viewX = self.bounds.size.width-viewW;
    k_settingFrame(_selectIndicator);
}

@end
