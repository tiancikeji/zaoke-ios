//
//  CodeViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *bgImg;
@property (strong, nonatomic) IBOutlet UIImageView *codeImageView;
- (IBAction)backToHome:(id)sender;

@end
