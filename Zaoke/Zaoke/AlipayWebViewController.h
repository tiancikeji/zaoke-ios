//
//  AlipayWebViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-26.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^payDone)(id result);

@interface AlipayWebViewController : UIViewController

- (AlipayWebViewController *)initWithUrl:(NSString *)url1 andPayDone:(payDone)payDoneBlock1;

@end
