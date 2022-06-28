//
//  IFLList1Adapter.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/27.
//

#import "IFLList1Adapter.h"
#import "IFLPlusCell.h"
#import "IFLCommMacro.h"
#import "IFLList1Presenter.h"

@implementation IFLList1Adapter

#pragma mark IFLList1PresenterProtocol -
- (void)loadDataSuccess:(NSArray *)modelArray {
    [self configData:modelArray];
    
    __weak typeof(self) weakSelf = self;
    self.configCellBlock = ^(IFLPlusCell *cell, IFLCellModel *model, NSIndexPath * _Nonnull indexPath) {
        cell.nameLabel.text = model.name;
        cell.numLabel.text = [NSString stringWithFormat:@"%i", model.num];
        cell.indexPath = indexPath;
        cell.operateBlock = ^int(int opt, NSIndexPath *indexPath) {
            return IFL(weakSelf.presenter, IFLList1PresenterProtocol, operate:opt indexPath:indexPath);
        };
    };
}

- (void)dataUpdate {
    [self needRefresh];
}

- (void)reRender:(NSNumber *)bustype {
    [self needCustomRefresh:bustype];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForIFLCellModelDic:(NSDictionary *)dic {
    id model = dic[@"cellModel"];
    NSIndexPath *indexPath = dic[@"indexPath"];
    NSString *cellIdentifier = NSStringFromSelector(_cmd);
    
    IFLPlusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (self.configCellBlock) {
        self.configCellBlock(cell, model, indexPath);
    }
    
    return cell;
}

@end
