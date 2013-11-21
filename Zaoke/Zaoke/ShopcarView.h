//
//  ShopcarView.h
//  Zaoke
//
//  Created by Johnil on 13-9-12.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderViewController.h"

@interface ShopcarView : UIView <OrderDelegate>

@property (strong, nonatomic) IBOutlet UIView *foodView;
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (strong, nonatomic) IBOutlet UIView *juiceView;
@property (strong, nonatomic) IBOutlet UIImageView *juiceImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *foodNameEnLabel;
@property (strong, nonatomic) IBOutlet UILabel *juiceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *juiceNameEnLabel;
@property (strong, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (strong, nonatomic) IBOutlet UIView *oldPriceLine;
@property (strong, nonatomic) IBOutlet UILabel *oldPriceTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *realPriceTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *realPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *juicePrice;
@property (strong, nonatomic) IBOutlet UILabel *foodPrice;
@property (strong, nonatomic) UIImageView *blurView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
- (IBAction)confirmOrder:(id)sender;
- (IBAction)tapFood:(id)sender;
- (IBAction)tapJuice:(id)sender;
- (IBAction)tapView:(id)sender;

- (void)selectFood:(NSDictionary *)food;
- (void)selectJuice:(NSDictionary *)juice;


@property (weak, nonatomic) IBOutlet id delegate;

@end

@protocol ShopcarDelegate <NSObject>

- (void)taped:(BOOL)open;
- (void)changeTypeTo:(int)type;

@end