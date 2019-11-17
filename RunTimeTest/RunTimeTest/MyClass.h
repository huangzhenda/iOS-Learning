//
//  MyClass.h
//  RunTimeTest
//
//  Created by hwangzhenda on 2019/10/14.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyClass : NSObject <NSCopying, NSCoding>

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *string;

- (void)method1;

- (void)method2;

+ (void)classMethod;

@end

