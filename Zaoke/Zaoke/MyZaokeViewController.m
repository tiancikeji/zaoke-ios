//
//  MyZaokeViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "MyZaokeViewController.h"
#import "MyOrderViewController.h"
#import "PasswordViewController.h"
#import "RechargeViewController.h"
#import "VerifyPhoneViewController.h"
@interface MyZaokeViewController ()

@end

@implementation MyZaokeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
	if (![ZaokeRequest sharedInstance].logged) {
		self.balance.text = @"未登录";
	} else {
		self.balance.text = [NSString stringWithFormat:@"%0.2f元", [[ZaokeRequest sharedInstance].balance floatValue]];
	}
	if (self.bgImg.image==nil) {
		if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
			self.bgImg.frame = CGRectMake(0, -20, 320, [UIScreen screenHeight]);
			for (UIView *temp in self.view.subviews) {
				temp.y += 20;
			}
		} else {
			self.bgImg.frame = CGRectMake(0, 0, 320, [UIScreen screenHeight]);
		}
		if ([UIDevice isiPhone5]) {
			self.bgImg.image = [UIImage imageNamed:@"Default-568h@2x.png"];
		} else {
			self.bgImg.image = [UIImage imageNamed:@"Default"];
		}
		UIImage *image = [UIImage imageNamed:@"bg.png"];
		self.photo.image = image;
		self.photo.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
		[UIView animateWithDuration:20 animations:^{
			self.photo.frame = CGRectMake(279-image.size.width/2, 0, image.size.width/2, image.size.height/2);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:20 animations:^{
				self.photo.frame = CGRectMake(0, 0, image.size.width/2, image.size.height/2);
			}];
		}];
	}
	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/zaokedata" postData:@{@"name": [ZaokeRequest sharedInstance].name} success:^(id result) {
		NSLog(@"%@", result);
		if (![ZaokeRequest sharedInstance].logged) {
			self.balance.text = @"未登录";
		} else {
			self.balance.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"balance"] floatValue]];
		}
		[[NSUserDefaults standardUserDefaults] setValue:[[result valueForKey:@"balance"] stringValue] forKey:@"balance"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} failed:^(id result, NSError *error) {
		[AppUtil error:@"更新信息失败!"];
	}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openOrder:(id)sender {
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/order/active" postData:nil success:^(id result) {
		NSLog(@"%@",result);
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		if ([result valueForKey:@"orders"]!=nil) {
			MyOrderViewController *order = [[MyOrderViewController alloc] initWithOrder:[result valueForKey:@"orders"]];
			[self.navigationController pushViewController:order animated:YES];
		} else {
			[AppUtil warning:@"未找到有效订单！"];
		}
	} failed:^(id result, NSError *error) {
		[AppUtil error:@"获取订单失败"];
		[MBProgressHUD hideHUDForView:self.view animated:YES];
	}];
}
- (IBAction)changePassword:(id)sender {
	if ([ZaokeRequest sharedInstance].phoneNum.length<=0) {
		[AppUtil error:@"请先登陆!"];
		return;
	}
	PasswordViewController *order = [[PasswordViewController alloc] initWithNibName:@"PasswordViewController" bundle:nil];
	[self.navigationController pushViewController:order animated:YES];
}

- (IBAction)backToHome:(id)sender {
	[self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)recharge:(id)sender {
	if ([ZaokeRequest sharedInstance].cardNum.length<=0) {
		[AppUtil error:@"请先绑定会员卡!"];
		return;
	}
	RechargeViewController *order = [[RechargeViewController alloc] initWithNibName:@"RechargeViewController" bundle:nil];
	[self.navigationController pushViewController:order animated:YES];
}
- (IBAction)bindCard:(id)sender {
	VerifyPhoneViewController *order = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
	[self.navigationController pushViewController:order animated:YES];
}
@end
