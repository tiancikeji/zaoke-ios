//
//  RechargeViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "RechargeViewController.h"
#import "AlipayWebViewController.h"
#import "AlixLibService.h"
@interface RechargeViewController ()

@end

@implementation RechargeViewController {
	int money;
}

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
	if ([UIDevice isiPhone5]) {
		self.bgImg.image = [UIImage imageNamed:@"Default-568h@2x.png"];
	} else {
		self.bgImg.image = [UIImage imageNamed:@"Default"];
	}
	[(UIButton *)[self.view viewWithTag:1] setSelected:YES];
	for (int i=2; i<4; i++) {
		[(UIButton *)[self.view viewWithTag:i] setSelected:NO];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	money = 20;
	self.balance.text = [NSString stringWithFormat:@"%0.2f元", [[ZaokeRequest sharedInstance].balance floatValue]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirm:(id)sender {
	int payMode;
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
		payMode = 3;
	} else {
		payMode = 2;
	}
	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/recharge"
										postData:@{@"paymode":@(payMode),
												   @"money": @(0.01)}
										 success:^(id result) {
											 if ([result valueForKey:@"msg"]!=nil) {
												 [AppUtil error:[result valueForKey:@"msg"]];
											 } else {
//												 [AppUtil success:[NSString stringWithFormat:@"充值成功! 目前余额: %@元", [[result valueForKey:@"balance"] stringValue]]];
//												 [ZaokeRequest sharedInstance].balance = [[result valueForKey:@"balance"] stringValue];
												 NSLog(@"%@", result);
												 NSString *url = [result valueForKey:@"url"];
												 if (payMode==2) {
													 AlipayWebViewController *alipay = [[AlipayWebViewController alloc] initWithUrl:url andPayDone:^(id result) {
														 [self payDone:nil];
													 }];
													 [self presentViewController:alipay animated:YES completion:nil];
												 } else if (payMode==3){
													 [AlixLibService payOrder:[result valueForKey:@"url"] AndScheme:@"zaoke" seletor:@selector(paymentResult:) target:self];
													 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payDone:) name:@"payDone" object:nil];
												 }
											 }
	} failed:^(id result, NSError *error) {

	}];
}

- (void)payDone:(NSNotification *)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/zaokedata" postData:@{@"name": [ZaokeRequest sharedInstance].name} success:^(id result) {
		NSLog(@"%@", result);
		self.balance.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"balance"] floatValue]];
		[[NSUserDefaults standardUserDefaults] setValue:[[result valueForKey:@"balance"] stringValue] forKey:@"balance"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	} failed:^(id result, NSError *error) {
		[AppUtil error:@"更新信息失败!"];
	}];
}

- (IBAction)selectType:(id)sender {
	for (int i=1; i<4; i++) {
		if (i==[sender tag]) {
			[(UIButton *)[self.view viewWithTag:i] setSelected:YES];
		} else {
			[(UIButton *)[self.view viewWithTag:i] setSelected:NO];
		}
	}
	if ([sender tag]==1) {
		money = 20;
	} else if ([sender tag]==2){
		money = 50;
	} else{
		money = 100;
	}
}
@end
