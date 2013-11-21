//
//  MyOrderView.m
//  Zaoke
//
//  Created by Johnil on 13-9-26.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "MyOrderView.h"

@implementation MyOrderView {
	NSDictionary *orderInfo;
}

- (void)setInfo:(NSDictionary *)info{
	orderInfo = info;
	_picDate.text = [info valueForKey:@"pick_time"];
	_orderDate.text = [info valueForKey:@"order_time"];
	_realPrice.text = [NSString stringWithFormat:@"%0.2f元", [[info valueForKey:@"sale_price"] floatValue]];
	NSDictionary *food = [info valueForKey:@"1"];
	if (food) {
		[_foodImageView setImageWithURL:[NSURL URLWithString:[food valueForKey:@"image_url"]]];
		_foodName.text = [food valueForKey:@"name"];
		_foodPrice.text = [[food valueForKey:@"sale_price"] stringValue];
	} else {
		_foodPrice.text = @"0";
		_foodName.text = @"未选择";
	}
	NSDictionary *juice = [info valueForKey:@"2"];
	if (juice) {
		[_juiceImageView setImageWithURL:[NSURL URLWithString:[juice valueForKey:@"image_url"]]];
		_juiceName.text = [juice valueForKey:@"name"];
		_juicePrice.text = [[juice valueForKey:@"sale_price"] stringValue];
	} else {
		_juicePrice.text = @"0";
		_juiceName.text = @"未选择";
	}

	float promotion = [[food valueForKey:@"promotion"] floatValue];
	promotion += [[juice valueForKey:@"promotion"] floatValue];
	if (promotion<=0) {
		_beforePrice.hidden = YES;
		_beforePriceLine.hidden = YES;
		_beforePriceTitle.hidden = YES;
		_priceTitle.text = @"价格:";
	} else {
		_beforePrice.text = [NSString stringWithFormat:@"%0.2f元", promotion];
	}
}

- (void)cancelOrder:(void (^)(void))complet{
	[MBProgressHUD showHUDAddedTo:self animated:YES];
	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/order/cancel"
										postData:@{@"orderid": [orderInfo valueForKey:@"orderid"]}
										 success:^(id result) {
											 [MBProgressHUD hideHUDForView:self animated:YES];
											 [AppUtil success:@"订单取消成功!"];
											 if (complet) {
												 complet();
											 }
											 NSLog(@"%@", result);
										 } failed:^(id result, NSError *error) {
											 [MBProgressHUD hideHUDForView:self animated:YES];
											 [AppUtil error:@"取消订单失败!"];
										 }];
}

@end
