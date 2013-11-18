//
//  OrderDoneViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDoneViewController : UIViewController
- (IBAction)backToMain:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *orderNumber;
@property (strong, nonatomic) IBOutlet UILabel *money;
@property (strong, nonatomic) IBOutlet UIImageView *codeImg;
@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;

@end
