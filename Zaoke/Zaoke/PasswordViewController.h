//
//  PasswordViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController
- (IBAction)backToHome:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
- (IBAction)done:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *password2;
@property (strong, nonatomic) IBOutlet UITextField *password1;
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
- (IBAction)valueChanged:(id)sender;
- (IBAction)changeDone:(id)sender;
- (IBAction)toPassword1:(id)sender;
- (IBAction)toPassword2:(id)sender;
- (IBAction)passwordDone:(id)sender;

@end
