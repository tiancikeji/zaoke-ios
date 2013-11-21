//
//  UIImage+Additions.h
//  vvebo
//
//  Created by Johnil on 13-7-28.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)
- (UIImage *)tintedImageUsingColor:(UIColor *)tintColor;
+ (UIImage *)imageWithName:(NSString *)name;

@end
