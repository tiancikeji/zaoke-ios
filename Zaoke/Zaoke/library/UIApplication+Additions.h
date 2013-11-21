//
//  UIApplication+Additions.h
//  Additions
//
//  Created by Johnil on 13-6-15.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ViewController.h"

@interface UIApplication (Additions)

- (BOOL)isFirstRun;
- (BOOL)isFirstRunCurrentVersion;
- (void)setFirstRun;
- (void)setNotFirstRun;
- (float)version;
+ (ViewController *)rootViewController;

@end
