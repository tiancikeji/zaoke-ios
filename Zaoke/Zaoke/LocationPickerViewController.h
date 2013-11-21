//
//  LocationPickerViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-22.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (LocationPickerViewController *)initWithImage:(UIImage *)img;
@property (nonatomic, weak) id delegate;

@end

@protocol LocationPickerDelegate <NSObject>

- (void)selectLocation:(NSDictionary *)dict;

@end