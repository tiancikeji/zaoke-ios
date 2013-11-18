//
//  ViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-11.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import "MyZaokeViewController.h"
#import "CodeViewController.h"
@interface ViewController ()

@end

@implementation ViewController{
	UIImageView *logo;
	UIButton *startOrder;
	UIButton *myOrder;
	UIButton *myCode;
	UIImageView *bottom;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSString *name = @"Default@2x.png";
	if ([UIDevice isiPhone5]) {
		name = @"Default-568h@2x.png";
	}
	UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageWithName:name]];
	[self.view addSubview:bg];
	logo = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"home-logo@2x.png"]];
	logo.center = self.view.center;
	[self.view addSubview:logo];
	bottom = [[UIImageView alloc] initWithImage:[UIImage imageWithName:@"homg-bg-text@2x.png"]];
	bottom.alpha = 0;
	bottom.frame = CGRectMake(0, [UIScreen screenHeight]-84-SIZE_ADDHEIGHT, 320, 84);
	[self.view addSubview:bottom];
	[UIView animateWithDuration:1 animations:^{
		bottom.alpha = 1;
		logo.center = CGPointMake(logo.center.x, SYSTEM_VERSION_LESS_THAN(@"7.0")?100:120);
	} completion:^(BOOL finished) {
		[self loadBtn];
	}];
}

- (void)loadBtn{
	int gap = [UIDevice isiPhone5]?50:30;
	startOrder = [UIButton buttonWithType:UIButtonTypeCustom];
	[startOrder setBackgroundImage:[UIImage imageWithName:@"home-btn@2x.png"] forState:UIControlStateNormal];
	[startOrder setBackgroundImage:[UIImage imageWithName:@"home-btn-pressed@2x.png"] forState:UIControlStateHighlighted];
	[startOrder setTitle:@"开始点餐" forState:UIControlStateNormal];
	[startOrder addTarget:self action:@selector(startOrder) forControlEvents:UIControlEventTouchUpInside];
	[startOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[startOrder setTitleColor:COLOR_ORANGE forState:UIControlStateHighlighted];
	startOrder.alpha = 0;
	startOrder.frame = CGRectMake(0, 0, 148, 35);
	startOrder.center = CGPointMake(logo.center.x, logo.center.y+logo.height/2+gap+10);
	[self.view addSubview:startOrder];
	[UIView animateWithDuration:.5 animations:^{
		startOrder.center = CGPointMake(startOrder.center.x, startOrder.center.y-10);
		startOrder.alpha = 1;
	}];
	double delayInSeconds = .1;
	dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		myOrder = [UIButton buttonWithType:UIButtonTypeCustom];
		[myOrder setBackgroundImage:[UIImage imageWithName:@"home-btn@2x.png"] forState:UIControlStateNormal];
		[myOrder setBackgroundImage:[UIImage imageWithName:@"home-btn-pressed@2x.png"] forState:UIControlStateHighlighted];
		[myOrder setTitle:@"我的早客" forState:UIControlStateNormal];
		[myOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[myOrder setTitleColor:COLOR_ORANGE forState:UIControlStateHighlighted];
		[myOrder addTarget:self action:@selector(myOrder) forControlEvents:UIControlEventTouchUpInside];
		myOrder.alpha = 0;
		myOrder.frame = CGRectMake(0, 0, 148, 35);
		myOrder.center = CGPointMake(logo.center.x, logo.center.y+logo.height/2+gap+35+gap+10);
		[self.view addSubview:myOrder];
		[UIView animateWithDuration:.5 animations:^{
			myOrder.center = CGPointMake(myOrder.center.x, myOrder.center.y-10);
			myOrder.alpha = 1;
		}];
	});
	delayInSeconds = .2;
	dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
	dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
		myCode = [UIButton buttonWithType:UIButtonTypeCustom];
		[myCode setBackgroundImage:[UIImage imageWithName:@"home-btn@2x.png"] forState:UIControlStateNormal];
		[myCode setBackgroundImage:[UIImage imageWithName:@"home-btn-pressed@2x.png"] forState:UIControlStateHighlighted];
		[myCode setTitle:@"我的二维码" forState:UIControlStateNormal];
		[myCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[myCode setTitleColor:COLOR_ORANGE forState:UIControlStateHighlighted];
		[myCode addTarget:self action:@selector(myCode) forControlEvents:UIControlEventTouchUpInside];
		myCode.alpha = 0;
		myCode.frame = CGRectMake(0, 0, 148, 35);
		myCode.center = CGPointMake(logo.center.x, logo.center.y+logo.height/2+gap*2+35*2+gap+10);
		[self.view addSubview:myCode];
		[UIView animateWithDuration:.5 animations:^{
			myCode.center = CGPointMake(myCode.center.x, myCode.center.y-10);
			myCode.alpha = 1;
		}];
	});
}

- (void)startOrder{
	MenuViewController *menuView = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
	[self.navigationController pushViewController:menuView animated:YES];
}

- (void)myOrder{
	MyZaokeViewController *myOrder1 = [[MyZaokeViewController alloc] initWithNibName:@"MyZaokeViewController" bundle:nil];
	[self.navigationController pushViewController:myOrder1 animated:YES];
}

- (void)myCode{
	CodeViewController *myOrder1 = [[CodeViewController alloc] initWithNibName:@"CodeViewController" bundle:nil];
	[self.navigationController pushViewController:myOrder1 animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
