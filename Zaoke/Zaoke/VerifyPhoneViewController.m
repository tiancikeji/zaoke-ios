//
//  VerifyPhoneViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "VerifyPhoneViewController.h"
#import "UIImage+StackBlur.h"
#import <CommonCrypto/CommonDigest.h>
@interface VerifyPhoneViewController ()

@end

@implementation VerifyPhoneViewController {
	int step;
	int second;
	ZBarReaderViewController *reader;
	NSString *code;
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
//		for (UIView *temp in self.view.subviews) {
//			temp.y += 20+SIZE_FIXHEIGHT;
//		}
//		self.bgImg.frame = CGRectMake(0, 0, 320, [UIScreen screenHeight]);
		self.bgImg.image = [UIImage imageNamed:@"Default-568h@2x.png"];
	} else {
		self.bgImg.image = [UIImage imageNamed:@"Default"];
	}
}

- (BOOL)isValidatePhoneNumber:(NSString *)number{
    NSString *numberRegex = @"1[3|4|5|8]\\d{9}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    BOOL result = [numberTest evaluateWithObject:number];
    if (!result) {
        [AppUtil error:@"请输入正确的手机号码"];
    }
    return result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	if ([ZaokeRequest sharedInstance].phoneNum.length>0) {
		step = 3;
		[self toBind];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)countDown:(NSTimer *)timer
{
    --second;
    [self.confirmBtn setTitle:[NSString stringWithFormat:@"%d后重获",second] forState:UIControlStateNormal];
    if (second <= 0) {
		if (step>1) {
			[self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
		} else {
			[self.confirmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
		}
        [self.confirmBtn setEnabled:YES];
        [timer invalidate];
    }
}

- (void)toBind{
	UIImageView *temp = [[UIImageView alloc] initWithImage:[[self.view toRetinaImage] stackBlur:20]];
	temp.frame = self.view.window.bounds;
	[self.view.window addSubview:temp];
	[temp fadeInOnComplet:^(BOOL f) {
		self.phoneNum.text = @"";
		self.verifyLabel.text = @"";
		self.phoneNum.placeholder = @"请输入卡号";
		self.phoneNum.secureTextEntry = NO;
		self.verifyLabel.hidden = YES;
		self.hasAccount.hidden = YES;
		self.loginBtn.hidden = YES;
		[self.view viewWithTag:-2].hidden = YES;
		self.zbarBtn.hidden = NO;
		self.titleLabel.text = @"绑定会员卡";
		[self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
		self.stepImg.image = [UIImage imageWithName:@"step2@2x.png"];
		double delayInSeconds = .5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[temp fadeOutOnComplet:^(BOOL f) {
				[temp removeFromSuperview];
			}];
		});
	}];
}

- (void)toPasswd{
	UIImageView *temp = [[UIImageView alloc] initWithImage:[[self.view toRetinaImage] stackBlur:20]];
	temp.frame = self.view.window.bounds;
	[self.view.window addSubview:temp];
	[temp fadeInOnComplet:^(BOOL f) {
		self.phoneNum.text = @"";
		self.verifyLabel.text = @"";
		self.phoneNum.placeholder = @"请输入密码";
		self.phoneNum.secureTextEntry = YES;
		self.verifyLabel.placeholder = @"请再次输入密码";
		self.verifyLabel.secureTextEntry = YES;
		self.titleLabel.text = @"输入密码进行注册";
		self.hasAccount.hidden = YES;
		self.loginBtn.hidden = YES;
		[self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
		self.stepImg.image = [UIImage imageWithName:@"step2@2x.png"];
		double delayInSeconds = .5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[temp fadeOutOnComplet:^(BOOL f) {
				[temp removeFromSuperview];
			}];
		});
	}];
}

- (void)dismissOverlayView:(UIButton *)btn{
	[reader dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*) reader1
 didFinishPickingMediaWithInfo: (NSDictionary*) info{
//    NSLog(@"info=%@",info);
    // 得到条形码结果
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    // 将获得到条形码显示到我们的界面上
	//    resultText.text = ;
//	NSLog(@"%@", symbol.data);
	self.phoneNum.text = symbol.data;
	[reader dismissViewControllerAnimated:YES completion:nil];
}

- (void)setOverlayPickerView:(ZBarReaderViewController *)reader1

{

	//清除原有控件
    for (UIView *temp in [reader.view subviews]) {
        for (UIButton *button in [temp subviews]) {
            if ([button isKindOfClass:[UIButton class]]) {
                [button removeFromSuperview];
            }
        }
        for (UIToolbar *toolbar in [temp subviews]) {
            if ([toolbar isKindOfClass:[UIToolbar class]]) {
                [toolbar setHidden:YES];
                [toolbar removeFromSuperview];
            }
        }
    }

    UILabel * labIntroudction= [[UILabel alloc] init];
    labIntroudction.backgroundColor = [UIColor clearColor];
    labIntroudction.frame=CGRectMake(15, 20, 290, 50);
    labIntroudction.numberOfLines=2;
    labIntroudction.textColor=[[UIColor whiteColor] colorWithAlphaComponent:.8];
    labIntroudction.text=@"将会员卡条形码图像置于离手机摄像头10CM左右，系统会自动识别。";
    [reader.view addSubview:labIntroudction];

    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.alpha = 0.4;
    [cancelButton setFrame:CGRectMake(89, self.view.height-50, 143, 35)];
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"back2.png"] forState:UIControlStateNormal];
	[cancelButton setBackgroundImage:[UIImage imageNamed:@"back2-pressed.png"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [cancelButton addTarget:self action:@selector(dismissOverlayView:)forControlEvents:UIControlEventTouchUpInside];
    [reader.view addSubview:cancelButton];
	
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}

-(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

- (IBAction)next:(id)sender {
	if (step==-1) {
		if (![self isNumeric:self.verifyLabel.text]) {
			[AppUtil error:@"密码必须为6位数字!"];
			return;
		}
		if (self.verifyLabel.text.length!=6) {
			[AppUtil error:@"密码必须为6位"];
			return;
		}
		if ([self isValidatePhoneNumber:self.phoneNum.text]) {
			[MBProgressHUD showHUDAddedTo:self.view animated:YES];
			[[ZaokeRequest sharedInstance] requestGETAPI:@"client/login" postData:@{@"phone": self.phoneNum.text,
																					@"password": [self md5:self.verifyLabel.text]}
												 success:^(id result) {
													 [MBProgressHUD hideHUDForView:self.view animated:YES];
													 if ([result valueForKey:@"msg"]!=nil) {
														 [AppUtil error:[result valueForKey:@"msg"]];
													 } else {
														 [ZaokeRequest sharedInstance].balance = [[result valueForKey:@"balance"] stringValue];
														 [ZaokeRequest sharedInstance].name = [result valueForKey:@"name"];
														 [ZaokeRequest sharedInstance].userID = [result valueForKey:@"userid"];
														 [ZaokeRequest sharedInstance].ticket = [result valueForKey:@"ticket"];
														 [ZaokeRequest sharedInstance].phoneNum = self.phoneNum.text;
														 NSString *cardId = [[result valueForKey:@"card_id"] stringValue];
														 if (cardId.length>0) {
															 [ZaokeRequest sharedInstance].cardNum = cardId;
															 [AppUtil success:@"登录成功!"];
															 double delayInSeconds = .3;
															 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
															 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
																 [self.navigationController popViewControllerAnimated:YES];
															 });
														 } else {
															 step = 3;
															 [AppUtil success:@"登录成功,请绑定会员卡"];
															 [self toBind];
														 }
													 }
												 } failed:^(id result, NSError *error) {
													 [MBProgressHUD hideHUDForView:self.view animated:YES];
													 [AppUtil error:@"获取校验码失败,请稍后重试"];
												 }];
		}
	} else if (step==0) {
		if ([self isValidatePhoneNumber:self.phoneNum.text]) {
			[self.confirmBtn setTitle:@"60秒后重获" forState:UIControlStateNormal];
			second = 60;
			self.confirmBtn.enabled = NO;
			[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
			[MBProgressHUD showHUDAddedTo:self.view animated:YES];
			[[ZaokeRequest sharedInstance] requestGETAPI:@"client/sendverifycode" postData:@{@"phone": self.phoneNum.text}
												 success:^(id result) {
													 step++;
													 [MBProgressHUD hideHUDForView:self.view animated:YES];
													 if ([result valueForKey:@"msg"]!=nil) {
														 [AppUtil error:[result valueForKey:@"msg"]];
													 } else {
														 [AppUtil success:@"成功发送校验码,请输入短信校验码."];
													 }
												 } failed:^(id result, NSError *error) {
													 [MBProgressHUD hideHUDForView:self.view animated:YES];
													 [AppUtil error:@"获取校验码失败,请稍后重试"];
												 }];
		}
	} else if (step==1){
		[MBProgressHUD showHUDAddedTo:self.view animated:YES];
		[[ZaokeRequest sharedInstance] requestGETAPI:@"client/verifycode" postData:@{@"phone": self.phoneNum.text,
																					 @"code": self.verifyLabel.text}
											 success:^(id result) {
												 [MBProgressHUD hideHUDForView:self.view animated:YES];
												 if ([[result valueForKey:@"status"] intValue]==0) {
													 [ZaokeRequest sharedInstance].phoneNum = self.phoneNum.text;
													 code = self.verifyLabel.text;
													 [self toPasswd];
													 [AppUtil success:@"验证成功,请输入密码"];
													 step++;
												 } else {
													 [AppUtil error:[result valueForKey:@"msg"]];
													 NSLog(@"%@", result);
												 }
											 } failed:^(id result, NSError *error) {
												 [MBProgressHUD hideHUDForView:self.view animated:YES];
												 [AppUtil error:@"校验失败,请稍后重试"];
											 }];
	} else if (step==2){
		if (![self isNumeric:self.phoneNum.text]) {
			[AppUtil error:@"密码必须为6位数字!"];
			return;
		}
		if (self.phoneNum.text.length!=6) {
			[AppUtil error:@"密码必须为6位"];
			return;
		}
		if (![self.phoneNum.text isEqualToString:self.verifyLabel.text]) {
			[AppUtil error:@"两次密码不一致"];
			return;
		}
		[MBProgressHUD showHUDAddedTo:self.view animated:YES];
		[[ZaokeRequest sharedInstance] requestGETAPI:@"client/register" postData:@{@"phone": [ZaokeRequest sharedInstance].phoneNum,
																				 @"password": [self md5:self.verifyLabel.text],
																				   @"code": code}
											 success:^(id result) {
												 [MBProgressHUD hideHUDForView:self.view animated:YES];
												 if ([[result valueForKey:@"status"] intValue]==0) {
													 [self toBind];
													 [AppUtil success:@"注册成功,请绑定会员卡"];
													 step++;
												 } else {
													 [AppUtil error:[result valueForKey:@"msg"]];
													 NSLog(@"%@", result);
												 }
											 } failed:^(id result, NSError *error) {
												 [MBProgressHUD hideHUDForView:self.view animated:YES];
												 [AppUtil error:@"注册失败,请稍后重试"];
											 }];
	} else if (step==3){
		[MBProgressHUD showHUDAddedTo:self.view animated:YES];
		[[ZaokeRequest sharedInstance] requestGETAPI:@"client/card/bind" postData:@{@"card_id": self.phoneNum.text}
											 success:^(id result) {
												 [MBProgressHUD hideHUDForView:self.view animated:YES];
												 if ([[result valueForKey:@"status"] intValue]==0) {
													 NSLog(@"成功!");
													 [ZaokeRequest sharedInstance].cardNum = self.phoneNum.text;
													 self.stepImg.image = [UIImage imageWithName:@"step3@2x.png"];
													 [AppUtil success:@"成功绑定会员卡."];
													 double delayInSeconds = .3;
													 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
													 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
														 [self.navigationController popViewControllerAnimated:YES];
													 });
												 } else {
													 [AppUtil error:[result valueForKey:@"msg"]];
													 NSLog(@"%@", result);
												 }
											 } failed:^(id result, NSError *error) {
												 [MBProgressHUD hideHUDForView:self.view animated:YES];
												 [AppUtil error:@"绑定会员卡失败,请稍后重试"];
											 }];
	}
}

