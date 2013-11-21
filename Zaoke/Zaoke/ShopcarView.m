//
//  ShopcarView.m
//  Zaoke
//
//  Created by Johnil on 13-9-12.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "ShopcarView.h"
#import "MenuViewController.h"
@implementation ShopcarView {
	float beginY;
	NSDictionary *foodDict;
	NSDictionary *juiceDict;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	if (self) {
		self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.8];
		_blurView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -self.y, 320, 568)];
		UIView *whiteView = [[UIView alloc]initWithFrame:CGRectChangeOrigin(_blurView.frame, CGPointZero)];
		whiteView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
		[_blurView addSubview:whiteView];
		[self insertSubview:_blurView atIndex:0];
		self.clipsToBounds = YES;
		self.oldPriceLine.height = .5;
		UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
		upSwipe.direction = UISwipeGestureRecognizerDirectionUp;
		UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
		downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
		[self addGestureRecognizer:upSwipe];
		[self addGestureRecognizer:downSwipe];
	}
	return self;
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe{
	if (swipe.direction==UISwipeGestureRecognizerDirectionUp&&self.height==59) {
		CGRect frame = self.frame;
		frame = CGRectMake(0, [UIScreen screenHeight]-SIZE_ADDHEIGHT-357, 320, 357);
		if (_delegate) {
			[_delegate taped:YES];
		}
		[UIView animateWithDuration:.3 animations:^{
			self.frame = frame;
		}];
	} else if (swipe.direction==UISwipeGestureRecognizerDirectionDown&&self.height==357) {
		CGRect frame = self.frame;
		frame = CGRectMake(0, [UIScreen screenHeight]-SIZE_ADDHEIGHT-59, 320, 59);
		if (_delegate) {
			[_delegate taped:NO];
		}
		[UIView animateWithDuration:.3 animations:^{
			self.frame = frame;
		}];
	}
}

- (void)checkPrice{
	NSMutableDictionary *post = [NSMutableDictionary dictionary];
	if (foodDict) {
		[post setValue:[[foodDict valueForKey:@"id"] stringValue] forKey:@"1"];
	}
	if (juiceDict) {
		[post setValue:[[juiceDict valueForKey:@"id"] stringValue] forKey:@"2"];
	}
	[[ZaokeRequest sharedInstance] requestGETAPI:@"/client/food/buy" postData:post success:^(id result) {
		//{"combo_price":97.0,"sale_price":101.0,"status":0}
		if ([[result valueForKey:@"combo_price"] floatValue]>0) {
			self.realPriceLabel.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"combo_price"] floatValue]];
			self.oldPriceLabel.hidden = NO;
			self.oldPriceLine.hidden = NO;
			self.oldPriceTitleLabel.hidden = NO;
			self.realPriceTitleLabel.text = @"特惠价:";
			if ([result valueForKey:@"sale_price"]) {
				self.oldPriceLabel.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"sale_price"] floatValue]];
			}
		} else {
			self.oldPriceLabel.hidden = YES;
			self.oldPriceLine.hidden = YES;
			self.oldPriceTitleLabel.hidden = YES;
			self.realPriceTitleLabel.text = @"价格:";
			if ([result valueForKey:@"sale_price"]) {
				self.realPriceLabel.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"sale_price"] floatValue]];
			}
		}
	} failed:^(id result, NSError *error) {
		self.oldPriceLabel.hidden = YES;
		self.oldPriceLine.hidden = YES;
		self.oldPriceTitleLabel.hidden = YES;
		self.realPriceTitleLabel.text = @"价格:";
		self.realPriceLabel.text = @"0元";
	}];

}

- (void)selectFood:(NSDictionary *)food{
	foodDict = food;
	self.foodNameLabel.text = [food valueForKey:@"name"];
	self.foodPrice.text = [[food valueForKey:@"sale_price"] stringValue];
	[self.foodImageView setImageWithURL:[NSURL URLWithString:[food valueForKey:@"image_url"]]];
	[self checkPrice];
}

- (void)selectJuice:(NSDictionary *)juice{
	juiceDict = juice;
	self.juiceNameLabel.text = [juice valueForKey:@"name"];
	self.juicePrice.text = [[juice valueForKey:@"sale_price"] stringValue];
	[self.juiceImageView setImageWithURL:[NSURL URLWithString:[juice valueForKey:@"image_url"]]];
	[self checkPrice];
}

