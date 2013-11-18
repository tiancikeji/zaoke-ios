//
//  MenuViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-12.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuView.h"
#import <QuartzCore/QuartzCore.h>
#import "ZaokeRequest.h"
#import "AppUtil.h"
@interface MenuViewController ()

@end

@implementation MenuViewController {
	UIView *topView;
	UILabel *cnNameLabel;
//	UILabel *enNameLabel;
	UIButton *rightBtn;
	UIButton *leftBtn;
	UIView *infoBar;

//	UIView *mainView;
	ShopcarView *shopcar;

	UIScrollView *foodScrollView;
	UIScrollView *juiceScrollView;

	UIScrollView *quickBar;
	NSMutableArray *foods;
	NSMutableArray *juices;
	UILabel *label;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	mainView = [[UIView alloc] initWithFrame:CGRectChangeOrigin(self.view.frame, CGPointZero)];
//	[self.view addSubview:mainView];

	foodScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen screenWidth], [UIScreen screenHeight]+20)];
	foodScrollView.bounces = NO;
	foodScrollView.backgroundColor = COLOR_ORANGE;
	foodScrollView.width = 325;
	foodScrollView.delegate = self;
	foodScrollView.pagingEnabled = YES;
	[self.view addSubview:foodScrollView];

	juiceScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -SIZE_ADDHEIGHT, [UIScreen screenWidth], [UIScreen screenHeight]+20)];
	juiceScrollView.bounces = NO;
	juiceScrollView.backgroundColor = COLOR_ORANGE;
	juiceScrollView.width = 325;
	juiceScrollView.delegate = self;
	juiceScrollView.pagingEnabled = YES;
	juiceScrollView.alpha = 0;
	[self.view addSubview:juiceScrollView];


//	quickBar = [[UIScrollView alloc] initWithFrame:CGRectMake(25, self.view.height-130, 270, 30)];
//	quickBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.6];
//	quickBar.layer.cornerRadius = 2;
//	[self.view addSubview:quickBar];
	[self addInfoBar];

	shopcar = [[[NSBundle mainBundle] loadNibNamed:@"ShopcarView" owner:self options:nil] objectAtIndex:0];
	shopcar.delegate = self;
	[self.view addSubview:shopcar];
	shopcar.frame = CGRectMake(0, [UIScreen screenHeight]-SIZE_ADDHEIGHT-59, 320, 59);
	[self addTopbar];

	[[ZaokeRequest sharedInstance] requestGETAPI:@"client/food/list" postData:nil success:^(id result) {
//		NSLog(@"%@", result);
		foods = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"1"]];
		juices = [[NSMutableArray alloc] initWithArray:[result valueForKey:@"2"]];
		int i = 0;
		cnNameLabel.text = [[foods firstObject] valueForKey:@"name"];
		for (NSDictionary *info in foods) {
			MenuView *bg = [[MenuView alloc] initWithFrame:CGRectMake(i*(320+5), 0, 320, [UIScreen screenHeight])];
			bg.tag = i+1;
			[bg setInfo:info];
			[foodScrollView addSubview:bg];
			i++;
		}
		foodScrollView.contentSize = CGSizeMake((320+5)*i, 0);
		i=0;
		for (NSDictionary *info in juices) {
			MenuView *bg = [[MenuView alloc] initWithFrame:CGRectMake(i*(320+5), 0, 320, [UIScreen screenHeight])];
			bg.tag = i+1;
			[bg setInfo:info];
			[juiceScrollView addSubview:bg];
			i++;
		}
		juiceScrollView.contentSize = CGSizeMake((320+5)*i, 0);

	} failed:^(id result, NSError *error) {
		[AppUtil error:@"获取食品列表失败"];
	}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (rightBtn.tag) {
		if (page>juices.count-1) {
			page = juices.count-1;
		}
		cnNameLabel.text = [[juices objectAtIndex:page] valueForKey:@"name"];
	} else {
		if (page>foods.count-1) {
			page = foods.count-1;
		}
		cnNameLabel.text = [[foods objectAtIndex:page] valueForKey:@"name"];
	}
}

