//
//  Account.m
//  KVOTest
//
//  Created by hwangzhenda on 2019/10/17.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import "Account.h"

@interface Account () {
    
    NSMutableArray *_transcations;
}


@end

@implementation Account

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _transcations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)countOfTransactions {
    
    return _transcations.count;
}

- (id)objectInTransactionsAtIndex:(NSUInteger)index {
    
    return [_transcations objectAtIndex:index];
}

- (void)insertTransactions:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    
    [_transcations insertObjects:array atIndexes:indexes];
}

- (void)removeTransactionsAtIndexes:(NSIndexSet *)indexes {
    
    [_transcations removeObjectsAtIndexes:indexes];
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    
    BOOL automatic = NO;
    
    if ([key isEqualToString:@"balance"]) {
        automatic = NO;
    }else{
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    
    return automatic;
}

#pragma mark -
- (void)setBalance:(NSNumber *)balance {
    
    if (balance != _balance) {
        [self willChangeValueForKey:@"balance"];
        _balance = balance;
        [self didChangeValueForKey:@"balance"];
    }
}


@end
