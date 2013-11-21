//
//  MyOrderViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MyOrderView.h"

@interface MyOrderViewController ()

@end

@implementation MyOrderViewController {
	NSArray *orderArr;
}

- (MyOrderViewController *)initWithOrder:(NSArray *)order{
    self = [super initWithNibName:@"MyOrderViewController" bundle:nil];
    if (self) {
		orderArr = order;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
	if (!SYSTEM_VERSION_LESS_THAN(@"7.0")) {
		self.bgImg.frame = CGRectMake(0, -20, 320, [UIScreen screenHeight]);
		for (UIView *temp in self.view.subviews) {
			temp.y += 20;
		}
	} else {
		self.bgImg.frame = CGRectMake(0, 0, 320, [UIScreen screenHeight]);
	}

	if ([UIDevice isiPhone5]) {
		self.bgImg.image = [UIImage imageNamed:@"Default-568h"];
	} else {
		self.bgImg.image = [UIImage imageNamed:@"Default"];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	for (int i=0; i<orderArr.count; i++) {
		NSDictionary *dict = [orderArr objectAtIndex:i];
		NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"MyOrderView" owner:self options:nil];
		MyOrderView *orderView = [nib objectAtIndex:0];
		orderView.tag = i+1;
		[orderView setInfo:dict];
		orderView.x = i*orderView.width;
		[self.orderScrollView addSubview:orderView];
	}
	self.pageControl.numberOfPages = orderArr.count;
	self.pageControl.currentPage = 0;
	self.orderScrollView.contentSize = CGSizeMake(self.view.width*orderArr.count, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToHome:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelOrder:(id)sender {
	CGFloat pageWidth = self.orderScrollView.frame.size.width;
	int page = floor((self.orderScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	MyOrderView *order = (MyOrderView *)[self.orderScrollView viewWithTag:page+1];
	[order cancelOrder:^{
		[order fadeOutOnComplet:^(BOOL f) {
			[order removeFromSuperview];
			if (self.orderScrollView.subviews.count<=0) {
				[self.navigationController popViewControllerAnimated:YES];
			}
			[UIView animateWithDuration:.3 animations:^{
				for (MyOrderView *temp in self.orderScrollView.subviews) {
					temp.tag -= 1;
					NSLog(@"%d", temp.tag);
					temp.x = (temp.tag-1)*self.view.width;
					NSLog(@"offset %f", (temp.tag-1)*self.view.width);
				}
			}];
			self.pageControl.numberOfPages -= 1;
			self.orderScrollView.contentSize = CGSizeMake(self.view.width*self.orderScrollView.subviews.count, 0);
		}];
	}];
}
@end