- (void)addTopbar{
	topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44+SIZE_FIXHEIGHT)];
	topView.backgroundColor = [COLOR_ORANGE colorWithAlphaComponent:.8];
	[self.view addSubview:topView];

	leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	leftBtn.frame = CGRectMake(0, SIZE_FIXHEIGHT, 44, 44);
	[leftBtn setImage:[UIImage imageWithName:@"menu-back@2x.png"] forState:UIControlStateNormal];
	[leftBtn setImage:[UIImage imageWithName:@"menu-back-pressed@2x.png"] forState:UIControlStateHighlighted];
	[leftBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
	[topView addSubview:leftBtn];

	rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	rightBtn.frame = CGRectMake(320-44, SIZE_FIXHEIGHT, 44, 44);
	[rightBtn setImage:[UIImage imageWithName:@"menu-juice@2x.png"] forState:UIControlStateNormal];
	[rightBtn setImage:[UIImage imageWithName:@"menu-juice-pressed@2x.png"] forState:UIControlStateHighlighted];
	[rightBtn addTarget:self action:@selector(changeType) forControlEvents:UIControlEventTouchUpInside];
	[topView addSubview:rightBtn];

	cnNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, SIZE_FIXHEIGHT+9, 320-88, 23)];
	cnNameLabel.text = @"";
	cnNameLabel.textColor = [UIColor whiteColor];
	cnNameLabel.backgroundColor = [UIColor clearColor];
	cnNameLabel.textAlignment = NSTextAlignmentCenter;
	cnNameLabel.font = [UIFont systemFontOfSize:22];
	cnNameLabel.minimumScaleFactor = .1;
	cnNameLabel.adjustsFontSizeToFitWidth = YES;
	cnNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
	cnNameLabel.layer.shadowOffset = CGSizeMake(0, 1);
	cnNameLabel.layer.shadowOpacity = .3;
	cnNameLabel.layer.shadowRadius = 1;
	[topView addSubview:cnNameLabel];

//	enNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 22+SIZE_FIXHEIGHT+5, 320-88, 12)];
//	enNameLabel.text = @"CLASSIC BACON SANDWICH";
//	enNameLabel.textColor = [UIColor whiteColor];
//	enNameLabel.backgroundColor = [UIColor clearColor];
//	enNameLabel.textAlignment = NSTextAlignmentCenter;
//	enNameLabel.font = [UIFont systemFontOfSize:8];
//	enNameLabel.minimumScaleFactor = .1;
//	enNameLabel.adjustsFontSizeToFitWidth = YES;
//	enNameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//	enNameLabel.layer.shadowOffset = CGSizeMake(0, 1);
//	enNameLabel.layer.shadowOpacity = .3;
//	enNameLabel.layer.shadowRadius = 1;
//	[topView addSubview:enNameLabel];
}

- (void)addInfoBar{
	infoBar = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen screenHeight]-SIZE_ADDHEIGHT-59-32, 320, 32)];
	infoBar.backgroundColor = [COLOR_ORANGE colorWithAlphaComponent:.8];
	[self.view addSubview:infoBar];

	label = [[UILabel alloc] initWithFrame:CGRectMake(21, 0, 100, 32)];
	label.text = @"三明治的故事";
	label.textColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = NSTextAlignmentCenter;
	label.font = [UIFont systemFontOfSize:15];
	label.minimumScaleFactor = .1;
	label.adjustsFontSizeToFitWidth = YES;
	[infoBar addSubview:label];
	UIButton *enter = [UIButton buttonWithType:UIButtonTypeCustom];
	[enter setImage:[UIImage imageWithName:@"enter@2x.png"] forState:UIControlStateNormal];
	[enter setImage:[UIImage imageWithName:@"enter2-pressed@2x.png"] forState:UIControlStateHighlighted];
	[enter addTarget:self action:@selector(showStory) forControlEvents:UIControlEventTouchUpInside];
	enter.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
	enter.frame = CGRectMake(21, -4, 125, 40);
	[infoBar addSubview:enter];

	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(180, 0, 100, 32)];
	label2.text = @"加入我的订单";
	label2.textColor = [UIColor whiteColor];
	label2.backgroundColor = [UIColor clearColor];
	label2.textAlignment = NSTextAlignmentCenter;
	label2.font = [UIFont systemFontOfSize:15];
	label2.minimumScaleFactor = .1;
	label2.adjustsFontSizeToFitWidth = YES;
	[infoBar addSubview:label2];
	UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
	[add setImage:[UIImage imageWithName:@"menu-add@2x.png"] forState:UIControlStateNormal];
	[add setImage:[UIImage imageWithName:@"menu-add-pressed@2x.png"] forState:UIControlStateHighlighted];
	add.frame = CGRectMake(180, -4, 125, 40);
	add.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
	[add addTarget:self action:@selector(addOrder) forControlEvents:UIControlEventTouchUpInside];
	[infoBar addSubview:add];
}

