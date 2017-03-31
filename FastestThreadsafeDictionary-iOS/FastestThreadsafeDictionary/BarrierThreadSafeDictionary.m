//
//  BarrierThreadSafeDictionary.m
//  FastestThreadsafeDictionary-iOS
//
//  Created by trongbangvp@gmail.com on 3/31/17.
//  Copyright © 2017 trongbangvp@gmail.com. All rights reserved.
//

#import "BarrierThreadSafeDictionary.h"
#import <dispatch/dispatch.h>

@interface BarrierThreadSafeDictionary()
@property(nonatomic, strong) NSMutableDictionary* dic;
@property(nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation BarrierThreadSafeDictionary
-(id) init
{
    if(self = [super init])
    {
        _dic = [NSMutableDictionary new];
        _concurrentQueue = dispatch_queue_create("myConcurrent", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)otherDictionary
{
    if(self = [super init])
    {
        if(otherDictionary)
            _dic = [otherDictionary mutableCopy];
        else
            _dic = [NSMutableDictionary new];
        _concurrentQueue = dispatch_queue_create("myConcurrent", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

#pragma mark - Read operation
//Read operation is lockless, just checking lock-write

-(NSUInteger)count
{
    __block NSUInteger n;
    dispatch_sync(_concurrentQueue, ^{
        n = self.dic.count;
    });
    return n;
}

-(id) objectForKey:(id)aKey
{
    __block id val;
    dispatch_sync(_concurrentQueue, ^{
        val = [self.dic objectForKey:aKey];
    });
    return val;
}

- (NSEnumerator*)keyEnumerator
{
    __block id val;
    dispatch_sync(_concurrentQueue, ^{
        val = [self.dic keyEnumerator];
    });
    return val;
}
- (NSArray*)allKeys
{
    __block id val;
    dispatch_sync(_concurrentQueue, ^{
        val = [self.dic allKeys];
    });
    return val;
}
- (NSArray*)allValues
{
    __block id val;
    dispatch_sync(_concurrentQueue, ^{
        val = [self.dic allValues];
    });
    return val;
}

#pragma mark - Write operation
-(void) setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    dispatch_barrier_sync(_concurrentQueue, ^{
        [self.dic setObject:anObject forKey:aKey];
    });
}

- (void)addEntriesFromDictionary:(NSDictionary*)otherDictionary
{
    dispatch_barrier_sync(_concurrentQueue, ^{
        [self.dic addEntriesFromDictionary:otherDictionary];
    });
}

- (void)removeObjectForKey:(id)aKey
{
    dispatch_barrier_sync(_concurrentQueue, ^{
        [self.dic removeObjectForKey:aKey];
    });
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    dispatch_barrier_sync(_concurrentQueue, ^{
        [self.dic removeObjectsForKeys:keyArray];
    });
}

- (void)removeAllObjects
{
    dispatch_barrier_sync(_concurrentQueue, ^{
        [self.dic removeAllObjects];
    });
}

@end
