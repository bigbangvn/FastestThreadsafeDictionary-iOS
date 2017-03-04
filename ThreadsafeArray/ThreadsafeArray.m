//
//  ThreadsafeArray.m
//  ZaloiOS-Developer
//
//  Created by trongbangvp@gmail.com on 3/4/17.
//
//

#import "ThreadsafeArray.h"
#import <libkern/OSAtomic.h>
#import <signal.h>

@interface ThreadsafeArray()
{
    OSSpinLock _spinLock;
}
@property(atomic, strong) NSMutableArray* internalArray;
@end

@implementation ThreadsafeArray
-(id) init
{
    if(self = [super init])
    {
        _spinLock = OS_SPINLOCK_INIT;
        _internalArray = [NSMutableArray new];
    }
    return self;
}

#pragma mark -
#pragma mark NSArray protocol
- (NSUInteger)count
{
    OSSpinLockLock(&_spinLock);
    NSUInteger n = _internalArray.count;
    OSSpinLockUnlock(&_spinLock);
    return n;
}

- (id)objectAtIndex:(NSUInteger)index;
{
    OSSpinLockLock(&_spinLock);
    id value = nil;
    if ([_internalArray count] > index) {
        value = [_internalArray objectAtIndex:index];
    }
    OSSpinLockUnlock(&_spinLock);
    return value;
}

#pragma mark -
#pragma mark NSMutableArray protocol
- (void)addObject:(id)anObject
{
    OSSpinLockLock(&_spinLock);
    [_internalArray addObject:anObject];
    OSSpinLockUnlock(&_spinLock);
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
    OSSpinLockLock(&_spinLock);
    if ([_internalArray count] >= index) {
        [_internalArray insertObject:anObject atIndex:index];
    } else {
        raise(SIGTRAP);
    }
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeLastObject
{
    OSSpinLockLock(&_spinLock);
    [_internalArray removeLastObject];
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    OSSpinLockLock(&_spinLock);
    if ([_internalArray count] > index) {
        [_internalArray removeObjectAtIndex:index];
    }
    OSSpinLockUnlock(&_spinLock);
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    OSSpinLockLock(&_spinLock);
    if ([_internalArray count] > index) {
      [_internalArray replaceObjectAtIndex:index withObject:anObject];
    }
    OSSpinLockUnlock(&_spinLock);
}

#pragma mark -
#pragma mark  NSExtendedMutableArray protocol

- (void)removeAllObjects
{
    OSSpinLockLock(&_spinLock);
    [_internalArray removeAllObjects];
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeObject:(id)anObject inRange:(NSRange)range
{
    OSSpinLockLock(&_spinLock);
    [_internalArray removeObject:anObject inRange:range];
    OSSpinLockUnlock(&_spinLock);
}

- (void)removeObject:(id)anObject
{
    OSSpinLockLock(&_spinLock);
    [_internalArray removeObject:anObject];
    OSSpinLockUnlock(&_spinLock);
}

#pragma mark - Utilities
- (NSArray*)copy
{
    OSSpinLockLock(&_spinLock);
    NSArray* arr = [_internalArray copy];
    OSSpinLockUnlock(&_spinLock);
    return arr;
}

- (void)removeObjectsInRange:(NSRange)range {
    OSSpinLockLock(&_spinLock);
    [_internalArray removeObjectsInRange:range];
    OSSpinLockUnlock(&_spinLock);
}

- (void)sortUsingComparator:(NSComparator)cmptr
{
    OSSpinLockLock(&_spinLock);
    [_internalArray sortUsingComparator:cmptr];
    OSSpinLockUnlock(&_spinLock);
}

- (NSUInteger)indexOfObject:(NSObject *)obj inSortedRange:(NSRange)r options:(NSBinarySearchingOptions)opts usingComparator:(NSComparator)cmp
{
    OSSpinLockLock(&_spinLock);
    NSRange newRange = r;
    if (r.location + r.length > _internalArray.count)
    {
      newRange = NSMakeRange(0, _internalArray.count>0?(_internalArray.count ): 0);
    }
    NSUInteger value = [_internalArray indexOfObject:obj inSortedRange:newRange options:opts usingComparator:cmp];
    OSSpinLockUnlock(&_spinLock);
    return value;
}

- (void)getObjects:(__unsafe_unretained id  _Nonnull *)objects range:(NSRange)r
{
    OSSpinLockLock(&_spinLock);
    NSRange newRange = r;
    if (newRange.location > _internalArray.count)
    {
      newRange = NSMakeRange(_internalArray.count<=0?0:(_internalArray.count-1), 0);
    }
    else
    {
      if (newRange.location + newRange.length > _internalArray.count)
      {
          newRange = NSMakeRange(newRange.location, _internalArray.count - newRange.location);
      }
    }
    [_internalArray getObjects: objects range:newRange];
    OSSpinLockUnlock(&_spinLock);
}

@end
