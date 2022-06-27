//
//  IFLKVOObserverInfo.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, IFLKeyValueObservingOptions) {
    IFLKeyValueObservingOptionNew = 0x01,
    IFLKeyValueObservingOptionOld = 0x02
};

@interface IFLKVOObserverInfo : NSObject

@property(nonatomic, weak)id observer;
@property(nonatomic, copy)NSString *keyPath;
@property(nonatomic, assign)IFLKeyValueObservingOptions options;

- (instancetype)initWitObserver:(id)observer keyPath:(NSString *)keyPath options:(IFLKeyValueObservingOptions)options;


@end

NS_ASSUME_NONNULL_END
