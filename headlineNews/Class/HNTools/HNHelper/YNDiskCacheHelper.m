//
//  YYDiskCacheHelper.m
//  headlineNews
//
//  Created by dengweihao on 2017/12/6.
//  Copyright © 2017年 vcyber. All rights reserved.
//

#import "HNDiskCacheHelper.h"
#import "HNMicroLayout.h"
static HNDiskCacheHelper *hepler = nil;
@interface HNDiskCacheHelper ()

@property (nonatomic , strong)NSMutableDictionary *keyDic;

@end

@implementation HNDiskCacheHelper

- (NSMutableDictionary *)keyDic {
    if (!_keyDic) {
        _keyDic = [[NSMutableDictionary alloc]init];
    }
    return _keyDic;
}

+ (instancetype)defaultHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hepler = [[HNDiskCacheHelper alloc]initWithName:@"llbCache"];
    });
    return hepler;
}

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        NSString *cacheFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *path = [cacheFolder stringByAppendingPathComponent:name];
        self.diskCache = [[YYDiskCache alloc]initWithPath:path];
        [self keyDic];
    }
    return self;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    if (self.keyDic[key]) {
      object = [self trimArray:(NSArray *)object toTargetCount:[self.keyDic[key] integerValue]];
    }

    [self.diskCache setObject:object forKey:key];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key withBlock:(void (^)(void))block {
    
    if (self.keyDic[key]) {
      object =  [self trimArray:(NSArray *)object toTargetCount:[self.keyDic[key] integerValue]];
    }
    
    [self.diskCache setObject:object forKey:key withBlock:^{
        if (block) {
            block();
        }
    }];
}
- (id<NSCoding>)objectForKey:(NSString *)key {
    return [self.diskCache objectForKey:key];
}

- (void)removeObjectForKey:(NSString *)key {
    [self.diskCache removeObjectForKey:key];
}

- (void)setMaxArrayCount:(NSInteger)maxCount forKey:(NSString *)key {
    self.keyDic[key]= @(maxCount);
}

// 超过最大的 保留最新的
- (id<NSCoding>)trimArray:(NSArray *)datas toTargetCount:(NSInteger)count {
    count = count > 0 ? count:0;
    if (datas.count <= count) {
        return datas;
    }
    int beginCount = (int)datas.count - (int)count;
    NSMutableArray *newDatas = [[NSMutableArray alloc]init];
    for (int i = beginCount ; i <datas.count; i++) {
        [newDatas addObject: datas[i]];
    }
    return newDatas;
}
- (void)removeMaxCountForKey:(NSString *)key {
    [self.keyDic removeObjectForKey:key];
}
@end
