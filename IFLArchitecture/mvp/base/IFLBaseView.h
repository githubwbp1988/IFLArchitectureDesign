//
//  IFLBaseView.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/28.
//

#import <UIKit/UIKit.h>
#import "IFLContext.h"
#import "IFLBasePresenter.h"
#import "NSObject+IFLKVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface IFLBaseView : IFLCView <IFLBasePresenterProtocol>

@end

NS_ASSUME_NONNULL_END