- (void)setFrame:(CGRect)frame{
	_blurView.y = -frame.origin.y;
	[super setFrame:frame];
}

- (IBAction)confirmOrder:(id)sender {
	if (!foodDict&&!juiceDict) {
		[AppUtil error:@"请先选择要预定的食物或饮料!"];
		return;
	}
	[MBProgressHUD showHUDAddedTo:self.window animated:YES];
	NSMutableDictionary *post = [NSMutableDictionary dictionary];
	if (foodDict) {
		[post setValue:[[foodDict valueForKey:@"id"] stringValue] forKey:@"1"];
	}
	if (juiceDict) {
		[post setValue:[[juiceDict valueForKey:@"id"] stringValue] forKey:@"2"];
	}
	[[ZaokeRequest sharedInstance] requestGETAPI:@"/client/food/buy" postData:post success:^(id result) {
		//{"combo_price":97.0,"sale_price":101.0,"status":0}
		if ([[result valueForKey:@"combo_price"] floatValue]>0) {
			self.realPriceLabel.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"combo_price"] floatValue]];
			self.oldPriceLabel.hidden = NO;
			self.oldPriceLine.hidden = NO;
			self.oldPriceTitleLabel.hidden = NO;
			self.realPriceTitleLabel.text = @"特惠价:";
			if ([result valueForKey:@"sale_price"]) {
				self.oldPriceLabel.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"sale_price"] floatValue]];
			}
		} else {
			self.oldPriceLabel.hidden = YES;
			self.oldPriceLine.hidden = YES;
			self.oldPriceTitleLabel.hidden = YES;
			self.realPriceTitleLabel.text = @"价格:";
			if ([result valueForKey:@"sale_price"]) {
				self.realPriceLabel.text = [NSString stringWithFormat:@"%0.2f元", [[result valueForKey:@"sale_price"] floatValue]];
			}
		}
		[MBProgressHUD hideAllHUDsForView:self.window animated:YES];
		OrderViewController *order = [[OrderViewController alloc] initWithNibName:@"OrderViewController" bundle:nil];
		order.delegate = self;
		UIImage *img = [self.mainView toRetinaImagewhithAlpha:YES];
		UIImageView *temp = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, img.size.width, img.size.height)];
		temp.image = img;
		[order.view addSubview:temp];
		[[(MenuViewController *)self.superview.nextResponder navigationController] pushViewController:order animated:YES];
	} failed:^(id result, NSError *error) {
		self.oldPriceLabel.hidden = YES;
		self.oldPriceLine.hidden = YES;
		self.oldPriceTitleLabel.hidden = YES;
		self.realPriceTitleLabel.text = @"价格:";
		self.realPriceLabel.text = @"0元";
		[MBProgressHUD hideAllHUDsForView:self animated:YES];
	}];


}

- (NSString *)foodId{
	if (foodDict==nil) {
		return @"";
	}
	return [foodDict valueForKey:@"id"];
}

- (NSString *)juiceId{
	if (juiceDict==nil) {
		return @"";
	}
	return [juiceDict valueForKey:@"id"];
}

- (IBAction)tapFood:(id)sender {
	foodDict = nil;
	[self checkPrice];
	[self tapView:nil];
	if (_delegate) {
		[_delegate changeTypeTo:0];
	}
}

- (IBAction)tapJuice:(id)sender {
	juiceDict = nil;
	[self checkPrice];
	[self tapView:nil];
	if (_delegate) {
		[_delegate changeTypeTo:1];
	}
}

- (IBAction)tapView:(UITapGestureRecognizer *)sender {
	CGRect frame = self.frame;
	if (frame.size.height==59) {
		frame = CGRectMake(0, [UIScreen screenHeight]-SIZE_ADDHEIGHT-357, 320, 357);
		if (_delegate) {
			[_delegate taped:YES];
		}
	} else {
		frame = CGRectMake(0, [UIScreen screenHeight]-SIZE_ADDHEIGHT-59, 320, 59);
		if (_delegate) {
			[_delegate taped:NO];
		}
	}
	[UIView animateWithDuration:.3 animations:^{
		self.frame = frame;
	}];
}
@end
