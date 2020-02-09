//
//  DetailViewController.m
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 07.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTableViewCell.h"
#import "FollowerTableViewCell.h"

@interface DetailViewController ()

@property (strong, nonatomic) NSMutableArray *details;
@property (strong, nonatomic) NSMutableArray *repos;
@property (strong, nonatomic) NSMutableArray *followers;
@property (strong, nonatomic) GithubUser *user;

- (void) loadData;
- (void) userDetailsForItem:(GithubSearchResultItem *)item;
- (void) reposForItem:(GithubSearchResultItem *)item;
- (void) followersForItem:(GithubSearchResultItem *)item;
- (void) handleUserDetailsResponseWithData:(NSData *)data;
- (void) handleReposResponseWithData:(NSData *)data;
- (void) handleFollowersResponseWithData:(NSData *)data;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarImageView.layer.cornerRadius = 5;
    self.avatarImageView.layer.masksToBounds = true;
    
    self.details = [NSMutableArray array];
    self.repos = [NSMutableArray array];
    self.followers = [NSMutableArray array];
    
    [self loadData];
}

- (void) loadData {
    [self.followers removeAllObjects];
    [self.repos removeAllObjects];
    [self.details removeAllObjects];
    
    self.loginLabel.text = nil;
    self.nameLabel.text = nil;

    if (self.detailItem) {
        [self userDetailsForItem:self.detailItem];
        [self reposForItem:self.detailItem];
        [self followersForItem:self.detailItem];
    }
    else {
        [self handleUserDetailsResponseWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"doomy_u" ofType:@"json"] options:NSDataReadingMappedIfSafe error:nil]];
        [self handleReposResponseWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"doomy_r" ofType:@"json"] options:NSDataReadingMappedIfSafe error:nil]];
        [self handleFollowersResponseWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"doomy_f" ofType:@"json"] options:NSDataReadingMappedIfSafe error:nil]];
    }
}

#pragma mark - Private calls

- (void) userDetailsForItem:(GithubSearchResultItem *)item {
    NSURL *URL = [NSURL URLWithString:item.url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            [weakSelf handleUserDetailsResponseWithData:data];
        }
        else {
            NSLog(@"handle error! statusCode : %ld", (long)((NSHTTPURLResponse *)response).statusCode);
        }
    }];
    [task resume];
}

- (void) reposForItem:(GithubSearchResultItem *)item {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?per_page=50", item.repos_url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            [weakSelf handleReposResponseWithData:data];
        }
        else {
            NSLog(@"handle error! statusCode : %ld", (long)((NSHTTPURLResponse *)response).statusCode);
        }
    }];
    [task resume];
}

- (void) followersForItem:(GithubSearchResultItem *)item {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?per_page=50", item.followers_url]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            [weakSelf handleFollowersResponseWithData:data];
        }
        else {
            NSLog(@"handle error! statusCode : %ld", (long)((NSHTTPURLResponse *)response).statusCode);
        }
    }];
    [task resume];
}

