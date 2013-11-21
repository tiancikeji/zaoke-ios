//
//  AlipayWebViewController.m
//  Zaoke
//
//  Created by Johnil on 13-9-26.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "AlipayWebViewController.h"

@interface AlipayWebViewController ()

@end

@implementation AlipayWebViewController {
	payDone payDoneBlock;
	NSString *url;
}

- (AlipayWebViewController *)initWithUrl:(NSString *)url1 andPayDone:(payDone)payDoneBlock1{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
		payDoneBlock = payDoneBlock1;
		url = url1;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payDone:) name:@"payDone" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44+SIZE_FIXHEIGHT, 320, [UIScreen screenHeight]-44-SIZE_FIXHEIGHT)];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
	[self.view addSubview:webView];
	[self addTopbar];
}

- (void)payDone:(NSNotification *)notification{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if (payDoneBlock) {
		payDoneBlock(nil);
	}
	[self closeSelf];
}

- (void)closeSelf{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTopbar{
	UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44+SIZE_FIXHEIGHT)];
	topView.backgroundColor = [COLOR_ORANGE colorWithAlphaComponent:.8];
	[self.view addSubview:topView];

	UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	rightBtn.frame = CGRectMake(320-44, SIZE_FIXHEIGHT, 44, 44);
	[rightBtn setTitle:@"取消" forState:UIControlStateNormal];
	[rightBtn addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
	[topView addSubview:rightBtn];

	UILabel *cnNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, SIZE_FIXHEIGHT+9, 320-88, 23)];
	cnNameLabel.text = @"支付";
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
	NSLog(@"dealloc %@", self);
}

@end
