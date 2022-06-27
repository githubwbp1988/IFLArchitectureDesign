//
//  NSObject+IFLKVO.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import <Foundation/Foundation.h>
#import "IFLKVOObserverInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (IFLKVO)

- (void)ifl_addObserver:(nonnull NSObject *)observer
             forKeyPath:(nonnull NSString *)keyPath
                options:(IFLKeyValueObservingOptions)options
                context:(nullable void *)context;

- (void)ifl_removeObserver:(nonnull NSObject *)observer
                forKeyPath:(nonnull NSString *)keyPath
                   context:(nullable void *)context;

@end

NS_ASSUME_NONNULL_END