- (void) handleUserDetailsResponseWithData:(NSData *)data {
    NSError *error = nil;
    id resultJSON = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
    if (error || !resultJSON) {
        // handle error
        return;
    }
    
    NSArray *keys = @[
        @"userID", @"gravatar_id", @"company", 
        @"blog", @"location", @"email", @"hireable",
        @"bio", @"public_repos", @"public_gists", @"followers",
        @"following", @"created_at", @"updated_at"
    ];

    if ([resultJSON isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDict = resultJSON;
        self.user = [[GithubUser alloc] initWithDictionary:resultDict];
        for (NSString *key in keys) {
            id val = [self.user valueForKey:key];
            if (!val) { continue; }
            NSString *readableKey = [key stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            if ([val isKindOfClass:[NSString class]] && [(NSString *)val length] > 0) {
                @synchronized (self.details) {
                    if ([key isEqualToString:@"created_at"] || [key isEqualToString:@"updated_at"]) {
                        NSISO8601DateFormatter *dateFormatter = [[NSISO8601DateFormatter alloc] init];
                        [self.details addObject:@{ [readableKey capitalizedString] : [[dateFormatter dateFromString:val] description] }];
                    }
                    else {
                        [self.details addObject:@{ [readableKey capitalizedString] : (NSString *)val }];
                    }
                }
            }
            else if ([val isKindOfClass:[NSNumber class]]) {
                @synchronized (self.details) {
                    [self.details addObject:@{ [readableKey capitalizedString] : (NSString *)val }];
                }
            }
        }
        
        // set avatar image
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = self.user.avatar_url ? [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.user.avatar_url]]] : [UIImage imageNamed:@"dummy_avatar"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.avatarImageView.image = image;
            });
        });
        
        // refresh tableview
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.user.login) {
                self.loginLabel.text = [NSString stringWithFormat:@"@%@", self.user.login];
            }
            if (self.user.name) {
                self.nameLabel.text = self.user.name;
            }
            [self.detailTableView reloadData];
        });
    }
    else {
        // handle error
    }
}

- (void) handleReposResponseWithData:(NSData *)data {
    NSError *error = nil;
    id resultJSON = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
    if (error || !resultJSON) {
        // handle error
        return;
    }
    
    if ([resultJSON isKindOfClass:[NSArray class]]) {
        NSArray *resultArr = resultJSON;
        for (id elem in resultArr) {
            @try {
                if ([elem isKindOfClass:[NSDictionary class]]) {
                    NSString *name = [elem valueForKey:@"name"];
                    NSString *language = [elem valueForKey:@"language"];
                    
                    if (name == (id)[NSNull null]) {
                        name = @"n/a";
                    }
                    if (language == (id)[NSNull null]) {
                        language = @"n/a";
                    }
                    
                    @synchronized (self.repos) {
                        [self.repos addObject:[NSString stringWithFormat:@"%@ [%@]", name, language]];
                    }
                }
            } @catch (NSException *exception) {
                // handle this in production code or preferrably read the full github api and know the fields
            } @finally {
                // handle this in production code or preferrably read the full github api and know the fields
            }
        }
        
        // refresh tableview
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailTableView reloadData];
        });
    }
}

- (void) handleFollowersResponseWithData:(NSData *)data {
    NSError *error = nil;
    id resultJSON = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
    if (error || !resultJSON) {
        // handle error
        return;
    }
    
    if ([resultJSON isKindOfClass:[NSArray class]]) {
        NSArray *resultArr = resultJSON;
        for (id elem in resultArr) {
            if ([elem isKindOfClass:[NSDictionary class]]) {
                @synchronized (self.followers) {
                    [self.followers addObject:[[GithubUser alloc] initWithDictionary:elem]];
                }
            }
        }
        
        // refresh tableview
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.detailTableView reloadData];
        });
    }
}

#pragma mark - Table View

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return @"Details";
        case 1:
            return @"Repositories";
        case 2:
        default:
            return @"Followers";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.details count];
        case 1:
            return [self.repos count];
        case 2:
        default:
            return [self.followers count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[DetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCell"];
        }
        NSDictionary *detailDict = [self.details objectAtIndex:indexPath.row];
        NSString *key = [[detailDict allKeys] objectAtIndex:0];
        cell.nameLabel.text = key;
        id val = [detailDict objectForKey:key];
        if ([val isKindOfClass:[NSString class]]) {
            cell.valueLabel.text = (NSString *)val;
        }
        else if ([val isKindOfClass:[NSNumber class]]) {
            cell.valueLabel.text = [(NSNumber *)val description];
        }
        return cell;
    }
    else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RepoCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RepoCell"];
        }
        cell.textLabel.text = [self.repos objectAtIndex:indexPath.row];
        return cell;
    }
    else {
        FollowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowerCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[FollowerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FollowerCell"];
        }
        [cell updateCellWithUser:[self.followers objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
