//
//  OrderViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderDoneViewController.h"
#import "VerifyPhoneViewController.h"
#import "UIImage+StackBlur.h"
#import "AlixLibService.h"
#import "AlixPayResult.h"
#import "AlipayWebViewController.h"
#import "UIAlertView+Block.h"

@interface OrderViewController ()

@end

@implementation OrderViewController {
	NSArray *payMode;
	BOOL loaded;
	NSString *pick_loc_id;
	int currentPayMode;
	NSString *orderId;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
	if (![ZaokeRequest sharedInstance].logged) {
		_money.text = @"未登录";
	} else {
		_money.text = [NSString stringWithFormat:@"%0.2f元", [[ZaokeRequest sharedInstance].balance floatValue]];
	}
	if ([ZaokeRequest sharedInstance].cardNum!=nil) {
		self.bindBtn.hidden = YES;
		self.bindTitle.hidden = YES;
	}
	_nickName.text = [ZaokeRequest sharedInstance].name;
	[(UIButton *)[self.view viewWithTag:1] setSelected:YES];
	for (int i=2; i<4; i++) {
		[(UIButton *)[self.view viewWithTag:i] setSelected:NO];
	}
	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/order/check" postData:@{@"name": [ZaokeRequest sharedInstance].name}
										 success:^(id result) {
											 NSLog(@"%@", result);
											 if (![ZaokeRequest sharedInstance].logged) {
												 _money.text = @"未登录";
											 } else {
												 self.money.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"balance"] floatValue]];
											 }
											 payMode = [[NSArray alloc] initWithArray:[result valueForKey:@"paymode"]];
											 for (int i=1; i<4; i++) {
												 [self.view viewWithTag:i].hidden = YES;
											 }
											 int end = payMode.count;
											 if (end>3) {
												 end = 3;
											 }
											 for (int i=0; i<end; i++) {
												 if ([[[payMode objectAtIndex:i] valueForKey:@"mode"] intValue]==1&&![ZaokeRequest sharedInstance].logged) {
													 continue;
												 }
												 UIButton *btn = (UIButton *)[self.view viewWithTag:i+1];
												 btn.hidden = NO;
												 NSString *name = [[payMode objectAtIndex:i] valueForKey:@"name"];
												 //												 NSLog(@"%@ %@", name, [[payMode objectAtIndex:i] valueForKey:@"mode"]);
												 if ([name indexOf:@"支付宝"]!=-1) {
													 name = @"支付宝";
												 }
												 [btn setTitle:name forState:UIControlStateNormal];
											 }
											 if (pick_loc_id==nil) {
												 self.address.text =  [result valueForKey:@"pick_loc_name"];
												 pick_loc_id = [result valueForKey:@"pick_loc_id"];
												 if (self.address.text.length<=0) {
													 self.address.text = @"请选择地址";
												 }
											 }
										 } failed:^(id result, NSError *error) {

										 }];
	if (loaded) {
		return;
	}
	loaded = YES;
	if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
		self.bgView.frame = CGRectMake(0, -20, 320, [UIScreen screenHeight]);
		for (UIView *temp in self.view.subviews) {
			temp.y += 20;
		}
	} else {
		self.bgView.frame = CGRectMake(0, 0, 320, [UIScreen screenHeight]);
	}
	if ([UIDevice isiPhone5]) {
		self.bgView.image = [UIImage imageNamed:@"Default-568h"];
	} else {
		self.bgView.image = [UIImage imageNamed:@"Default"];
	}
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

- (IBAction)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)confirm:(id)sender {
	if (pick_loc_id==nil) {
		[AppUtil warning:@"请选择送餐地点"];
		return;
	}
	self.confirm.enabled = NO;
	NSString *refresh;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
	if ([[NSFileManager defaultManager] fileExistsAtPath:[basePath stringByAppendingPathComponent:[ZaokeRequest sharedInstance].userID]]) {
		refresh = @"0";
	} else {
		refresh = @"1";
	}
	//refreshCode
	[[ZaokeRequest sharedInstance]  requestGETAPI:@"/client/order/pay"
										 postData:@{@"1":[_delegate foodId],
													@"2":[_delegate juiceId],
													@"paymode":@(currentPayMode),
													@"refreshCode":refresh,
													@"system": @"ios",
													@"pick_loc_id":pick_loc_id}
										  success:^(id result) {
											  NSLog(@"%@", result);
											  orderId = [[result valueForKey:@"orderid"] stringValue];
											  if ([result valueForKey:@"msg"]!=nil) {
												  [AppUtil error:[result valueForKey:@"msg"]];
											  } else {
												  [ZaokeRequest sharedInstance].balance = [[result valueForKey:@"balance"] stringValue];
												  if (currentPayMode==0) {
													  [AppUtil success:@"下单成功!"];
													  OrderDoneViewController *order = [[OrderDoneViewController alloc] initWithNibName:@"OrderDoneViewController" bundle:nil];
													  [self.navigationController pushViewController:order animated:YES];
												  } else {
													  NSString *url = [result valueForKey:@"url"];
													  if (currentPayMode==2) {
														  AlipayWebViewController *alipay = [[AlipayWebViewController alloc] initWithUrl:url andPayDone:^(id result) {
															  [self payDone:nil];
														  }];
														  [self presentViewController:alipay animated:YES completion:nil];
													  } else if (currentPayMode==3){
														  [AlixLibService payOrder:[result valueForKey:@"url"] AndScheme:@"zaoke" seletor:@selector(paymentResult:) target:self];
														  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payDone:) name:@"payDone" object:nil];
													  }
												  }
											  }
										  }
										   failed:^(id result, NSError *error) {
											   self.confirm.enabled = YES;
											   [AppUtil error:@"目前暂时无法下订单,请稍后重试"];
										   }];
}

