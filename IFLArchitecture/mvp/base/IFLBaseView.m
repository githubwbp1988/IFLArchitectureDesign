//
//  IFLBaseView.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/28.
//

#import "IFLBaseView.h"

@interface IFLBaseView ()

@end

@implementation IFLBaseView

#pragma mark IFLBasePresenterProtocol -
- (void)createView {
    
}

- (void)subscribe {
    if (self.adapter) {
        [self.adapter ifl_addObserver:self forKeyPath:@"refresh" options:IFLKeyValueObservingOptionNew context:NULL];
    }
}

- (void)ifl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"refresh"]) {
        if ([self respondsToSelector:@selector(reload)]) {
            [self performSelector:@selector(reload)];
        }
    }
}

@end
