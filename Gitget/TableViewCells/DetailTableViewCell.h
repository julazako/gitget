//
//  DetailTableViewCell.h
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 09.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

NS_ASSUME_NONNULL_END
