//
//  IFLBasePresenter.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLContext.h"
#import "HttpResponseHandle.h"
#import "HttpClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface IFLBasePresenter : IFLCPresenter <HttpResponseHandle>

@property (nonatomic, strong)HttpClient *httpClient;

@end

NS_ASSUME_NONNULL_END
