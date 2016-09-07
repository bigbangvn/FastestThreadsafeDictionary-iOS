# FastestThreadsafeDictionary-iOS

NSMutableDictionary of iOS is not threadsafe. You may encountered problem when read/write shared NSMutableDictinary from multiple thread. I want to make fast and threadsafe mutable dictionary. The idea is use OSAtomic and lockless read operation:
  + Use separated lock for read and write. So, read operation is seemly lockless in case that we rarely write to the dictionary (such as lazy initialization, only 1 thread initialize data once and other threads read the data).
  + Only lock when read/write, write/write concurrently.

 But i can't find OSAtomic operation on iOS that can do something like that: Compare a to value x then set b to value y. So there is no absolute safe solution for lockless read -> Currently i use lock for all read/write operation. But certainly it's still very fast.

Comparision:
In the sample project: multiple thread read/write to a shared dictionary:
+ PMutexThreadsafeDictionary: 15.x seconds
+ FastestThreadsafeDictionary: 8.x seconds. So it's 2x faster than using pthread mutex

Note that both of them have their pros and cons:
+ Use atomic operation when you plan to hold the lock for extremely short interval, contention is rare (For example: lazy initialization)
+ Pthread: The advantage is waiting-thread does not take any CPU time. This requires intervention by the OS to stop the thread, and start it again when unlocking. But this OS intervention comes with a certain amount of overhead. 

Reference:

https://www.mikeash.com/pyblog/friday-qa-2011-03-04-a-tour-of-osatomic.html
http://www.alexonlinux.com/pthread-mutex-vs-pthread-spinlock
