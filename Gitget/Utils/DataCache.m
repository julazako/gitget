//
//  DataCache.m
//  Gitget
//
//  Created by Julio Laszlo Zavaleta on 09.02.20.
//  Copyright © 2020 Julio Laszlo Zavaleta. All rights reserved.
//

#import "DataCache.h"
#import "NSStringMD5Extension.h"

@interface DataCache()
+ (NSString *) filePathForURL:(NSString *)url;
@end

@implementation DataCacheResult
@end

@implementation DataCache

+ (DataCacheResult *) URIStrForURL:(NSString *)url {
    DataCacheResult *ret = [[DataCacheResult alloc] init];
    NSString *filePath = [self filePathForURL:url];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        ret.uri = [NSURL fileURLWithPath:filePath].absoluteString;
        ret.cached = YES;
    }
    else {
        ret.uri = url;
        ret.cached = NO;
    }
    return ret;
}

+ (void) storeData:(NSData *)data forURL:(NSString *)url {
    NSString *filePath = [self filePathForURL:url];
    [data writeToFile:filePath atomically:YES];
}

+ (UIImage *) imageLoadAndCacheForURL:(NSString *)url {
    if (!url) return nil;
    DataCacheResult *res = [DataCache URIStrForURL:url];
    NSData *imgdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:res.uri]];
    if (imgdata && !res.cached) {
        [DataCache storeData:imgdata forURL:url];
    }
    return [UIImage imageWithData:imgdata];
}

#pragma mark - Private calls

+ (NSString *) filePathForURL:(NSString *)url {
    NSString *hash = [url sha256];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:hash];
}

@end
