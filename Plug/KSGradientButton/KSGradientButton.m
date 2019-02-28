//
//  KSGradientButton.m
//  kinsun
//
//  Created by kinsun on 2018/11/27.
//  Copyright © 2018年 kinsun. All rights reserved.
//

#import "KSGradientButton.h"

@interface KSGradientButton ()

@property (nonatomic, strong, readonly) NSMutableArray <UIColor *> *_colors;

@end

@implementation KSGradientButton {
    __weak CAGradientLayer *_gradientLayer;
    
    CGFloat _k_alpha;
}
@synthesize _colors = k_colors;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
        _gradientLayer = gradientLayer;
        
        _k_alpha = 1.f;
    }
    return self;
}

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    [super layoutSublayersOfLayer:layer];
    _gradientLayer.frame = layer.bounds;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    NSMutableArray <UIColor *> *k_colors = self._colors;
    NSArray *colors = @[(__bridge id)k_colors.firstObject.CGColor, (__bridge id)k_colors.lastObject.CGColor];
    _gradientLayer.colors = colors;
}

- (void)setStartColor:(UIColor *)startColor {
    [self._colors replaceObjectAtIndex:0 withObject:startColor];
    [self setNeedsDisplay];
}

- (UIColor *)startColor {
    return self._colors.firstObject;
}

- (void)setEndColor:(UIColor *)endColor {
    [self._colors replaceObjectAtIndex:1 withObject:endColor];
    [self setNeedsDisplay];
}

- (UIColor *)endColor {
    return self._colors.lastObject;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.isEnabled) {
        super.alpha = highlighted ? 0.5f : _k_alpha;
        [self setNeedsDisplay];
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    super.alpha = enabled ? _k_alpha : 0.5f;
    [self setNeedsDisplay];
}

- (void)setAlpha:(CGFloat)alpha {
    _k_alpha = alpha;
    if (self.isEnabled) {
        [super setAlpha:alpha];
    } else {
        [super setAlpha:0.5f];
    }
    [self setNeedsDisplay];
}

- (CGFloat)alpha {
    return _k_alpha;
}

- (NSMutableArray<UIColor *> *)_colors {
    if (k_colors == nil) {
        k_colors = [NSMutableArray arrayWithObjects:UIColor.redColor, UIColor.orangeColor, nil];
    }
    return k_colors;
}

@end
