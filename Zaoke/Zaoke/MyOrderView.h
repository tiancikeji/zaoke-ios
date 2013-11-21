//
//  MyOrderView.h
//  Zaoke
//
//  Created by Johnil on 13-9-26.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderView : UIView

- (void)setInfo:(NSDictionary *)info;
- (void)cancelOrder:(void (^)(void))complet;
@property (strong, nonatomic) IBOutlet UIImageView *juiceImageView;
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property (strong, nonatomic) IBOutlet UILabel *foodName;
@property (strong, nonatomic) IBOutlet UILabel *juiceName;
@property (strong, nonatomic) IBOutlet UILabel *foodPrice;
@property (strong, nonatomic) IBOutlet UILabel *juicePrice;
@property (strong, nonatomic) IBOutlet UILabel *beforePrice;
@property (strong, nonatomic) IBOutlet UILabel *beforePriceTitle;
@property (strong, nonatomic) IBOutlet UIView *beforePriceLine;
@property (strong, nonatomic) IBOutlet UILabel *realPrice;
@property (strong, nonatomic) IBOutlet UILabel *orderDate;
@property (strong, nonatomic) IBOutlet UILabel *picDate;
@property (strong, nonatomic) IBOutlet UILabel *juicePriceType;
@property (strong, nonatomic) IBOutlet UILabel *foodPriceType;
@property (strong, nonatomic) IBOutlet UILabel *priceTitle;

@end