- (MenuView *)currentMenu{
	if (rightBtn.tag) {
		CGFloat pageWidth = juiceScrollView.frame.size.width;
		int page = floor((juiceScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		return (MenuView *)[juiceScrollView viewWithTag:page+1];
	} else {
		CGFloat pageWidth = foodScrollView.frame.size.width;
		int page = floor((foodScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		return (MenuView *)[foodScrollView viewWithTag:page+1];
	}
}

- (void)changeTypeTo:(int)type{
	rightBtn.tag=!type;
	[self changeType];
}

- (void)taped:(BOOL)open{
	if (open) {
		[infoBar fadeOut];
		[[self currentMenu] blur];
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSelf)];
		[self.view addGestureRecognizer:tap];
	} else {
		[infoBar fadeIn];
		[[self currentMenu] cancelBlur];
		for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
			[self.view removeGestureRecognizer:gesture];
		}
	}
}

- (void)tapSelf{
	[shopcar tapView:nil];
}

- (void)showStory{
	[[self currentMenu] showStory];
}

- (void)addOrder{
	if (rightBtn.tag) {
		CGFloat pageWidth = juiceScrollView.frame.size.width;
		int page = floor((juiceScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		[shopcar selectJuice:[juices objectAtIndex:page]];
	} else {
		CGFloat pageWidth = foodScrollView.frame.size.width;
		int page = floor((foodScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		[shopcar selectFood:[foods objectAtIndex:page]];
	}
	UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(44, SIZE_FIXHEIGHT+9, 320-88, 23)];
	temp.text = cnNameLabel.text;
	temp.textColor = [UIColor whiteColor];
	temp.backgroundColor = [UIColor clearColor];
	temp.textAlignment = NSTextAlignmentCenter;
	temp.font = [UIFont systemFontOfSize:22];
	temp.minimumScaleFactor = .1;
	temp.adjustsFontSizeToFitWidth = YES;
	temp.layer.shadowColor = [UIColor blackColor].CGColor;
	temp.layer.shadowOffset = CGSizeMake(0, 1);
	temp.layer.shadowOpacity = .3;
	temp.layer.shadowRadius = 1;

	[self.view addSubview:temp];
	[UIView animateWithDuration:1 animations:^{
		temp.center = CGPointMake(320/2, self.view.height-30);
		temp.transform = CGAffineTransformMakeRotation(.4);
		temp.transform = CGAffineTransformMakeScale(.5, .5);
	} completion:^(BOOL finished) {
		[temp removeFromSuperview];
		[UIView animateWithDuration:.15 animations:^{
			shopcar.transform = CGAffineTransformMakeScale(1.1, 1.1);
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:.15 animations:^{
				shopcar.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
	if (!rightBtn.tag) {
		[self changeType];
	} else {
		[shopcar confirmOrder:nil];
	}
}

- (void)changeType{
	NSLog(@"changeType:%d", rightBtn.tag);
	rightBtn.tag = !rightBtn.tag;
	if (rightBtn.tag) {
		label.text = @"饮料的故事";
		[rightBtn setImage:[UIImage imageNamed:@"menu-food.png"] forState:UIControlStateNormal];
		[rightBtn setImage:[UIImage imageNamed:@"menu-food-pressed.png"] forState:UIControlStateHighlighted];
		[UIView animateWithDuration:.3 animations:^{
			foodScrollView.alpha = 0;
			juiceScrollView.alpha = 1;
		} completion:^(BOOL finished) {
		}];
		[self scrollViewDidScroll:foodScrollView];
	} else {
		label.text = @"三明治的故事";
		[rightBtn setImage:[UIImage imageNamed:@"menu-juice.png"] forState:UIControlStateNormal];
		[rightBtn setImage:[UIImage imageNamed:@"menu-juice-pressed.png"] forState:UIControlStateHighlighted];
		[UIView animateWithDuration:.3 animations:^{
			foodScrollView.alpha = 1;
			juiceScrollView.alpha = 0;
		} completion:^(BOOL finished) {
		}];
		[self scrollViewDidScroll:juiceScrollView];
	}
}

- (void)close{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
	NSLog(@"menu dealloc", nil);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
