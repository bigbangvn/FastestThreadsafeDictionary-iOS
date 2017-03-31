//
//  BarrierThreadSafeDictionary.h
//  FastestThreadsafeDictionary-iOS
//
//  Created by trongbangvp@gmail.com on 3/31/17.
//  Copyright © 2017 trongbangvp@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//This dictionary uses GCD barrier to solve the ReadersWriter problem. But it's slow when there are lots of write operation
@interface BarrierThreadSafeDictionary : NSMutableDictionary

@end
