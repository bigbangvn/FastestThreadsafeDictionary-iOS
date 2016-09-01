//
//  TBThreadSafeMutableDictionary.h
//  TestLockless-iOS
//
//  Created by trongbangvp@gmail.com on 9/1/16.
//  Copyright © 2016 trongbangvp@gmail.com. All rights reserved.
//

/*
 * Idea is:
 * Use separated lock for read and write
 * So, read operation is seemly lockless
 * Only lock when read/write, write/write concurrently.
 *
 * But currently, i can't find OSAtomic operation like that: compare a to value x, set b to value y. So there are no absolute safe solution -> use lock for all read/write operation
 * At least 10x faster than TSMutableDictionary
 */

#import <UIKit/UIKit.h>

@interface FastestThreadSafeDictionary : NSMutableDictionary

@end
