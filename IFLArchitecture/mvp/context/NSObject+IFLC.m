//
//  NSObject+IFLC.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "NSObject+IFLC.h"
#import <objc/runtime.h>

@implementation NSObject (IFLC)


- (void)setContext:(IFLContext *)object {
    objc_setAssociatedObject(self, @selector(context), object, OBJC_ASSOCIATION_ASSIGN);
}

- (IFLContext *)context {
    id curContext = objc_getAssociatedObject(self, @selector(context));
    // view获取context 当前view 未获取到context，需要追溯父类
    if (!curContext && [self isKindOfClass:[UIView class]]) {
        
        // try get from superview, lazy get
        UIView *view = (UIView *)self;
        
        UIView *sprView = view.superview;
        while (sprView != nil) {
            if (sprView.context != nil) {
                curContext = sprView.context;
                break;
            }
            sprView = sprView.superview;
        }
        
        if (curContext != nil) {
            [self setContext:curContext];
        }
    }
    
    return curContext;
}

@end
