//
//  HttpPresenter.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import "IFLPresenter.h"
#import "HttpResponseHandle.h"
#import "HttpClient.h"

@interface HttpPresenter<V> : IFLPresenter<V> <HttpResponseHandle>

@property (nonatomic, strong)HttpClient *httpClient;

@end
