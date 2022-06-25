//
//  HttpPresenter.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import "HttpPresenter.h"

@implementation HttpPresenter
- (instancetype)init {
    if (self = [super init]) {
        _httpClient = [[HttpClient alloc] initWithHandle:self];
    }
    return self;
}

#pragma mark HttpResponseHandle -
- (void)onSuccess:(id)responseObject {
    
}

- (void)onFail:(id)clientInfo errCode:(NSInteger)errCode errInfo:(NSString *)errInfo {

}

@end
