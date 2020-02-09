//
//  ResultTableViewCell.m
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 08.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "DataCache.h"

@implementation ResultTableViewCell

- (void)prepareForReuse {
    [super prepareForReuse];
    self.avatarImageView.image = nil;
}

-(void) updateCellWithResultItem:(GithubSearchResultItem *)item {
    self.nameLabel.text = item.login;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *image = [DataCache imageLoadAndCacheForURL:item.avatar_url];
        if (!image) {
            image = [UIImage imageNamed:@"dummy_avatar"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.avatarImageView.alpha = 0;
            self.avatarImageView.image = image;
            [UIView animateWithDuration:0.5
                                  delay:0.1
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                self.avatarImageView.alpha = 1;
            }
                             completion:nil];
        });
    });
}

@end
