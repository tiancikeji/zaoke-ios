//
//  ZaokeRequest.m
//  Zaoke
//
//  Created by Johnil on 13-9-14.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "ZaokeRequest.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "AppUtil.h"
#define SERVER_URL @"http://zaocan.tiancikeji.com/"
static ZaokeRequest *sSharedInstance;
@implementation ZaokeRequest {
	NetworkStatus _networStatus;
	BOOL notified;
}

+ (ZaokeRequest *)sharedInstance{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[ZaokeRequest alloc] init];
    });
    return sSharedInstance;
}

- (id)init{
	self = [super init];
	if (self) {
		[AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
		_networStatus = ReachableViaWiFi;
		Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
		[[NSNotificationCenter defaultCenter] addObserver:sSharedInstance
												 selector:@selector(reachabilityChanged:)
													 name:kReachabilityChangedNotification
												   object:nil];
		[reach startNotifier];
		notified = NO;
		_userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
		_ticket = [[NSUserDefaults standardUserDefaults] stringForKey:@"ticket"];
		_name =	[[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
		_phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:@"phone"];
		_cardNum = [[NSUserDefaults standardUserDefaults] stringForKey:@"cardnum"];
		_balance = [[NSUserDefaults standardUserDefaults] stringForKey:@"balance"];
		if (_userID==nil) {
			[self requestGETAPI:@"client/autoreg" postData:@{@"name": @"用户"} success:^(id result) {
				_name = @"用户";
				_userID = [[result valueForKey:@"userid"] stringValue];
				_ticket = [result valueForKey:@"ticket"];
				_balance = @"0";
				[[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"balance"];
				[[NSUserDefaults standardUserDefaults] setValue:_name forKey:@"name"];
				[[NSUserDefaults standardUserDefaults] setValue:_userID forKey:@"userID"];
				[[NSUserDefaults standardUserDefaults] setValue:_ticket forKey:@"ticket"];
				[[NSUserDefaults standardUserDefaults] synchronize];
			} failed:nil];
		}
	}
	return self;
}

- (BOOL)logged{
	return _phoneNum!=nil&&_phoneNum.length>0;
}

- (void)setUserID:(NSString *)userID{
	_userID = userID;
	[[NSUserDefaults standardUserDefaults] setValue:_userID forKey:@"userID"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTicket:(NSString *)ticket{
	_ticket = ticket;
	[[NSUserDefaults standardUserDefaults] setValue:_ticket forKey:@"ticket"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setName:(NSString *)name{
	_name = name;
	[[NSUserDefaults standardUserDefaults] setValue:_name forKey:@"name"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBalance:(NSString *)balance{
	_balance = balance;
	[[NSUserDefaults standardUserDefaults] setValue:_balance forKey:@"balance"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setPhoneNum:(NSString *)phoneNum{
	_phoneNum = phoneNum;
	[[NSUserDefaults standardUserDefaults] setValue:_phoneNum forKey:@"phone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setCardNum:(NSString *)cardNum{
	_cardNum = cardNum;
	[[NSUserDefaults standardUserDefaults] setValue:_cardNum forKey:@"cardnum"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)reachabilityChanged:(NSNotification*)note{
    Reachability *reach = [note object];
    if([reach isReachable]){
		if (_networStatus==NotReachable) {
			NSLog(@"切换为有网络状态");
			_networStatus = reach.currentReachabilityStatus;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"requestNewst" object:nil];
		}
    }
	if (notified) {
		switch (reach.currentReachabilityStatus) {
			case NotReachable:{
				[AppUtil warning:@"网络连接已断开."];
				break;
			}
			case ReachableViaWiFi:
			case ReachableViaWWAN:{
				[AppUtil warning:@"网络已连接."];
				break;
			}
			default:
				break;
		}
		notified = YES;
	}
	_networStatus = reach.currentReachabilityStatus;
}

- (void)requestPOSTAPI:(NSString *)api postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed{
    [self requestAPI:api type:@"POST" postData:datas success:success failed:failed];
}

- (void)requestGETAPI:(NSString *)api postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed{
    [self requestAPI:api type:@"GET" postData:datas success:success failed:failed];
}

- (NSOperation *)requestAPI:(NSString *)api type:(NSString *)type postData:(NSDictionary *)datas success:(void (^)(id result))success failed:(void (^)(id result, NSError *error))failed{
    if (_networStatus==NotReachable) {
		[AppUtil error:@"请检查网络连接."];

        if (failed) {
            failed(nil, nil);
        }
        return nil;
    }
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:datas];
	[dict setValue:_userID forKey:@"userid"];
	[dict setValue:_ticket forKey:@"ticket"];
	__block BOOL isFinished;
	NSString *url = SERVER_URL;
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:type path:api parameters:dict];
    NSLog(@"request url:%@", [request.URL absoluteString]);
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (success) {
            success(JSON);
        }
		isFinished = YES;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		if (response.statusCode == 408) {
			isFinished = NO;
		} else {
			isFinished = YES;
		}

		NSLog(@"error:%@", error);
        if (failed) {
            failed(JSON, error);
        }
    }];
    [httpClient enqueueHTTPRequestOperation:operation];
    return operation;
}

@end
