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

//// 自动dealloc 方法一 动态特性 swizzle
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self ifl_hookOrigInstanceMenthod:NSSelectorFromString(@"dealloc") newInstanceMenthod:@selector(iflDealloc)];
//    });
//}

+ (BOOL)ifl_hookOrigInstanceMenthod:(SEL)oriSEL newInstanceMenthod:(SEL)swizzledSEL {
    Class cls = self;
    Method oriMethod = class_getInstanceMethod(cls, oriSEL);
    Method swiMethod = class_getInstanceMethod(cls, swizzledSEL);
    
    if (!swiMethod) {
        return NO;
    }
    if (!oriMethod) {
        class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
        method_setImplementation(swiMethod, imp_implementationWithBlock(^(id self, SEL _cmd){ }));
        return YES;
    }
    
    BOOL didAddMethod = class_addMethod(cls, oriSEL, method_getImplementation(swiMethod), method_getTypeEncoding(swiMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swiMethod);
    }
    return YES;
}

- (void)iflDealloc {
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey));
    if (mArray) {
        [mArray removeAllObjects];
        objc_removeAssociatedObjects(self);
    }
    
    // 指回给父类
    Class superClass = [self class];
    object_setClass(self, superClass);
    
    [self iflDealloc];
}

- (void)ifl_addObserver:(nonnull NSObject *)observer
             forKeyPath:(nonnull NSString *)keyPath
                options:(IFLKeyValueObservingOptions)options
                context:(nullable void *)context {
    // 1. 验证是否存在setter方法，
    [self ifl_performSetterSelector:keyPath];
    // 2. 动态生成子类
    Class newClass = [self create_subClass:keyPath];
    // 3. isa指向 : IFLKVONotifying_IFLKVOObject
    object_setClass(self, newClass);
    // 4. 保存观察者
    // 需要注意的是 observer会存在循环引用, 如果需要使用关联对象存储的话，需要一个中间媒介 weak获取
//    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey));
    if (!mArray) {
        mArray = [NSMutableArray arrayWithCapacity:1];
    }
    IFLKVOObserverInfo *observerInfo = [[IFLKVOObserverInfo alloc] initWitObserver:observer keyPath:keyPath options:options];
    [mArray addObject:observerInfo];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)ifl_removeObserver:(nonnull NSObject *)observer
                forKeyPath:(nonnull NSString *)keyPath
                   context:(nullable void *)context {
    
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey));
    if (!mArray) {
        return;
    }
    
    for (IFLKVOObserverInfo *observerInfo in mArray) {
        if ([observerInfo.keyPath isEqualToString:keyPath]) {
            [mArray removeObject:observerInfo];
            if (mArray.count > 0) {
                objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey), mArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            } else {
                objc_removeAssociatedObjects(self);
            }
            break;
        }
    }
    
    if (mArray.count <= 0) {
        // 指回给父类
        Class superClass = [self class];
        object_setClass(self, superClass);
    }
}



- (void)ifl_performSetterSelector:(NSString *)keyPath {
    Class superClass = [self class];
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
    if (!newClass) {
        // objc_allocateClassPair(Class _Nullable superclass, const char * _Nonnull name, size_t extraBytes)
        newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
        // objc_registerClassPair(Class _Nonnull cls)
        objc_registerClassPair(newClass);
        
        SEL classSEL = NSSelectorFromString(@"class");
        Method classMethod = class_getInstanceMethod([self class], classSEL);
        const char *methodType = method_getTypeEncoding(classMethod);
        class_addMethod(newClass, classSEL, (IMP)ifl_class, methodType);
    }
    
    SEL setterSEL = NSSelectorFromString(getSetterKey(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterMethodType = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setterSEL, (IMP)ifl_setter, setterMethodType);
    
//    // 自动dealloc 方法二
//    SEL deallocSEL = NSSelectorFromString(@"dealloc");
//    Method deallocMethod = class_getInstanceMethod([self class], deallocSEL);
//    const char *deallocMethodType = method_getTypeEncoding(deallocMethod);
//    class_addMethod(newClass, deallocSEL, (IMP)ifl_dealloc, deallocMethodType);
    
    
    return newClass;
}

Class ifl_class(id self, SEL _cmd) {
    return class_getSuperclass(object_getClass(self));
}

static void ifl_setter(id self, SEL _cmd, id newValue) {
    NSLog(@"%s --- %@", __func__, newValue);
    
    NSString *keyPath = getKeyPath(NSStringFromSelector(_cmd));
    id oldValue       = [self valueForKey:keyPath];
    
    // 消息转发
    void (*ifl_msgSendSuper)(void *, SEL, id) = (void *)objc_msgSendSuper;
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
//    objc_msgSendSuper(&superStruct, _cmd, newValue)
    ifl_msgSendSuper(&superStruct, _cmd, newValue);
    
//    id observer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey));
//
////observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//    SEL observerSEL = @selector(ifl_observeValueForKeyPath:ofObject:change:context:);
//    if (![observer respondsToSelector:observerSEL]) {
//        return;
//    }
////    objc_msgSend(observer, observerSEL, keyPath, self, @{keyPath:newValue}, NULL);
//    void (*ifl_msgSend)(id, SEL, id, id, id, void *) = (void *)objc_msgSend;
//    ifl_msgSend(observer, observerSEL, keyPath, self, @{keyPath:newValue}, NULL);
    
    NSArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey));
    if (!mArray) {
        return;
    }
    
    for (IFLKVOObserverInfo *observerInfo in mArray) {
        if ([observerInfo.keyPath isEqualToString:keyPath]) {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSMutableDictionary<NSKeyValueChangeKey, id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
                if (observerInfo.options & IFLKeyValueObservingOptionNew) {
                    // 新值处理
                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
                }
                if (observerInfo.options & IFLKeyValueObservingOptionOld) {
                    // 旧值处理
                    [change setObject:@"" forKey:NSKeyValueChangeOldKey];
                    if (oldValue) {
                        [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
                    }
                }
                // 向观察者发送消息
//                SEL observerSEL = @selector(lg_observeValueForKeyPath:ofObject:change:context:);
//                objc_msgSend(info.observer,observerSEL,keyPath,self,change,NULL);
                
                SEL observerSEL = @selector(ifl_observeValueForKeyPath:ofObject:change:context:);
                if ([observerInfo.observer respondsToSelector:observerSEL]) {
                    //    objc_msgSend(observer, observerSEL, keyPath, self, @{keyPath:newValue}, NULL);
                    void (*ifl_msgSend)(id, SEL, id, id, id, void *) = (void *)objc_msgSend;
                    ifl_msgSend(observerInfo.observer, observerSEL, keyPath, self, change, NULL);
                }
                
//            });
        }
    }
}

static void ifl_dealloc(id self, SEL _cmd) {
    NSLog(@" ---- %s ---", __func__);
    
    NSMutableArray *mArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(iflKVOAssociateKey));
    if (mArray) {
        [mArray removeAllObjects];
        objc_removeAssociatedObjects(self);
    }
    
    // 指回给父类
    Class superClass = [self class];
    object_setClass(self, superClass);
    
    // [self performSelector:NSSelectorFromString(@"dealloc")];
    
    //
    void (* ifl_msgSend)(id, SEL) = (void *)objc_msgSend;
    ifl_msgSend(self, _cmd);
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
