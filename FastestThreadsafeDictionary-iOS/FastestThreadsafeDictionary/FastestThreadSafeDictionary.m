//
//  TBThreadSafeMutableDictionary.m
//  TestLockless-iOS
//
//  Created by trongbangvp@gmail.com on 9/1/16.
//  Copyright © 2016 trongbangvp@gmail.com. All rights reserved.
//
#import <libkern/OSAtomic.h>
#import <dispatch/dispatch.h>
#import "FastestThreadSafeDictionary.h"


#define ATOMIC_THREAD_SAFE(...) while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));\
                                __VAR_ARGS__;\
                                OSAtomicCompareAndSwap32(1, 0, &_lockFlag);

@interface FastestThreadSafeDictionary()
{
    int32_t volatile _lockFlag;
}
@property(atomic, strong) NSMutableDictionary* dic;
@end

@implementation FastestThreadSafeDictionary

-(id) init
{
    if(self = [super init])
    {
        _lockFlag = 0;
        _dic = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Read operation
//Read operation is lockless, just checking lock-write

-(NSUInteger)count
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    NSUInteger n = self.dic.count;
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
    return n;
}

-(id) objectForKey:(id)aKey
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    id val = [self.dic objectForKey:aKey];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
    return val;
}

- (NSEnumerator*)keyEnumerator
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    id val = [self.dic keyEnumerator];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
    return val;
}
- (NSArray*)allKeys
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    id val = [self.dic allKeys];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
    return val;
}
- (NSArray*)allValues
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    id val = [self.dic allValues];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
    return val;
}

#pragma mark - Write operation
-(void) setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    [self.dic setObject:anObject forKey:aKey];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
}

- (void)addEntriesFromDictionary:(NSDictionary*)otherDictionary
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    [self.dic addEntriesFromDictionary:otherDictionary];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
}

- (void)removeObjectForKey:(id)aKey
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    [self.dic removeObjectForKey:aKey];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    [self.dic removeObjectsForKeys:keyArray];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
}

- (void)removeAllObjects
{
    while(!OSAtomicCompareAndSwap32(0, 1, &_lockFlag));
    
    [self.dic removeAllObjects];
    
    OSAtomicCompareAndSwap32(1, 0, &_lockFlag);
}

@end

