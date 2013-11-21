//
//  OrderDoneViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "OrderDoneViewController.h"

@interface OrderDoneViewController ()

@end

@implementation OrderDoneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
	if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
		self.bgImg.frame = CGRectMake(0, -20, 320, [UIScreen screenHeight]);
		for (UIView *temp in self.view.subviews) {
			temp.y += 20;
		}
	} else {
		self.bgImg.frame = CGRectMake(0, 0, 320, [UIScreen screenHeight]);
	}
//	self.backBtn.y += 20+SIZE_ADDHEIGHT;
	if ([UIDevice isiPhone5]) {
		self.bgImg.image = [UIImage imageNamed:@"Default-568h"];
	} else {
		self.bgImg.image = [UIImage imageNamed:@"Default"];
	}
}

- (void)viewWillDisappear:(BOOL)animated{
	for (UIGestureRecognizer *gesture in self.navigationController.view.gestureRecognizers) {
		gesture.enabled = YES;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	for (UIGestureRecognizer *gesture in self.navigationController.view.gestureRecognizers) {
		gesture.enabled = NO;
	}
	if ([ZaokeRequest sharedInstance].logged) {
		_money.text = [NSString stringWithFormat:@"%0.2f元", [[ZaokeRequest sharedInstance].balance floatValue]];
	} else {
		_money.text = @"未登录";
	}

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	NSString *imgPath = [basePath stringByAppendingPathComponent:[ZaokeRequest sharedInstance].userID];
	if (![[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
		[[ZaokeRequest sharedInstance] requestGETAPI:@"client/code" postData:@{@"name": [ZaokeRequest sharedInstance].name} success:^(id result) {
			if ([result valueForKey:@"msg"]!=nil) {
				[AppUtil error:[result valueForKey:@"msg"]];
			}
			NSData *data = [NSData dataFromBase64String:[result valueForKey:@"code"]];
			//		NSLog(@"%@", [[result valueForKey:@"code"] dataUsingEncoding:NSUTF8StringEncoding]);
			//		[[[result valueForKey:@"code"] dataUsingEncoding:NSUTF8StringEncoding] writeToFile:[NSTemporaryDirectory() stringByAppendingPathComponent:@"1.png"] atomically:YES];
			[data writeToFile:imgPath atomically:YES];
			UIImage *img = [UIImage imageWithData:data];
			self.codeImg.image = img;
		} failed:^(id result, NSError *error) {
			NSLog(@"error");
		}];
	} else {
		self.codeImg.image = [UIImage imageWithContentsOfFile:imgPath];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}
@end