- (void)payDone:(NSNotification *)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
//	NSLog(@"result%@", notification.object);
	[[ZaokeRequest sharedInstance] requestGETAPI:@"/client/order/active" postData:nil success:^(id result) {
		NSLog(@"current order %@", result);
		for (NSDictionary *order in [result valueForKey:@"orders"]) {
			if ([[[order valueForKey:@"orderid"] stringValue] isEqualToString:orderId]) {
				if ([[order valueForKey:@"status"] intValue]==1) {
					[AppUtil success:@"下单成功!"];
					OrderDoneViewController *order = [[OrderDoneViewController alloc] initWithNibName:@"OrderDoneViewController" bundle:nil];
					[self.navigationController pushViewController:order animated:YES];
				}
			}
		}
	} failed:^(id result, NSError *error) {
		NSLog(@"error");
	}];
}

-(void)paymentResult:(NSString *)resultd
{
    AlixPayResult* result = [[AlixPayResult alloc] initWithString:resultd];
	if (result)
    {

		if (result.statusCode == 9000)
        {
			/*
			 *用公钥验证签名 严格验证请使用result.resultString与result.signString验签
			 */

            //交易成功
//            NSString* key = @"签约帐户后获取到的支付宝公钥";
//			id<DataVerifier> verifier;
//            verifier = CreateRSADataVerifier(key);
//
//			if ([verifier verifyString:result.resultString withSign:result.signString])
//            {
//                //验证签名成功，交易结果无篡改
//			}
			NSLog(@"success");
        }
        else
        {
			NSLog(@"error:%@", result.resultString);
            //交易失败
        }
    }
    else
    {
		NSLog(@"error:%@", result.resultString);
        //失败
    }

}

- (IBAction)bindCard:(id)sender {
	VerifyPhoneViewController *verify = [[VerifyPhoneViewController alloc] initWithNibName:@"VerifyPhoneViewController" bundle:nil];
	[self.navigationController pushViewController:verify animated:YES];
}

- (IBAction)changePaytype:(id)sender {
	for (int i=1; i<4; i++) {
		if (i==[sender tag]) {
			[(UIButton *)[self.view viewWithTag:i] setSelected:YES];
			currentPayMode = [[[payMode objectAtIndex:i-1] valueForKey:@"mode"] intValue];
			if (currentPayMode==2||currentPayMode==3) {
				if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
					currentPayMode = 3;
				} else {
					currentPayMode = 2;
				}
			}
		} else {
			[(UIButton *)[self.view viewWithTag:i] setSelected:NO];
		}
	}
}
- (IBAction)changeLocation:(id)sender {
	LocationPickerViewController *location = [[LocationPickerViewController alloc] initWithImage:[self.view toRetinaImage]];
	location.delegate = self;
	[self presentViewController:location animated:NO completion:nil];
}

- (IBAction)changeName:(id)sender {
	UIAlertView *alert = [UIAlertView alertViewWithTitle:nil message:[NSString stringWithFormat:@"确定修改名称为 %@ 吗?", self.nickName.text] cancelButtonTitle:@"取消" otherButtonTitles:@[@"修改"] completionBlock:^(UIAlertView *alertView, NSInteger selectedButtonIndex) {
		if (selectedButtonIndex!=alertView.cancelButtonIndex) {
			[[ZaokeRequest sharedInstance] requestGETAPI:@"/client/user/rename" postData:@{@"name": self.nickName.text} success:^(id result) {
				if ([result valueForKey:@"msg"]!=nil) {
					[AppUtil error:[result valueForKey:@"msg"]];
				} else {
					[AppUtil success:@"修改名称成功!"];
				}
			} failed:^(id result, NSError *error) {
				[AppUtil error:@""];
			}];
		}
	} cancelBlock:nil];
	[alert show];
}

- (void)selectLocation:(NSDictionary *)dict{
	self.address.text =  [dict valueForKey:@"pick_loc_name"];
	pick_loc_id = [[dict valueForKey:@"pick_loc_id"] stringValue];
}

@end
