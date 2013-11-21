//
//  ZaokeRequest.h
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZaokeRequest : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *ticket;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cardNum;
@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *balance;

+ (ZaokeRequest *)sharedInstance;
- (BOOL)logged;
- (void)requestGETAPI:(NSString *)api
			 postData:(NSDictionary *)datas
			  success:(void (^)(id result))success
			   failed:(void (^)(id result, NSError *error))failed;

- (void)requestPOSTAPI:(NSString *)api
			 postData:(NSDictionary *)datas
			  success:(void (^)(id result))success
			   failed:(void (^)(id result, NSError *error))failed;

@end
