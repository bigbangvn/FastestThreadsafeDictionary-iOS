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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"START TEST THREADSAFE DICTIONARY 1");
    
    double endTime;
    double startTime = CACurrentMediaTime();
    
    for(int i=0;i<5;++i)
    {
        testThreadSafeDic();
    }
    
    endTime = CACurrentMediaTime();
    NSLog(@"Finish: %f", endTime - startTime);
    startTime = endTime;
    
    NSLog(@"START TEST THREADSAFE DICTIONARY 2");
    for(int i=0;i<5;++i)
    {
        testPMutexDic();
    }
    endTime = CACurrentMediaTime();
    NSLog(@"Finish: %f", endTime - startTime);
    startTime = endTime;
    
    
    NSLog(@"START TEST UNSAFE DICTIONARY. IT MY CRASH, YOU KNOW");
    
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
