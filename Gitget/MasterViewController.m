//
//  MasterViewController.m
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 07.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ResultTableViewCell.h"
#import <CoreGraphics/CoreGraphics.h>

static NSString *kGithubSearchUsersURL = @"https://api.github.com/search/users?q=%@+in:login&type=Users&per_page=%d&page=%d";
static NSInteger kGithubPageSize = 50;

@interface MasterViewController ()

@property (strong, nonatomic) GithubSearchResult *result;
@property (assign, nonatomic) NSInteger page;
@property (strong, nonatomic) NSString *searchText;

- (void) searchForUsersWithLogin:(NSString *)login;
- (void) handleGithubResponseWithData:(NSData *)data;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 1;
    
    UISearchController *searchController = [[UISearchController alloc] init];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.searchBar.placeholder = @"Login Name";
    searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.navigationItem.searchController = searchController;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

#pragma mark - Private calls

- (void) searchForUsersWithLogin:(NSString *)login {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:kGithubSearchUsersURL, login, kGithubPageSize, self.page]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request addValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self)weakSelf = self;
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (((NSHTTPURLResponse *)response).statusCode == 200) {
            [weakSelf handleGithubResponseWithData:data];
        }
        else {
            NSLog(@"handle error! statusCode : %ld", (long)((NSHTTPURLResponse *)response).statusCode);
        }
    }];
    [task resume];
}

- (void) handleGithubResponseWithData:(NSData *)data {
    NSError *error = nil;
    id resultJSON = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:&error] : nil;
    if (!error && [resultJSON isKindOfClass:[NSDictionary class]]) {
        NSDictionary *resultDict = resultJSON;
        @synchronized (self) {
            if (!self.result) {
                self.result = [[GithubSearchResult alloc] initWithDictionary:resultDict];
            }
            else {
                GithubSearchResult *newResult = [[GithubSearchResult alloc] initWithDictionary:resultDict];
                [self.result.items addObjectsFromArray:newResult.items];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
    else {
        // handle error
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        GithubSearchResultItem *item = self.result.items[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        controller.detailItem = item;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        self.detailViewController = controller;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.result.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [cell updateCellWithResultItem:self.result.items[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.result.items.count - 1 && [self.result.total_count unsignedIntegerValue] > self.result.items.count) {
        self.page++;
        [self performSelector:@selector(searchForUsersWithLogin:) withObject:self.searchText afterDelay:0.2];
    }
    else {
        cell.transform = CGAffineTransformMakeTranslation(0, 44);
        cell.alpha = 0;
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, 0);
            cell.alpha = 1;
        }
                         completion:nil];
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length < 3) return;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    self.searchText = searchText;
    self.page = 1;
    self.result = nil;
    [self.tableView reloadData];
    [self performSelector:@selector(searchForUsersWithLogin:) withObject:searchText afterDelay:0.3];
}

@end
