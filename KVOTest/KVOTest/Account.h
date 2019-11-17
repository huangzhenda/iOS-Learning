//
//  Account.h
//  KVOTest
//
//  Created by hwangzhenda on 2019/10/17.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Account : NSObject

@property (nonatomic, strong) NSNumber *balance;

@property (nonatomic, strong) NSNumber *interestRate;

//@property (nonatomic, strong) NSMutableArray *transactions;


@end

NS_ASSUME_NONNULL_END
