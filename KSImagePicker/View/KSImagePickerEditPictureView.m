//
//  KSImagePickerEditPictureView.m
//  kinsun
//
//  Created by kinsun on 2018/12/10.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSImagePickerEditPictureView.h"
#import "KSLayout.h"

@interface _KSIPEditPictureMaskView : UIView

@property (nonatomic, assign, getter=isCircularMask) BOOL circularMask;
@property (nonatomic, assign, readonly) CGRect contentRect;

@end

@implementation _KSIPEditPictureMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:.5f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    k_creatSizeElementOfSize(rect.size);
    CGFloat minWidth = MIN(windowWidth, windowHeight);
    CGFloat x = (windowWidth-minWidth)*0.5f, y = (windowHeight-minWidth)*0.5f;
    _contentRect = (CGRect){x, y, minWidth, minWidth};
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat height_2 = windowHeight*0.5f;
    [path moveToPoint:(CGPoint){windowWidth, height_2}];
    [path addLineToPoint:(CGPoint){windowWidth, 0.f}];
    [path addLineToPoint:CGPointZero];
    [path addLineToPoint:(CGPoint){0.f, windowHeight}];
    [path addLineToPoint:(CGPoint){windowWidth, windowHeight}];
    [path addLineToPoint:(CGPoint){windowWidth, height_2}];
    if (_circularMask) {
        CGPoint center = (CGPoint){minWidth*0.5f+x,minWidth*0.5f+y};
        CGFloat radius = minWidth*0.5f-10.f;
        [path addArcWithCenter:center radius:radius startAngle:0 endAngle:M_PI*2.f clockwise:YES];
    } else {
        CGFloat maxX = x+minWidth, maxY = y+minWidth;
        [path addLineToPoint:(CGPoint){maxX, height_2}];
        [path addLineToPoint:(CGPoint){maxX, maxY}];
        [path addLineToPoint:(CGPoint){x, maxY}];
        [path addLineToPoint:(CGPoint){x, y}];
        [path addLineToPoint:(CGPoint){maxX, y}];
        [path addLineToPoint:(CGPoint){maxX, height_2}];
    }
    [path closePath];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.path = path.CGPath;
    self.layer.mask = mask;
}

@end

@interface _KSIPEditPictureTrimView : UIVisualEffectView

@end

@implementation _KSIPEditPictureTrimView {
    NSArray <NSNumber *> *_itemsWidthArray;
    NSPointerArray *_allBtns;
    __weak id _target;
    SEL _action;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    if (self = [super initWithEffect:effect]) {
        _target = target;
        _action = action;
        [self initView];
    }
    return self;
}

- (void)initView {
    CALayer *layer = self.layer;
    layer.cornerRadius = 4.f;
    layer.masksToBounds = YES;
    
    UIView *contentView = self.contentView;
    UIColor *whiteColor = UIColor.whiteColor;
    UIFont *font = [UIFont systemFontOfSize:18.f];
    NSDictionary <NSAttributedStringKey, UIFont *> *attributes = @{NSFontAttributeName: font};
    CGSize maxSize = (CGSize){MAXFLOAT, MAXFLOAT};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSArray <NSString *> *names = @[@"左", @"上", @"下", @"右"];
    
    NSMutableArray <NSNumber *> *itemsWidthArray = [NSMutableArray array];
    NSPointerArray *allBtns = [NSPointerArray weakObjectsPointerArray];
    for (NSUInteger i = 0; i < names.count; i++) {
        NSString *string = [names objectAtIndex:i];
        CGSize size = [string boundingRectWithSize:maxSize options:options attributes:attributes context:nil].size;
        NSNumber *width = [NSNumber numberWithDouble:size.width];
        [itemsWidthArray addObject:width];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:string forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        [btn setTitleColor:whiteColor forState:UIControlStateNormal];
        [btn addTarget:_target action:_action forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:btn];
        [allBtns addPointer:(__bridge void *)btn];
    }
    _allBtns = allBtns;
    _itemsWidthArray = itemsWidthArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    k_creatSelfSizeElement;
    
    CGFloat egdeMargin = 11.f;
    CGFloat remainderWidth = windowWidth;
    NSUInteger count = _itemsWidthArray.count;
    for (NSUInteger i = 0; i < count; i++) {
        NSNumber *value = [_itemsWidthArray objectAtIndex:i];
        CGFloat width = value.doubleValue;
        remainderWidth -= width;
    }
    CGFloat margin = floor((remainderWidth-egdeMargin*2.f)/count);
    viewX = egdeMargin; viewH = windowHeight; viewY = 0.f;
    for (NSUInteger i = 0; i < count; i++) {
        NSNumber *value = [_itemsWidthArray objectAtIndex:i];
        viewW = value.doubleValue+margin;
        UIButton *btn = [_allBtns pointerAtIndex:i];
        CGRect frame = k_setFrame;
        btn.frame = frame;
        viewX = CGRectGetMaxX(frame);
    }
}

