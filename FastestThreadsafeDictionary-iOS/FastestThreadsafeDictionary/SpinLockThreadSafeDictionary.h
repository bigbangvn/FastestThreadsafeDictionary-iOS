//
//  SpinLockThreadSafeDictionary.h
//  FastestThreadsafeDictionary-iOS
//
//  Created by trongbangvp@gmail.com on 9/27/16.
//  Copyright © 2016 trongbangvp@gmail.com. All rights reserved.
//

//May has same perfomance as using OSAtomicCompareAndSwap32
//But in my test it's slightly faster than use OSAtomicCompareAndSwap32 !!

#import <Foundation/Foundation.h>

@interface SpinLockThreadSafeDictionary : NSMutableDictionary

@end
