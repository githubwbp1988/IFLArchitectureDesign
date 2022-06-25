//
//  HttpResponseHandle.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import <Foundation/Foundation.h>

@protocol HttpResponseHandle <NSObject>

@required


- (void)onSuccess:(id)responseObject;

- (void)onFail:(id)clientInfo
        errCode:(NSInteger)errCode
       errInfo:(NSString *)errInfo;
@end
