//
//  ViewController.m
//  KVOTest
//
//  Created by hwangzhenda on 2019/10/17.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Account.h"

static void *PersonNameContext = &PersonNameContext;
static void *PersonAccountBalanceContext = &PersonAccountBalanceContext;
static void *PersonAccountInterestRateContext = &PersonAccountInterestRateContext;

@interface ViewController ()

@property (nonatomic, strong) Person *person;


@end

@implementation ViewController

- (void)dealloc {
    
    [self.person removeObserver:self forKeyPath:@"account"];
    [self unregisterAsObserverForAccount:self.person.account];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //URL
    
    NSString  *url = [NSString stringWithFormat:@""];
    
    
//    self.person = [[Person alloc] init];
//    self.person.account = [[Account alloc] init];
//    [self registerAsOberserForAccount:self.person.account];
//
//    [self.person addObserver:self
//                  forKeyPath:@"name"
//                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//                     context:PersonNameContext];
    
//    [self.person.account addObserver:self
//                  forKeyPath:@"transactions"
//                     options: NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//                     context:PersonNameContext];

    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //muatal noti
    self.person.account.balance = @(10.0);
    
    
//    self.person.account.interestRate = @(11);

    
//    NSObject *newTranscation = [[NSObject alloc] init];
//    NSMutableArray *transactions = [self.person.account mutableArrayValueForKey:@"transactions"];
//    [transactions addObject:newTranscation];
    
    self.person.lastName = @"hwang";
    self.person.firstName = @"zhenda";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSLog(@"KeyPath: %@",keyPath);
    NSLog(@"Object: %@",object);
    NSLog(@"Change: %@",change);
    
    if (context == PersonNameContext) {
    }else if (context == PersonAccountBalanceContext) {
        // Do something with the balance…
        
    } else if (context == PersonAccountInterestRateContext) {
        // Do something with the interest rate…
        
    } else {
        // Any unrecognized context must belong to super
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
    
}


#pragma mark - KVO三部曲
- (void)registerAsOberserForAccount:(Account *)account {
    
    [account addObserver:self
              forKeyPath:@"balance"
                 options:(NSKeyValueObservingOptionNew |
                          NSKeyValueObservingOptionOld)
                 context:PersonAccountBalanceContext];
    
    [account addObserver:self
              forKeyPath:@"interestRate"
                 options:(NSKeyValueObservingOptionNew |
                          NSKeyValueObservingOptionOld)
                 context:PersonAccountInterestRateContext];
}


- (void)unregisterAsObserverForAccount:(Account *)account {
    
    @try {
        [account removeObserver:self
                     forKeyPath:@"balance"
                        context:PersonAccountBalanceContext];
        
        [account removeObserver:self
                     forKeyPath:@"interestRate"
                        context:PersonAccountInterestRateContext];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
    } @finally {
        NSLog(@"@finally");
    }    
}

@end
