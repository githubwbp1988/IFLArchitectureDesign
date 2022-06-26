//
//  NSObject+IFLKVC.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import "NSObject+IFLKVC.h"
#import <objc/runtime.h>

@implementation NSObject (IFLKVC)

- (void)ifl_setValue:(nullable id)value forKey:(NSString *)key {
    if (key == nil || key.length == 0) {
        return;
    }
    
    NSString *Key = key.capitalizedString;
    // set<Key>  _set<Key>  setIs<Key>
    NSString *setKey = [NSString stringWithFormat:@"set%@", Key];
    NSString *_setKey = [NSString stringWithFormat:@"_set%@", Key];
    NSString *setIsKey = [NSString stringWithFormat:@"setIs%@", Key];
    
    // 判断有无实现 三个 set方法
    if ([self ifl_performSelectorWithMethodName:setKey value:value]) {
        
        return;
    }
    if ([self ifl_performSelectorWithMethodName:_setKey value:value]) {
        
        return;
    }
    if ([self ifl_performSelectorWithMethodName:setIsKey value:value]) {
        
        return;
    }
    
    // 没事实现三个set 方法，判断 accessInstanceVariablesDirectly
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"IFLUndefinedKey Exception"
                                       reason:[NSString stringWithFormat:@"****[%@ forUndefinedKey:%@]: this class is not key-value coding compliant", self, key]
                                     userInfo:nil];
    }
    
    // _<key> _is<Key> <key> is<Key>
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", Key];
    NSString *isKey = [NSString stringWithFormat:@"is%@", Key];
    // 检查成员变量 ivars
    NSArray *mArray = [self getIvarsList];
    if ([mArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
    if ([mArray containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
    if ([mArray containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
    if ([mArray containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
    @throw [NSException exceptionWithName:@"IFLUndefinedKey Exception"
                                   reason:[NSString stringWithFormat:@"****[%@ forUndefinedKey:%@]: this class is key-value coding compliant, but ivar-%@ can not be founc", self, key, key]
                                 userInfo:nil];
}


- (nullable id)ifl_valueForKey:(NSString *)key {
    if (key == nil || key.length == 0) {
        return nil;
    }
    
    NSString *Key = key.capitalizedString;
    // get<Key>  <key>  is<Key> _<key>
    NSString *getKey = [NSString stringWithFormat:@"get%@", Key];
    NSString *isKey = [NSString stringWithFormat:@"is%@", Key];
    NSString *_key = [NSString stringWithFormat:@"_%@", key];
    
    NSString *countOfKey = [NSString stringWithFormat:@"countOf%@", Key];
    NSString *objectInKeyAtIndex = [NSString stringWithFormat:@"objectIn%@AtIndex:", Key];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // 判断有无实现 4个 get方法
    if ([self respondsToSelector:NSSelectorFromString(getKey)]) {
        return [self performSelector:NSSelectorFromString(getKey)];
    }
    if ([self respondsToSelector:NSSelectorFromString(key)]) {
        return [self performSelector:NSSelectorFromString(key)];
    }
    if ([self respondsToSelector:NSSelectorFromString(isKey)]) {
        return [self performSelector:NSSelectorFromString(isKey)];
    }
    if ([self respondsToSelector:NSSelectorFromString(_key)]) {
        return [self performSelector:NSSelectorFromString(_key)];
    }
    
    if ([self respondsToSelector:NSSelectorFromString(countOfKey)]) {
        if ([self respondsToSelector:NSSelectorFromString(objectInKeyAtIndex)]) {
            int mCount = (int)[self performSelector:NSSelectorFromString(countOfKey)];
            NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
            for (int j = 0; j < mCount; j++) {
                id objc = [self performSelector:NSSelectorFromString(objectInKeyAtIndex) withObject:@(j)];
                [mArray addObject:objc];
            }
            return mArray;
        }
    }
#pragma clang diagnostic pop
    
    // 没事实现三个set 方法，判断 accessInstanceVariablesDirectly
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"IFLUndefinedKey Exception"
                                       reason:[NSString stringWithFormat:@"****[%@ forUndefinedKey:%@]: this class is not key-value coding compliant", self, key]
                                     userInfo:nil];
    }
    
    // _<key> _is<Key> <key> is<Key>
    NSString *_isKey = [NSString stringWithFormat:@"_is%@", Key];
    // 检查成员变量 ivars
    NSArray *mArray = [self getIvarsList];
    if ([mArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        return object_getIvar(self, ivar);
    }
    
    if ([mArray containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        return object_getIvar(self, ivar);
    }
    
    if ([mArray containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        return object_getIvar(self, ivar);
    }
    
    if ([mArray containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        return object_getIvar(self, ivar);
    }
    
    @throw [NSException exceptionWithName:@"IFLUndefinedKey Exception"
                                   reason:[NSString stringWithFormat:@"****[%@ forUndefinedKey:%@]: this class is key-value coding compliant, but ivar-%@ can not be founc", self, key, key]
                                 userInfo:nil];
}


- (BOOL)ifl_performSelectorWithMethodName:(NSString *)methodName value:(id)value {
    
    if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(methodName) withObject:value];
#pragma clang diagnostic pop
        return YES;
    }
    return NO;
}

- (id)performSelectorWithMethodName:(NSString *)methodName {
    if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [self performSelector:NSSelectorFromString(methodName)];
#pragma clang diagnostic pop
    }
    return nil;
}

- (NSArray *)getIvarsList {
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        const char *ivar_name = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:ivar_name];
        [mArray addObject:ivarName];
    }
    
    free(ivarList);
    return mArray;
}

@end
