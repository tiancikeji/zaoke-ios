//
//  UIImage+Additions.m
//  vvebo
//
//  Created by Johnil on 13-7-28.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage (Additions)

+ (UIImage *)imageWithName:(NSString *)name{
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@""];
	return [UIImage imageWithContentsOfFile:path];
}

- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    
    // draw original image
    [self drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0f];
    
    // tint image (loosing alpha).
    // kCGBlendModeOverlay is the closest I was able to match the
    // actual process used by apple in navigation bar
    CGContextSetBlendMode(context, kCGBlendModeOverlay);
    [tintColor setFill];
    CGContextFillRect(context, rect);
    
    // mask by alpha values of original image
    [self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

@end
