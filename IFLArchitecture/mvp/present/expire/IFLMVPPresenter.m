//
//  IFLMVPPresenter.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLMVPPresenter.h"
#import "IFLCellModel.h"
#import "IFLMVPModel.h"
#import "YYModel.h"

@implementation IFLMVPPresenter

- (void)getData:(NSString *)urlString {
    [self.httpClient get:urlString parameters:nil];
}

#pragma mark HttpResponseHandle -
- (void)onSuccess:(id)responseObject {
    IFLMVPModel *model = [IFLMVPModel yy_modelWithJSON:responseObject];
    model.objlist = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < model.list.count; i++) {
        NSDictionary *dic = model.list[i];
        IFLCellModel *cellModel = [IFLCellModel yy_modelWithDictionary:dic];
        [model.objlist addObject:cellModel];
    }
    if ([_view respondsToSelector:@selector(getDataSuccess:)]) {
        [_view getDataSuccess:model];
    }
}

- (void)onFail:(id)clientInfo errCode:(NSInteger)errCode errInfo:(NSString *)errInfo {
    
}

@end
