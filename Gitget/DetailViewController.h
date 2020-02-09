//
//  DetailViewController.h
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 07.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubAPI.h"

@interface DetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) GithubSearchResultItem *detailItem;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;

@end

