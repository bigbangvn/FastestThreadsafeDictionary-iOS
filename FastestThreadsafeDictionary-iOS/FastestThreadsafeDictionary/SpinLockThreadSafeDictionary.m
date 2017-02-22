//
//  SpinLockThreadSafeDictionary.m
//  FastestThreadsafeDictionary-iOS
//
//  Created by trongbangvp@gmail.com on 9/27/16.
//  Copyright © 2016 trongbangvp@gmail.com. All rights reserved.
//

#import <libkern/OSAtomic.h>
#import "SpinLockThreadSafeDictionary.h"
@interface SpinLockThreadSafeDictionary()
{
    OSSpinLock _spinLock;
}
@property(atomic, strong) NSMutableDictionary* dic;
@end

@implementation SpinLockThreadSafeDictionary
-(id) init
{
    if(self = [super init])
    {
        _spinLock = OS_SPINLOCK_INIT;
        _dic = [NSMutableDictionary new];
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)otherDictionary
{
    if(self = [super init])
    {
        _spinLock = OS_SPINLOCK_INIT;
        if(otherDictionary)
            _dic = [otherDictionary mutableCopy];
        else
            _dic = [NSMutableDictionary new];
    }
    return self;
}
-(void)dealloc
{
}

#pragma mark - Read operation
//Read operation is lockless, just checking lock-write

-(NSUInteger)count
{
    OSSpinLockLock(&_spinLock);
    
    NSUInteger n = self.dic.count;
    
    OSSpinLockUnlock(&_spinLock);
    return n;
}

-(id) objectForKey:(id)aKey
{
    OSSpinLockLock(&_spinLock);
    
    id val = [self.dic objectForKey:aKey];
    
    OSSpinLockUnlock(&_spinLock);
    return val;
}

- (NSEnumerator*)keyEnumerator
{
    OSSpinLockLock(&_spinLock);
    
    id val = [self.dic keyEnumerator];
    
    OSSpinLockUnlock(&_spinLock);
    return val;
}
- (NSArray*)allKeys
{
    OSSpinLockLock(&_spinLock);
    
    id val = [self.dic allKeys];
    
    OSSpinLockUnlock(&_spinLock);
    return val;
}
- (NSArray*)allValues
{
    OSSpinLockLock(&_spinLock);
    
    id val = [self.dic allValues];
    
    OSSpinLockUnlock(&_spinLock);
    return val;
}

#pragma mark - Write operation
-(void) setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    OSSpinLockLock(&_spinLock);
    
    [self.dic setObject:anObject forKey:aKey];
    
    OSSpinLockUnlock(&_spinLock);
}

- (void)addEntriesFromDictionary:(NSDictionary*)otherDictionary
{
    OSSpinLockLock(&_spinLock);
    
    [self.dic addEntriesFromDictionary:otherDictionary];
    
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeObjectForKey:(id)aKey
{
    OSSpinLockLock(&_spinLock);
    
    [self.dic removeObjectForKey:aKey];
    
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    OSSpinLockLock(&_spinLock);
    
    [self.dic removeObjectsForKeys:keyArray];
    
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeAllObjects
{
    OSSpinLockLock(&_spinLock);
    
    [self.dic removeAllObjects];
    
    OSSpinLockUnlock(&_spinLock);
}
@end
