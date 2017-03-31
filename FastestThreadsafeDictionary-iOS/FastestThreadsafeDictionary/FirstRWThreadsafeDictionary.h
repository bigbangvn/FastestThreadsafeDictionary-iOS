//
//  FirstRWThreadsafeDictionary.h
//  FastestThreadsafeDictionary-iOS
//
//  Created by trongbangvp@gmail.com on 3/31/17.
//  Copyright © 2017 trongbangvp@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//https://en.wikipedia.org/wiki/Readers%E2%80%93writers_problem
//In First ReadersWriter solution, write can be starve, so it maybe suitable for lazy initialization with some write and almost read operation
@interface FirstRWThreadsafeDictionary : NSMutableDictionary

@end
