//
//  Person.h
//  KVOTest
//
//  Created by hwangzhenda on 2019/10/17.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *firstName;

@property (nonatomic, strong) NSString *lastName;

@property (nonatomic, strong) Account *account;

@end

NS_ASSUME_NONNULL_END
