//
//  MenuView.h
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView

- (void)showStory;
- (void)setInfo:(NSDictionary *)info;
- (void)blur;
- (void)cancelBlur;

@end