@end

@interface _KSIPEditPictureToolBar : UIView

@end

@implementation _KSIPEditPictureToolBar {
    NSArray <NSNumber *> *_itemsWidthArray;
    NSPointerArray *_buttonArray;
    __weak id _target;
    SEL _action;
}

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    if (self = [super initWithFrame:CGRectZero]) {
        _target = target;
        _action = action;
        [self initView];
    }
    return self;
}

- (void)initView {
    self.backgroundColor = UIColor.clearColor;
    UIColor *whiteColor = UIColor.whiteColor;
    UIFont *font = [UIFont systemFontOfSize:18.f];
    NSDictionary <NSAttributedStringKey, UIFont *> *attributes = @{NSFontAttributeName: font};
    CGSize maxSize = (CGSize){MAXFLOAT, MAXFLOAT};
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSArray <NSString *> *titles = @[@"还原", @"微调", @"旋转"];
    NSMutableArray <NSNumber *> *itemsWidthArray = [NSMutableArray arrayWithCapacity:titles.count];
    NSPointerArray *buttonArray = [NSPointerArray weakObjectsPointerArray];
    for (NSUInteger i = 0; i < titles.count; i++) {
        NSString *title = [titles objectAtIndex:i];
        CGSize size = [title boundingRectWithSize:maxSize options:options attributes:attributes context:nil].size;
        NSNumber *width = [NSNumber numberWithDouble:size.width];
        [itemsWidthArray addObject:width];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        [btn setTitleColor:whiteColor forState:UIControlStateNormal];
        [btn addTarget:_target action:_action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [buttonArray addPointer:(__bridge void *)btn];
    }
    _buttonArray = buttonArray;
    _itemsWidthArray = itemsWidthArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    k_creatFrameElement;
    k_creatSelfSizeElement;
    
    CGFloat egdeMargin = 11.f;
    CGFloat remainderWidth = windowWidth;
    NSUInteger count = _itemsWidthArray.count;
    for (NSUInteger i = 0; i < count; i++) {
        NSNumber *value = [_itemsWidthArray objectAtIndex:i];
        CGFloat width = value.doubleValue;
        remainderWidth -= width;
    }
    CGFloat margin = floor((remainderWidth-egdeMargin*2.f)/count);
    viewX = egdeMargin; viewH = windowHeight; viewY = 0.f;
    for (NSUInteger i = 0; i < count; i++) {
        NSNumber *value = [_itemsWidthArray objectAtIndex:i];
        viewW = value.doubleValue+margin;
        UIButton *btn = [_buttonArray pointerAtIndex:i];
        CGRect frame = k_setFrame;
        btn.frame = frame;
        viewX = CGRectGetMaxX(frame);
    }
}

@end

@interface KSImagePickerEditPictureView () <UIGestureRecognizerDelegate>

@end

@implementation KSImagePickerEditPictureView {
    __weak UIView *_contentView;
    
    __weak _KSIPEditPictureMaskView *_maskView;
    __weak _KSIPEditPictureToolBar *_toolBar;
    
    __weak _KSIPEditPictureTrimView *_trimView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _initView];
        [self _addGesture];
    }
    return self;
}

- (void)_initView {
    self.backgroundColor = UIColor.blackColor;
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    _contentView = contentView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageView];
    _imageView = imageView;
    
    _KSIPEditPictureMaskView *maskView = [[_KSIPEditPictureMaskView alloc] init];
    [self addSubview:maskView];
    _maskView = maskView;
    
    _KSIPEditPictureToolBar *toolBar = [[_KSIPEditPictureToolBar alloc] initWithTarget:self action:@selector(_didClickToolBarButtons:)];
    [self addSubview:toolBar];
    _toolBar = toolBar;
    
    KSImagePickerEditPictureNavigationView *navigationView = KSImagePickerEditPictureNavigationView.alloc.init;
    navigationView.title = @"编辑照片";
    navigationView.style = KSNavigationViewStyleDark;
    [self addSubview:navigationView];
    _navigationView = navigationView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect bounds = self.bounds;
    _contentView.frame = bounds;
    _imageView.frame = bounds;
    _maskView.frame = bounds;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    CGRect layoutFrame;
    if (@available(iOS 11.0, *)) {
        layoutFrame = self.safeAreaLayoutGuide.layoutFrame;
    } else {
        CGFloat s_height = UIApplication.sharedApplication.statusBarFrame.size.height+44.f;
        layoutFrame = (CGRect){0.f, s_height, bounds.size.width, bounds.size.height-s_height};
    }
    k_creatFrameElement;
    k_creatSelfSizeElement;
    viewW = windowWidth; viewH = layoutFrame.origin.y;
    k_settingFrame(_navigationView);
    
    CGFloat safeBottomMargin = bounds.size.height-CGRectGetMaxY(layoutFrame);
    viewX = 0.f;
    viewW = windowWidth; viewH = 44.f;
    viewY = windowHeight-viewH-safeBottomMargin;
    k_settingFrame(_toolBar);
}

