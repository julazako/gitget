//
//  GithubAPI.m
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 07.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import "GithubAPI.h"

@implementation GithubUser

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        for (NSString *key in dict) {
            @try {
                id val = [dict valueForKey:key];
                if (val == (id)[NSNull null]) {
                    continue;
                }
                if ([key isEqualToString:@"id"]) {
                    [self setValue:val forKey:@"userID"];
                }
                else {
                    [self setValue:val forKey:key];
                }
            } @catch (NSException *exception) {
                // handle this in production code or preferrably read the full github api and know the fields
            } @finally {
                // handle this in production code or preferrably read the full github api and know the fields
            }
        }
    }
    return self;
}

@end

@implementation GithubSearchResultItem

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        for (NSString *key in dict) {
            @try {
                id val = [dict valueForKey:key];
                if (val == (id)[NSNull null]) {
                    continue;
                }
                if ([key isEqualToString:@"id"]) {
                    [self setValue:val forKey:@"userID"];
                }
                else {
                    [self setValue:val forKey:key];
                }
            } @catch (NSException *exception) {
                // handle this in production code or preferrably read the full github api and know the fields
            } @finally {
                // handle this in production code or preferrably read the full github api and know the fields
            }
        }
    }
    return self;
}

@end

@implementation GithubSearchResult

- (instancetype) initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
        for (NSString *key in dict) {
            @try {
                id val = [dict valueForKey:key];
                if (val == (id)[NSNull null]) {
                    continue;
                }
                if ([key isEqualToString:@"total_count"]) {
                    [self setValue:val forKey:key];
                }
                else if ([key isEqualToString:@"incomplete_results"]) {
                    [self setValue:val forKey:key];
                }
                else if ([key isEqualToString:@"items"]) {
                    if ([val isKindOfClass:[NSArray class]]) {
                        NSArray *resultItemArr = val;
                        for (id itemJSON in resultItemArr) {
                            if ([itemJSON isKindOfClass:[NSDictionary class]]) {
                                NSDictionary *itemDict = itemJSON;
                                [self.items addObject:[[GithubSearchResultItem alloc] initWithDictionary:itemDict]];
                            }
                        }
                    }
                }
            } @catch (NSException *exception) {
                // handle this in production code or preferrably read the full github api and know the fields
            } @finally {
                // handle this in production code or preferrably read the full github api and know the fields
            }
        }
    }
    return self;
}

@end
