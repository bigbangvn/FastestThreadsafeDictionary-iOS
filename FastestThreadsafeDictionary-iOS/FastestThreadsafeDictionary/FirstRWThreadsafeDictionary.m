//
//  FirstRWThreadsafeDictionary.m
//  FastestThreadsafeDictionary-iOS
//
//  Created by trongbangvp@gmail.com on 3/31/17.
//  Copyright © 2017 trongbangvp@gmail.com. All rights reserved.
//

#import "FirstRWThreadsafeDictionary.h"
#import <libkern/OSAtomic.h>

@interface FirstRWThreadsafeDictionary()
{
    volatile OSSpinLock _spinLockR;
    volatile OSSpinLock _spinLockW;
    volatile int32_t _readCount;
}
@property(atomic, strong) NSMutableDictionary* dic;
@end

@implementation FirstRWThreadsafeDictionary

-(id) init
{
    if(self = [super init])
    {
        _spinLockR = OS_SPINLOCK_INIT;
        _spinLockW = OS_SPINLOCK_INIT;
        _readCount = 0;
        _dic = [NSMutableDictionary new];
    }
    return self;
}
-(id)initWithDictionary:(NSDictionary *)otherDictionary
{
    if(self = [super init])
    {
        _spinLockR = OS_SPINLOCK_INIT;
        _spinLockW = OS_SPINLOCK_INIT;
        _readCount = 0;
        if(otherDictionary)
            _dic = [otherDictionary mutableCopy];
        else
            _dic = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Read operation
//Read operation is lockless, just checking lock-write

-(NSUInteger)count
{
    //Entry section
    OSSpinLockLock(&_spinLockR);
    ++_readCount;
    if(_readCount == 1)
        OSSpinLockLock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    
    NSUInteger n = self.dic.count;
    
    //Exit section
    OSSpinLockLock(&_spinLockR);
    --_readCount;
    if(_readCount == 0)
        OSSpinLockUnlock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    return n;
}

-(id) objectForKey:(id)aKey
{
    //Entry section
    OSSpinLockLock(&_spinLockR);
    ++_readCount;
    if(_readCount == 1)
        OSSpinLockLock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    
    id val = [self.dic objectForKey:aKey];
    
    //Exit section
    OSSpinLockLock(&_spinLockR);
    --_readCount;
    if(_readCount == 0)
        OSSpinLockUnlock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    return val;
}

- (NSEnumerator*)keyEnumerator
{
    //Entry section
    OSSpinLockLock(&_spinLockR);
    ++_readCount;
    if(_readCount == 1)
        OSSpinLockLock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    
    id val = [self.dic keyEnumerator];
    
    //Exit section
    OSSpinLockLock(&_spinLockR);
    --_readCount;
    if(_readCount == 0)
        OSSpinLockUnlock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    return val;
}
- (NSArray*)allKeys
{
    //Entry section
    OSSpinLockLock(&_spinLockR);
    ++_readCount;
    if(_readCount == 1)
        OSSpinLockLock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    
    id val = [self.dic allKeys];
    
    //Exit section
    OSSpinLockLock(&_spinLockR);
    --_readCount;
    if(_readCount == 0)
        OSSpinLockUnlock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    return val;
}
- (NSArray*)allValues
{
    //Entry section
    OSSpinLockLock(&_spinLockR);
    ++_readCount;
    if(_readCount == 1)
        OSSpinLockLock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    
    id val = [self.dic allValues];
    
    //Exit section
    OSSpinLockLock(&_spinLockR);
    --_readCount;
    if(_readCount == 0)
        OSSpinLockUnlock(&_spinLockW);
    OSSpinLockUnlock(&_spinLockR);
    return val;
}

#pragma mark - Write operation
-(void) setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    OSSpinLockLock(&_spinLockW);
    
    [self.dic setObject:anObject forKey:aKey];
    
    OSSpinLockUnlock(&_spinLockW);
}

- (void)addEntriesFromDictionary:(NSDictionary*)otherDictionary
{
    OSSpinLockLock(&_spinLockW);
    
    [self.dic addEntriesFromDictionary:otherDictionary];
    
    OSSpinLockUnlock(&_spinLockW);
}

- (void)removeObjectForKey:(id)aKey
{
    OSSpinLockLock(&_spinLockW);
    
    [self.dic removeObjectForKey:aKey];
    
    OSSpinLockUnlock(&_spinLockW);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    OSSpinLockLock(&_spinLockW);
    
    [self.dic removeObjectsForKeys:keyArray];
    
    OSSpinLockUnlock(&_spinLockW);
}

- (void)removeAllObjects
{
    OSSpinLockLock(&_spinLockW);
    
    [self.dic removeAllObjects];
    
    OSSpinLockUnlock(&_spinLockW);
}

@end
