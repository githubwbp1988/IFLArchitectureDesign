//
//  IFLContext.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class IFLContext;
@class IFLCView;
@class IFLCAdapter;


@interface IFLCPresenter : NSObject

@property(nonatomic, weak)UIViewController          *viewController;
@property(nonatomic, weak)IFLCView                  *view;
@property(nonatomic, weak)IFLCAdapter               *adapter;

@end


@interface IFLCInteractor : NSObject

@property(nonatomic, weak)UIViewController          *viewController;

@end

@interface IFLCView : UIView

@property(nonatomic, weak)IFLCPresenter             *presenter;
@property(nonatomic, weak)IFLCInteractor            *interactor;
@property(nonatomic, weak)IFLCAdapter               *adapter;

@end

@interface IFLCAdapter : NSObject

@property(nonatomic, weak)IFLCPresenter             *presenter;

@end


@interface IFLContext : NSObject

@property(nonatomic, strong)IFLCPresenter           *presenter;
@property(nonatomic, strong)IFLCInteractor          *interactor;
@property(nonatomic, strong)IFLCView                *view;
@property(nonatomic, strong)IFLCAdapter             *adapter;

@end

NS_ASSUME_NONNULL_END
