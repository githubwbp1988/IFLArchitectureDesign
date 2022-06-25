//
//  IFLListPresenter.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLListPresenter.h"
#import "IFLMVPModel.h"
#import "IFLCellModel.h"
#import "YYModel.h"

@interface IFLListPresenter ()

@property(nonatomic, strong)IFLMVPModel *model;

@end

@implementation IFLListPresenter

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark IFLListPresenterProtocol -
- (void)loadData:(NSString *)urlString {
    [self.httpClient get:urlString parameters:nil];
}

- (int)operate:(int)opt indexPath:(NSIndexPath *)indexPath {
    if (opt == 0) { // -
        return --((IFLCellModel *)_model.objlist[indexPath.row]).num;
    }
    if (opt == 1) { // +
        return ++((IFLCellModel *)_model.objlist[indexPath.row]).num;
    }
    return 0;
}

#pragma mark HttpResponseHandle -
- (void)onSuccess:(id)responseObject {
    if (_model) {
        [_model.objlist removeAllObjects];
    }
    _model = [IFLMVPModel yy_modelWithJSON:responseObject];
    _model.objlist = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 0; i < _model.list.count; i++) {
        NSDictionary *dic = _model.list[i];
        IFLCellModel *cellModel = [IFLCellModel yy_modelWithDictionary:dic];
        [_model.objlist addObject:cellModel];
    }
    
    if (self.adapter && [self.adapter respondsToSelector:@selector(loadDataSuccess:)]) {
        [self.adapter performSelector:@selector(loadDataSuccess:) withObject:_model.objlist];
        
        if (self.view && [self.view respondsToSelector:@selector(dataUpdate)]) {
            [self.view performSelector:@selector(dataUpdate)];
        }
    }
}

- (void)onFail:(id)clientInfo errCode:(NSInteger)errCode errInfo:(NSString *)errInfo {
    
}


@end
