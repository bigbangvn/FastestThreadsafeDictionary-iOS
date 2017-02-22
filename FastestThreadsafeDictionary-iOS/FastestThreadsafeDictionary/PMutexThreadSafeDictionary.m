//
//  TBThreadSafeMutableDictionary.m
//  TestLockless-iOS
//
//  Created by trongbangvp@gmail.com on 9/1/16.
//  Copyright © 2016 trongbangvp@gmail.com. All rights reserved.
//
#import <pthread/pthread.h>
#import "PMutexThreadSafeDictionary.h"

@interface PMutexThreadSafeDictionary()
{
    pthread_mutex_t _mutex;
}
@property(atomic, strong) NSMutableDictionary* dic;
@end

@implementation PMutexThreadSafeDictionary

-(id) init
{
    if(self = [super init])
    {
        pthread_mutex_init(&_mutex, NULL);
        _dic = [NSMutableDictionary new];
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
    }
    return self;
}
-(void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

#pragma mark - Read operation
//Read operation is lockless, just checking lock-write

-(NSUInteger)count
{
    pthread_mutex_lock(&_mutex);
    
    NSUInteger n = self.dic.count;
    
    pthread_mutex_unlock(&_mutex);
    return n;
}

-(id) objectForKey:(id)aKey
{
    pthread_mutex_lock(&_mutex);
    
    id val = [self.dic objectForKey:aKey];
    
    pthread_mutex_unlock(&_mutex);
    return val;
}

- (NSEnumerator*)keyEnumerator
{
    pthread_mutex_lock(&_mutex);
    
    id val = [self.dic keyEnumerator];
    
    pthread_mutex_unlock(&_mutex);
    return val;
}
- (NSArray*)allKeys
{
    pthread_mutex_lock(&_mutex);
    
    id val = [self.dic allKeys];
    
    pthread_mutex_unlock(&_mutex);
    return val;
}
- (NSArray*)allValues
{
    pthread_mutex_lock(&_mutex);
    
    id val = [self.dic allValues];
    
    pthread_mutex_unlock(&_mutex);
    return val;
}

#pragma mark - Write operation
-(void) setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    pthread_mutex_lock(&_mutex);
    
    [self.dic setObject:anObject forKey:aKey];
    
    pthread_mutex_unlock(&_mutex);
}

- (void)addEntriesFromDictionary:(NSDictionary*)otherDictionary
{
    pthread_mutex_lock(&_mutex);
    
    [self.dic addEntriesFromDictionary:otherDictionary];
    
    pthread_mutex_unlock(&_mutex);
}

- (void)removeObjectForKey:(id)aKey
{
    pthread_mutex_lock(&_mutex);
    
    [self.dic removeObjectForKey:aKey];
    
    pthread_mutex_unlock(&_mutex);
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    pthread_mutex_lock(&_mutex);
    
    [self.dic removeObjectsForKeys:keyArray];
    
    pthread_mutex_unlock(&_mutex);
}

- (void)removeAllObjects
{
    pthread_mutex_lock(&_mutex);
    
    [self.dic removeAllObjects];
    
    pthread_mutex_unlock(&_mutex);
}

@end

