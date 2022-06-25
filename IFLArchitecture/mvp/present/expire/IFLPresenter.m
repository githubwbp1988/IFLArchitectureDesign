//
//  IFLPresenter.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLPresenter.h"

@implementation IFLPresenter

- (void)attach:(id)view {
    _view = view;
}

- (void)detach {
    _view = nil;
}

@end
