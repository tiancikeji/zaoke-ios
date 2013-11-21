//
//  MyZaokeViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyZaokeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *balance;
@property (nonatomic, strong) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) IBOutlet UILabel *balanceTitle;
- (IBAction)backToHome:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *photo;

@end
