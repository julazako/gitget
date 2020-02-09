//
//  NSStringMD5Extension.h
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 09.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SHA256)
- (NSString *) sha256;
@end

NS_ASSUME_NONNULL_END
