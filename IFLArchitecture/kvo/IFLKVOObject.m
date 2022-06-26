//
//  IFLKVOObject.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import "IFLKVOObject.h"

@implementation IFLKVOObject

//// 只有address的变化不会自动通知观察者
//+ (BOOL)automaticallyNotifiesObserversOfAddress {
//    return NO;
//}

//// 所有的属性变化都不会自动通知观察者
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    return NO;
//}
//
//- (void)setName:(NSString *)name {
////    [self willChangeValueForKey:@"name"];
//    _name = name;
////    [self didChangeValueForKey:@"name"];
//}

// 组合观察
+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    if ([key isEqualToString:@"progress"]) {
        NSArray *affectingKeys = @[@"received", @"total"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

- (NSString *)progress {
    if (self.received == 0) {
        self.received = 1.0;
    }
    if (self.total == 0) {
        self.total = 100.0;
    }
    return [[NSString alloc] initWithFormat:@"%f",1.0f * self.received / self.total];
}

@end
