//
//  MasterViewController.h
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 07.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubAPI.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end

