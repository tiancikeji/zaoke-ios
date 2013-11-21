//
//  AppUtil.m
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "AppUtil.h"

static MBProgressHUD *hud;

@implementation AppUtil

+ (void)warning:(NSString *)message{
	if (hud==nil) {
		hud = [[MBProgressHUD alloc] init];
	}
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	[hud show:YES];
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.5];
	[[[UIApplication sharedApplication].delegate window] addSubview:hud];
}

+ (void)success:(NSString *)message{
	if (hud==nil) {
		hud = [[MBProgressHUD alloc] init];
	}
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"success.png"]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = message;
	[hud show:YES];
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.5];
	[[[UIApplication sharedApplication].delegate window] addSubview:hud];
}

+ (void)error:(NSString *)message{
	if (hud==nil) {
		hud = [[MBProgressHUD alloc] init];
	}
	hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"error.png"]];
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = message;
	[hud show:YES];
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:YES afterDelay:1.5];
	[[[UIApplication sharedApplication].delegate window] addSubview:hud];
}

@end
