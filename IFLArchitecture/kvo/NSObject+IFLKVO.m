//
//  NSObject+IFLKVO.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import "NSObject+IFLKVO.h"

static NSString *const iflKVOPrefix = @"IFLKVONotifying_";
static NSString *const iflKVOAssociateKey = @"IFLKVO_AssociateKey";

@implementation NSObject (IFLKVO)

- (void)ifl_addObserver:(nonnull NSObject *)observer
             forKeyPath:(nonnull NSString *)keyPath
                options:(NSKeyValueObservingOptions)options
                context:(nullable void *)context {
    // 1. 验证是否存在setter方法，
}

- (void)removeObserver:(nonnull NSObject *)observer
            forKeyPath:(nonnull NSString *)keyPath
               context:(nullable void *)context {
    
}

@end
