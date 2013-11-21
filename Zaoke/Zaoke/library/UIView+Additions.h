//
//  UIView+Additions.h
//  Additions
//
//  Created by Johnil on 13-6-7.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (float)x;
- (float)y;
- (float)width;
- (float)height;

- (void)setX:(float)x;
- (void)setY:(float)y;
- (void)setWidth:(float)w;
- (void)setHeight:(float)h;

- (void)fadeIn;
- (void)fadeOut;
- (void)fadeInOnComplet:(void(^)(BOOL))complet;
- (void)fadeOutOnComplet:(void(^)(BOOL))complet;

- (void)removeAllSubviews;
- (void)removeSubviewWithTag:(int)tag;
- (void)removeSubviewExceptTag:(int)tag;
- (void)removeSubviewExceptClass:(Class)class1;

- (UIImage *)toRetinaImage;
- (UIImage *)toRetinaImagewhithAlpha:(BOOL)alpha;
- (UIImage *)toImage;
- (UIImage *)toImagewhithAlpha:(BOOL)alpha;
- (UIImage *)toImageWithRect:(CGRect)frame;
- (UIImage *)toImageWithRect:(CGRect)frame withAlpha:(BOOL)alpha;

- (void)addWhiteView;
- (UIView *)findAndResignFirstResponder;

- (void)addCorner;
- (void)shake:(float)range;
- (void)rasterize;

@end
