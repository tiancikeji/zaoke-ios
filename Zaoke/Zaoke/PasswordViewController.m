//
//  PasswordViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "PasswordViewController.h"
#import <CommonCrypto/CommonDigest.h>

@interface PasswordViewController ()

@end

@implementation PasswordViewController

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

- (IBAction)backToHome:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)done:(id)sender {
	if (![self isNumeric:self.password1.text]) {
		[AppUtil error:@"密码必须为6位数字!"];
		return;
	}
	if (self.password1.text.length!=6) {
		[AppUtil error:@"密码必须为6位"];
		return;
	}
	if (![self.password1.text isEqualToString:self.password2.text]) {
		[AppUtil error:@"两次密码不一致"];
		return;
	}
	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/user/passwd"
										postData:@{@"old": [self md5:self.oldPassword.text],
												   @"new1": [self md5:self.password1.text],
												   @"new2": [self md5:self.password2.text]}
										 success:^(id result) {
											 NSLog(@"%@", result);
											 if ([result valueForKey:@"msg"]!=nil) {
												 [AppUtil error:[result valueForKey:@"msg"]];
											 } else {
												 [AppUtil success:@"修改密码成功!"];
												 [self.navigationController popViewControllerAnimated:YES];
											 }
										 } failed:^(id result, NSError *error) {
											 [AppUtil error:@"修改密码失败!"];
										 }];
}

- (IBAction)valueChanged:(UITextField *)sender {
	if (sender.text.length>6) {
		sender.text = [sender.text substringToIndex:6];
	}
}

- (IBAction)changeDone:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)toPassword1:(id)sender {
	[self.password1 becomeFirstResponder];
}

- (IBAction)toPassword2:(id)sender {
	[self.password2 becomeFirstResponder];
}

- (IBAction)passwordDone:(id)sender {
	[sender resignFirstResponder];
	[self done:sender];
}
@end
