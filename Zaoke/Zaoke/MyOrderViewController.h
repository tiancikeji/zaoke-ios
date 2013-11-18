//
//  MyOrderViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderViewController : UIViewController <UIScrollViewDelegate>

- (MyOrderViewController *)initWithOrder:(NSArray *)order;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIScrollView *orderScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImg;
- (IBAction)backToHome:(id)sender;
- (IBAction)cancelOrder:(id)sender;

@end