- (void)_didClickToolBarButtons:(UIButton *)btn {
    switch (btn.tag) {
        case 0: {
            __weak UIView *contentView = _contentView;
            __weak UIImageView *imageView = _imageView;
            [UIView animateWithDuration:0.4f animations:^{
                imageView.transform = CGAffineTransformIdentity;
                contentView.transform = CGAffineTransformIdentity;
            }];
        }
            break;
        case 1:
            if (_trimView == nil) [self _showTrimView];
            else [self _dismissTrimView];
            break;
        case 2: {
            btn.enabled = NO;
            __weak UIView *contentView = _contentView;
            CGAffineTransform transform = CGAffineTransformRotate(contentView.transform, M_PI_2);
            [UIView animateWithDuration:0.4f animations:^{
                contentView.transform = transform;
            } completion:^(BOOL finished) {
                btn.enabled = YES;
            }];
        }
            break;
    }
}

- (void)_showTrimView {
    k_creatFrameElement;
    viewW = 230.f; viewH = 44.f; viewX = (self.bounds.size.width-viewW)*0.5f; viewY = self.bounds.size.height;
    _KSIPEditPictureTrimView *trimView = [[_KSIPEditPictureTrimView alloc]initWithTarget:self action:@selector(_didClickTrimViewButtons:)];
    k_settingFrame(trimView);
    _trimView = trimView;
    [self insertSubview:trimView belowSubview:_toolBar];
    CGRect frame = trimView.frame;
    frame.origin.y = _toolBar.frame.origin.y-viewH-7.f;
    [UIView animateWithDuration:0.2f animations:^{
        trimView.frame = frame;
    }];
}

- (void)_dismissTrimView {
    __weak typeof(_trimView) weakView = _trimView;
    CGRect frame = weakView.frame;
    frame.origin.y = self.bounds.size.height;
    [UIView animateWithDuration:0.2f animations:^{
        weakView.frame = frame;
    } completion:^(BOOL finished) {
        [weakView removeFromSuperview];
    }];
}

- (void)_didClickTrimViewButtons:(UIButton *)btn {
    CGFloat tx = 0.f, ty = 0.f;
    switch (btn.tag) {
        case 0: tx=-1.f; break;
        case 1: ty=-1.f; break;
        case 2: ty=1.f; break;
        case 3: tx=1.f; break;
    }
    _contentView.transform = CGAffineTransformTranslate(_contentView.transform, tx, ty);
}

#pragma mark - Gesture
- (void)_addGesture {
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(_rotation:)];
    rotation.delegate = self;
    [_contentView addGestureRecognizer:rotation];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_pinch:)];
    pinch.delegate = self;
    [_imageView addGestureRecognizer:pinch];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
    [_imageView addGestureRecognizer:pan];
}

- (void)_rotation:(UIRotationGestureRecognizer *)rotation {
    [self _dismissTrimView];
    _contentView.transform = CGAffineTransformRotate(_contentView.transform, rotation.rotation);
    rotation.rotation = 0.f;
}

- (void)_pinch:(UIPinchGestureRecognizer *)pinch {
    [self _dismissTrimView];
    _imageView.transform = CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
}

- (void)_pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        [self _dismissTrimView];
        CGPoint translation = [pan translationInView:_imageView];
        _imageView.transform = CGAffineTransformTranslate(_imageView.transform, translation.x, translation.y);
        [pan setTranslation:CGPointZero inView:_imageView];
    }
}

- (void)snapshotWithOperation:(void(^)(void))operation {
    if (operation != nil) {
        _maskView.hidden = YES;
        operation ();
        _maskView.hidden = NO;
    }
}

#pragma mark - UIGestureRecognizer的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)setCircularMask:(BOOL)circularMask {
    _maskView.circularMask = circularMask;
}

- (BOOL)isCircularMask {
    return _maskView.isCircularMask;
}

- (CGRect)contentRect {
    return _maskView.contentRect;
}

@end