- (IBAction)login:(id)sender {
	step = -1;
	UIImageView *temp = [[UIImageView alloc] initWithImage:[[self.view toRetinaImage] stackBlur:20]];
	temp.frame = self.view.window.bounds;
	[self.view.window addSubview:temp];
	[temp fadeInOnComplet:^(BOOL f) {
		self.phoneNum.text = @"";
		self.verifyLabel.text = @"";
		self.phoneNum.placeholder = @"请输入手机号";
		self.phoneNum.secureTextEntry = NO;
		self.verifyLabel.placeholder = @"请输入密码";
		self.verifyLabel.secureTextEntry = YES;
		self.loginBtn.hidden = YES;
		self.hasAccount.hidden = YES;
		self.titleLabel.text = @"登录";
		[self.confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
		double delayInSeconds = .5;
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			[temp fadeOutOnComplet:^(BOOL f) {
				[temp removeFromSuperview];
			}];
		});
	}];
}

- (IBAction)editEnd:(id)sender {
	[sender resignFirstResponder];
	[self next:nil];
}

- (IBAction)editVerifyEnd:(id)sender {
	second = 0;
	[sender resignFirstResponder];
	[self next:nil];
}

- (IBAction)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)zbarCode:(id)sender {
	reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
	reader.showsZBarControls = NO;
	[self setOverlayPickerView:reader];
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
				   config: ZBAR_CFG_ENABLE
					   to: 0];
	[self presentViewController:reader animated:YES completion:nil];
}

- (IBAction)valueChanged:(id)sender {
	if (step==2||step==-1) {
		if (self.verifyLabel.text.length>6) {
			self.verifyLabel.text = [self.verifyLabel.text substringToIndex:6];
		}
	}
}
@end
