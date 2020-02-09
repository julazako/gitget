//
//  DataCache.h
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 09.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Wrapper class for DataCache
 */
@interface DataCacheResult : NSObject

/** A URI string */
@property (strong, nonatomic) NSString *uri;
/** YES if origin is result is cache */
@property (assign, nonatomic) BOOL cached;

@end

/**
 A simple disk cache utility class to store data from a given URL
 */
@interface DataCache : NSObject

+ (DataCacheResult *) URIStrForURL:(NSString *)url;
+ (void) storeData:(NSData *)data forURL:(NSString *)url;

+ (UIImage *) imageLoadAndCacheForURL:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
