//
//  ResultTableViewCell.h
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 08.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GithubAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

-(void) updateCellWithResultItem:(GithubSearchResultItem *)item;

@end

NS_ASSUME_NONNULL_END
