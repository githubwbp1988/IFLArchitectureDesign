//
//  IFLMVPPresenter.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "HttpPresenter.h"
#import "IFLViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface IFLMVPPresenter : HttpPresenter <id<IFLViewProtocol>>

- (void)getData:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
