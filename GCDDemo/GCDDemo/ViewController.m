//
//  ViewController.m
//  GCDDemo
//
//  Created by hwangzhenda on 2019/11/1.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("Test", DISPATCH_QUEUE_CONCURRENT);
    
    //栅栏函数， 一定是要自定义的并发队列，不然没有效果
    dispatch_barrier_sync(concurrentQueue, ^{
        
    });
}


@end
