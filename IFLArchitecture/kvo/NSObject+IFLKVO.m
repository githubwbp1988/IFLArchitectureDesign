//
//  NSObject+IFLKVO.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import "NSObject+IFLKVO.h"
#import <objc/message.h>

static NSString *const iflKVOPrefix = @"IFLKVONotifying_";
static NSString *const iflKVOAssociateKey = @"IFLKVO_AssociateKey";

@implementation NSObject (IFLKVO)

- (void)ifl_addObserver:(nonnull NSObject *)observer
             forKeyPath:(nonnull NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(nullable void *)context {
    // 1. 验证是否存在setter方法，
    [self ifl_performSetterSelector:keyPath];
    // 2. 动态生成子类
    Class newClass = [self create_subClass:keyPath];
    // 3. isa指向 : IFLKVONotifying_IFLKVOObject
    object_setClass(self, newClass);
    // 4. 保存观察者
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)removeObserver:(nonnull NSObject *)observer
            forKeyPath:(nonnull NSString *)keyPath
               context:(nullable void *)context {
    
}



- (void)ifl_performSetterSelector:(NSString *)keyPath {
    Class superClass = object_getClass(self);
    SEL setterSelector = [self getSetterSelector:keyPath];
    Method setterMethod = class_getInstanceMethod(superClass, setterSelector);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ does not exist", getSetterKey(keyPath)] userInfo:nil];
    }
}

- (Class)create_subClass:(NSString *)keyPath {
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"%@%@", iflKVOPrefix, oldClassName];
    
    Class newClass = NSClassFromString(newClassName);
    if (newClass) {
        return newClass;
    }
    
    // objc_allocateClassPair(Class _Nullable superclass, const char * _Nonnull name, size_t extraBytes)
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    // objc_registerClassPair(Class _Nonnull cls)
    objc_registerClassPair(newClass);
    
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    const char *methodType = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, classSEL, (IMP)ifl_class, methodType);
    
    SEL setterSEL = NSSelectorFromString(getSetterKey(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterMethodType = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setterSEL, (IMP)ifl_setter, setterMethodType);
    
    
    return newClass;
}

Class ifl_class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

static void ifl_setter(id self, SEL _cmd, id newValue) {
    NSLog(@"%s --- %@", __func__, newValue);
    
    // 消息转发
    void (*ifl_msgSendSuper)(void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
//    objc_msgSendSuper(&superStruct, _cmd, newValue)
    ifl_msgSendSuper(&superStruct, _cmd, newValue);
    
    id observer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey));
    
//observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
    SEL observerSEL = @selector(ifl_observeValueForKeyPath:ofObject:change:context:);
    NSString *keyPath = getKeyPath(NSStringFromSelector(_cmd));
//    objc_msgSend(observer, observerSEL, keyPath, self, @{keyPath:newValue}, NULL);
    void (*ifl_msgSend)(id, SEL, id, id, id, void *) = (void *)objc_msgSend;
    ifl_msgSend(observer, observerSEL, keyPath, self, @{keyPath:newValue}, NULL);
}



- (SEL)getSetterSelector:(NSString *)keyPath {
    NSString *Key = [keyPath capitalizedString];
    NSString *setKey = [NSString stringWithFormat:@"set%@", Key];
    
    NSString *selectorStr = [NSString stringWithFormat:@"%@:", setKey];
    return NSSelectorFromString(selectorStr);
}

static NSString *getSetterKey(NSString *keyPath) {
    NSString *Key = [keyPath capitalizedString];
    
    return [NSString stringWithFormat:@"set%@:", Key];
}

static NSString *getKeyPath(NSString *setter) {
    if (setter.length <= 0) {
        return nil;
    }
    if (![setter hasPrefix:@"set"]) {
        return nil;
    }
    if (![setter hasSuffix:@":"]) {
        return nil;
    }
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *Getter = [setter substringWithRange:range];
    NSString *firstChar = [[Getter substringToIndex:1] lowercaseString];
    return [Getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstChar];
}


@end
