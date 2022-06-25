//
//  IFLPresenter.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IFLPresenter<V> : NSObject {
    // 视图
    __weak V _view;
}

- (void)attach:(V)view;
- (void)detach;


@end

NS_ASSUME_NONNULL_END
