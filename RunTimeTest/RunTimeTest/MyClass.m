//
//  MyClass.m
//  RunTimeTest
//
//  Created by hwangzhenda on 2019/10/14.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import "MyClass.h"

@interface MyClass () {
    
    NSInteger _instance1;
    
    NSString *_instance2;
}

@property (nonatomic, assign) NSUInteger integer;

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end

@implementation MyClass

- (void)method1 {
    
}

- (void)method2 {
    
}

+ (void)classMethod {
    
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"arg1 : %ld, arg2 : %@", arg1, arg2);
}

@end
