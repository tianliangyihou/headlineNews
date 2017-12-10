//
//  YYDiskCacheHelper.h
//  headlineNews
//
//  Created by dengweihao on 2017/12/6.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYCache/YYCache.h>
@interface HNDiskCacheHelper : NSObject

@property (nonatomic , strong)YYDiskCache *diskCache;

+ (instancetype)defaultHelper;

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

- ( id<NSCoding>)objectForKey:(NSString *)key;

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void(^)(void))block;

- (void)removeObjectForKey:(NSString *)key;

- (void)setMaxArrayCount:(NSInteger)maxCount forKey:(NSString *)key;

- (void)removeMaxCountForKey:(NSString *)key;
@end
