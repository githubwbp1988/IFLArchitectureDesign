//
//  IFLBaseView.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/28.
//

#import "IFLBaseView.h"
#import "IFLCommMacro.h"

@interface IFLBaseView ()

@end

@implementation IFLBaseView

#pragma mark IFLBasePresenterProtocol -
- (void)createView {
    
}

- (void)subscribe {
    if (self.adapter) {
        [self.adapter ifl_addObserver:self forKeyPath:@"refresh" options:IFLKeyValueObservingOptionNew context:NULL];
        [self.adapter ifl_addObserver:self forKeyPath:@"bustype" options:IFLKeyValueObservingOptionNew context:NULL];
    }
}

- (void)ifl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"refresh"]) {
        if ([self respondsToSelector:@selector(reload)]) {
            [self performSelector:@selector(reload)];
        }
    }
    NSLog(@"chage = %@", change);
    if ([keyPath isEqualToString:@"bustype"]) {
        if ([self respondsToSelector:@selector(processBusType:)]) {
            NSNumber *number = change[NSKeyValueChangeNewKey];
            [self performSelector:@selector(processBusType:) withObject:number];
        }
    }
}

@end
