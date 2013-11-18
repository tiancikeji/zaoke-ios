//
//  UIView+Additions.m
//  Additions
//
//  Created by Johnil on 13-6-7.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIView+Additions.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (Additions) 

- (float)x{
    return self.frame.origin.x;
}

- (float)y{
    return self.frame.origin.y;
}

- (float)width{
    return self.frame.size.width;
}

- (float)height{
    return self.frame.size.height;
}

- (void)setX:(float)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(float)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(float)w{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (void)setHeight:(float)h{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (void)fadeIn{
    [self fadeInOnComplet:nil];
}

- (void)fadeOut{
    [self fadeOutOnComplet:nil];
}

- (void)fadeInOnComplet:(void(^)(BOOL finished))complet{
    self.alpha = 0;
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 1;
    } completion:complet];
}

- (void)fadeOutOnComplet:(void(^)(BOOL finished))complet{
    [UIView animateWithDuration:.3 animations:^{
        self.alpha = 0;
    } completion:complet];
}

- (void)removeAllSubviews{
    for (UIView *temp in self.subviews) {
        [temp removeFromSuperview];
    }
}

- (void)removeSubviewWithTag:(int)tag{
    for (UIView *temp in self.subviews) {
        if (temp.tag==tag) {
            [temp removeFromSuperview];
        }
    }
}

- (void)removeSubviewExceptTag:(int)tag{
    for (UIView *temp in self.subviews) {
        if (temp.tag!=tag) {
            [temp removeFromSuperview];
        }
    }
}

- (void)removeSubviewExceptClass:(Class)class{
    for (UIView *temp in self.subviews) {
        if (![temp isKindOfClass:class]) {
            [temp removeFromSuperview];
        }
    }
}

- (UIImage *)toImage{
    return [self toImagewhithAlpha:NO];
}

- (UIImage *)toRetinaImage{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotimage;
}

- (UIImage *)toRetinaImagewhithAlpha:(BOOL)alpha{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotimage;
}

- (UIImage *)toImagewhithAlpha:(BOOL)alpha{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, !alpha, 1);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotimage;
}

- (UIImage *)toImageWithRect:(CGRect)frame{
    return [self toImageWithRect:frame withAlpha:NO];
}

- (UIImage *)toImageWithRect:(CGRect)frame withAlpha:(BOOL)alpha{
    UIGraphicsBeginImageContextWithOptions(frame.size, !alpha, 1);//这里通过设置scale为1来截取{320, 49}大小的图,而不是在retina下截取2x大小的图
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, CGAffineTransformMakeTranslation(-frame.origin.x, -frame.origin.y));
    [self.layer renderInContext:context];
    UIImage *screenShot1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShot1;
}

- (void)addWhiteView{
    UIView *white = [[UIView alloc] initWithFrame:CGRectChangeOrigin(self.frame, CGPointZero)];
    white.backgroundColor = [UIColor whiteColor];
    white.alpha = .95;
    [self addSubview:white];
}

- (UIView *)findAndResignFirstResponder{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *temp = [subView findAndResignFirstResponder];
        if (temp!=nil) {
            return temp;
        }
    }
    return nil;
}

- (void)addCorner{
    UIImageView *cornder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"corner.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)]];
    cornder.contentMode = UIViewContentModeScaleAspectFit;
    cornder.frame = CGRectMake(0, 0, self.width, self.height);
    [self addSubview:cornder];
}

- (void)shake:(float)range{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[ @(-range), @(range), @(-range), @(range), @(-range/2), @(range/2), @(-range/5), @(range/5), @(0) ];
    [self.layer addAnimation:animation forKey:@"shake"];
}

- (void)rasterize{
	self.layer.shouldRasterize = YES;
	self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

@end
