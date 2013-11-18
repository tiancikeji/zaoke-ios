//
//  NSDictionary+Additions.m
//  Additions
//
//  Created by Johnil on 13-6-15.
//  Copyright (c) 2013年 Johnil. All rights reserved.
//

#import "NSDictionary+Additions.h"

@implementation NSDictionary (Additions)

- (NSDictionary *) dictionaryByReplacingNullsWithStrings{
	NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    id nul = [NSNull null];
    NSString *blank = @"";

    for (NSString *key in self) {
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
        else if ([object isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) object dictionaryByReplacingNullsWithStrings] forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary:replaced];
}

- (id)objectForKey:(id)key withClass:(Class)class{
    id obj = [self valueForKey:key];
//    NSLog(@"obj clacc %@ %@", obj, [obj class]);
//    if (class == [NSString class]) {
//        
//    }
//    NSAssert(![obj isKindOfClass:class], nil);
    if (obj == [NSNull null]) {
        return nil;
    }
    return obj;
}

- (NSString *)stringForKey:(NSString *)key{
    return [self objectForKey:key withClass:[NSString class]];
}

- (NSNumber *)numberForKey:(NSString *)key{
	id obj = [self objectForKey:key withClass:[NSNumber class]];
	if (obj == nil) {
		return @(0);
	}
    return obj;
}

- (int)intForKey:(NSString *)key{
    return [[self numberForKey:key] intValue];
}

- (float)floatForKey:(NSString *)key{
    return [[self numberForKey:key] floatValue];
}

- (NSDictionary *)dictionaryForKey:(NSString *)key{
    return [self objectForKey:key withClass:[NSDictionary class]];
}

- (NSArray *)arrayForKey:(NSString *)key{
    return [self objectForKey:key withClass:[NSArray class]];
}

- (NSMutableDictionary *)mutableDictionaryForKey:(NSString *)key{
    NSDictionary *dict = [self dictionaryForKey:key];
    if (dict) {
        return [NSMutableDictionary dictionaryWithDictionary:dict];
    } else {
        return [NSMutableDictionary dictionary];
    }
}

- (NSMutableArray *)mutableArrayForKey:(NSString *)key{
    NSArray *arr = [self arrayForKey:key];
    if (arr) {
        return [NSMutableArray arrayWithArray:arr];
    } else {
        return [NSMutableArray array];
    }
}

@end
