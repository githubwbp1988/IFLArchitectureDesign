//
//  HttpClient.m
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworking.h"
#import "HttpResponseHandle.h"
#import "Reachability.h"

@interface HttpClient ()

/**
 响应处理器对象
 */
@property (nonatomic, weak)id<HttpResponseHandle> responseHandle;

/**
 网络接通行
 */
@property (nonatomic, strong)Reachability *netReachability;

/**
 网络请求对象
 */
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;

@end

@implementation HttpClient

- (instancetype)initWithHandle:(id<HttpResponseHandle>)responseHandle {
    if (self= [super init]) {
        //指定delegate
        _responseHandle = responseHandle;
        _netReachability = [Reachability reachabilityForInternetConnection];
    }
    return self;
}

- (void)post:(NSString *)URLString parameters:(id)parameters {
    [self.sessionManager POST:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([_responseHandle respondsToSelector:@selector(onSuccess:)]) {
                [_responseHandle onSuccess:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([_responseHandle respondsToSelector:@selector(onFail:errCode:errInfo:)]) {
                [_responseHandle onFail:parameters  errCode:error.code errInfo:error.description];
            }
        }];
}

- (void)get:(NSString *)URLString parameters:(id)parameters{
    
    // 如果网络不可用，不发起网络请求，直接返回错误
    if ([_netReachability currentReachabilityStatus] == NotReachable) {
        if (_responseHandle) {
            //这里的netcode根据服务器自己定义成枚举或者宏定义
            [_responseHandle onFail:parameters errCode:0 errInfo:@"Network is not reachable"];
        }
        return ;
    }
    
    [self.sessionManager GET:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if([_responseHandle respondsToSelector:@selector(onSuccess:)]) {
                [_responseHandle onSuccess:responseObject];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if ([_responseHandle respondsToSelector:@selector(onFail:errCode:errInfo:)]) {
                [_responseHandle onFail:parameters  errCode:error.code errInfo:error.description];
            }
        }];
}

#pragma mark - lazy load
- (AFHTTPSessionManager *)sessionManager {

    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        //设置请求格式，格式为字典 k-v
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/plain", @"text/html", nil];
    }
    return _sessionManager;
}
@end
