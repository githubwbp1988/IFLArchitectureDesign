//
//  IFLKVCObject.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import "IFLKVCObject.h"

@interface IFLKVCObject ()

@end

@implementation IFLKVCObject

//// 1.
//- (void)setName:(NSString *)name {
//    NSLog(@"%s -- name: %@", __func__, name);
//}
//
//// 2.
//- (void)_setName:(NSString *)name {
//    NSLog(@"%s -- name: %@", __func__, name);
//}
//
//// 3.
//- (void)setIsName:(NSString *)name {
//    NSLog(@"%s -- name: %@", __func__, name);
//}
//
//
//// 1.
//- (NSString *)getName {
//    return NSStringFromSelector(_cmd);
//}
//
//// 2.
//- (NSString *)name {
//    return NSStringFromSelector(_cmd);
//}
//
//// 3.
//- (NSString *)isName {
//    return NSStringFromSelector(_cmd);
//}
//
//// 4.
//- (NSString *)_name {
//    return NSStringFromSelector(_cmd);
//}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"%s --- key: %@", __func__, key);
}

//// 默认返回YES
//+ (BOOL)accessInstanceVariablesDirectly {
//    return YES;
//}

@end
