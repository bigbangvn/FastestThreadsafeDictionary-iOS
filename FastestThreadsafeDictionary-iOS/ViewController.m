//
//  ViewController.m
//  FastestThreadsafeDictionary-iOS
//
//  Created by trongbangvp@gmail.com on 9/1/16.
//  Copyright © 2016 trongbangvp@gmail.com. All rights reserved.
//

#import "ViewController.h"
void testUnsafeDic();
void testThreadSafeDic();
void testPMutexDic();
void testSpinLockDic();
void testBarrierDic();
void testFirstRWDic();

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    const int n = 5;
    
    NSLog(@"START TEST THREADSAFE DICTIONARY WITH OSATIMIC CompareAndSwap");
    double endTime;
    double startTime = CACurrentMediaTime();
    
    for(int i=0;i<n;++i)
    {
        testThreadSafeDic();
    }
    
    endTime = CACurrentMediaTime();
    NSLog(@"Finish: %f", endTime - startTime);
    startTime = endTime;
    
    NSLog(@"START TEST THREADSAFE DICTIONARY WITH MUTEX");
    for(int i=0;i<n;++i)
    {
        testPMutexDic();
    }
    endTime = CACurrentMediaTime();
    NSLog(@"Finish: %f", endTime - startTime);
    startTime = endTime;
    
    NSLog(@"TEST THREADSAFE DIC WITH OSSPINLOCK");
    for(int i=0;i<n;++i)
    {
        testSpinLockDic();
    }
    endTime = CACurrentMediaTime();
    NSLog(@"Finish: %f", endTime - startTime);
    startTime = endTime;
    
    NSLog(@"TEST FIRST RW DIC");
    for(int i=0; i<n; ++i)
    {
        testFirstRWDic();
    }
    endTime = CACurrentMediaTime();
    NSLog(@"Finish: %f", endTime - startTime);
    startTime = endTime;
    
    NSLog(@"START TEST UNSAFE DICTIONARY. IT SHOULD CRASH, YOU KNOW......");
    
    testUnsafeDic();
    
    endTime = CACurrentMediaTime();
    NSLog(@"Finish: %f", endTime - startTime);
    startTime = endTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
