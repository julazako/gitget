//
//  GithubAPI.h
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 07.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GithubUser : NSObject

@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *node_id;
@property (strong, nonatomic) NSString *gravatar_id;
@property (strong, nonatomic) NSString *followers_url;
@property (strong, nonatomic) NSString *repos_url;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *site_admin;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *blog;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *hireable;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSNumber *public_repos;
@property (strong, nonatomic) NSNumber *public_gists;
@property (strong, nonatomic) NSNumber *followers;
@property (strong, nonatomic) NSNumber *following;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *updated_at;
@property (strong, nonatomic) NSString *avatar_url;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSString *following_url;
@property (strong, nonatomic) NSString *gists_url;
@property (strong, nonatomic) NSString *starred_url;
@property (strong, nonatomic) NSString *subscriptions_url;
@property (strong, nonatomic) NSString *organizations_url;
@property (strong, nonatomic) NSString *events_url;
@property (strong, nonatomic) NSString *received_events_url;

- (instancetype) initWithDictionary:(NSDictionary *)dict;

@end

@interface GithubSearchResultItem : NSObject

@property (strong, nonatomic) NSNumber *userID;
@property (strong, nonatomic) NSString *login;
@property (strong, nonatomic) NSString *node_id;
@property (strong, nonatomic) NSString *avatar_url;
@property (strong, nonatomic) NSString *gravatar_id;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *html_url;
@property (strong, nonatomic) NSString *followers_url;
@property (strong, nonatomic) NSString *following_url;
@property (strong, nonatomic) NSString *gists_url;
@property (strong, nonatomic) NSString *starred_url;
@property (strong, nonatomic) NSString *subscriptions_url;
@property (strong, nonatomic) NSString *organizations_url;
@property (strong, nonatomic) NSString *repos_url;
@property (strong, nonatomic) NSString *events_url;
@property (strong, nonatomic) NSString *received_events_url;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSNumber *site_admin;
@property (strong, nonatomic) NSNumber *score;

- (instancetype) initWithDictionary:(NSDictionary *)dict;

@end

@interface GithubSearchResult : NSObject

@property (assign, nonatomic) NSNumber *total_count;
@property (assign, nonatomic) NSNumber *incomplete_results;
@property (strong, nonatomic) NSMutableArray *items;

- (instancetype) initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
