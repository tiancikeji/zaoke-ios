//
//  VerifyPhoneViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface VerifyPhoneViewController : UIViewController <ZBarReaderDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) IBOutlet UITextField *phoneNum;
@property (strong, nonatomic) IBOutlet UITextField *verifyLabel;
@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UIImageView *stepImg;
@property (strong, nonatomic) IBOutlet UIButton *zbarBtn;
@property (strong, nonatomic) IBOutlet UILabel *hasAccount;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)next:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)editEnd:(id)sender;
- (IBAction)editVerifyEnd:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)zbarCode:(id)sender;
- (IBAction)valueChanged:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
