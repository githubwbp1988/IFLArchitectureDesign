//
//  IFLKVOObserverInfo.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/27.
//

#import "IFLKVOObserverInfo.h"

@implementation IFLKVOObserverInfo

- (instancetype)initWitObserver:(id)observer keyPath:(NSString *)keyPath options:(IFLKeyValueObservingOptions)options {
    if (self = [super init]) {
        self.observer = observer;
        self.keyPath  = keyPath;
        self.options  = options;
    }
    return self;
}

@end
