//
//  OrderViewController.h
//  Zaoke
//
//  Created by Johnil on 13-9-13.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationPickerViewController.h"

@interface OrderViewController : UIViewController <LocationPickerDelegate>
- (IBAction)back:(id)sender;
- (IBAction)confirm:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nickName;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *money;
- (IBAction)bindCard:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *confirm;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
- (IBAction)changePaytype:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *moneyTitle;
@property (strong, nonatomic) IBOutlet UIButton *bindBtn;
@property (strong, nonatomic) IBOutlet UILabel *bindTitle;
- (IBAction)changeLocation:(id)sender;
- (IBAction)changeName:(id)sender;

@property (nonatomic, weak) id delegate;

@end

@protocol OrderDelegate <NSObject>

- (NSString *)foodId;
- (NSString *)juiceId;

@end