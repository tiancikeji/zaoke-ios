//
//  AppUtil.h
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject

+ (void)warning:(NSString *)message;
+ (void)success:(NSString *)message;
+ (void)error:(NSString *)message;

@end
