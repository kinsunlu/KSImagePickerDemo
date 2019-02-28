//
//  KSNavigationController.m
//  KSImagePickerDemo
//
//  Created by kinsun on 2019/2/28.
//  Copyright © 2019年 kinsun. All rights reserved.
//

#import "KSNavigationController.h"

@implementation KSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    UINavigationBar *bar = self.navigationBar;
    if (navigationBarHidden) {
        [self.view sendSubviewToBack:bar];
    } else {
        [self.view bringSubviewToFront:bar];
    }
}

@end
