//
//  Person.m
//  KVOTest
//
//  Created by hwangzhenda on 2019/10/17.
//  Copyright © 2019年 hwangzhenda. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)name {
    
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

//+ (NSSet<NSString *> *)keyPathsForValuesAffectingName {
//    
//    return [NSSet setWithObjects:@"lastName",@"firstName", nil];
//}

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"name"]) {
        NSArray *affectingKeys = @[@"lastName",@"firstName"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

@end
