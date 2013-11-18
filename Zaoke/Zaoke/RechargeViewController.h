//
//  RechargeViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (strong, nonatomic) IBOutlet UIImageView *bgImg;
- (IBAction)selectType:(id)sender;
@end
