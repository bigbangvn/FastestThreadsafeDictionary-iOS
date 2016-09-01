# FastestThreadsafeDictionary-iOS

NSMutableDictionary of iOS is not threadsafe. So someone may encountered problem when use shared NSMutableDictinary with multiple thread.
Me too so i want to make fast and threadsafe mutable dictionary. The idea is:
  + Use separated lock for read and write. So, read operation is seemly lockless in case that we rarely write to the dictionary (such as lazy initialization, only 1 thread initialize data once and other threads read the data).
  + Only lock when read/write, write/write concurrently.

 But currently, i can't find OSAtomic operation on <libkern/OSAtomic.h> the do something like that: Compare a to value x then set b to value y. So there are no absolute safe solution for lockless read -> Currently i use lock for all read/write operation. But certainly it's still very fast.

Comparision:
In a test in sample project: read and write in multiple thread use GCD for iOS:
+ PMutexThreadsafeDictionary: 15.x seconds
+ FastestThreadsafeDictionary: 8.x seconds. So it's 2x faster than using pthread mutex