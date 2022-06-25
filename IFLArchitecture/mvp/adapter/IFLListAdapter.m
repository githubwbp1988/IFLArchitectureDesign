//
//  IFLListAdapter.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLListAdapter.h"
#import "IFLPlusCell.h"
#import "IFLCommMacro.h"
#import "IFLListPresenter.h"

@interface IFLListAdapter ()

@end

@implementation IFLListAdapter

#pragma mark IFLListPresenterProtocol -
- (void)loadDataSuccess:(NSArray *)modelArray {
    [self configData:modelArray];
    
    __weak typeof(self) weakSelf = self;
    self.configCellBlock = ^(IFLPlusCell *cell, IFLCellModel *model, NSIndexPath * _Nonnull indexPath) {
        cell.nameLabel.text = model.name;
        cell.numLabel.text = [NSString stringWithFormat:@"%i", model.num];
        cell.indexPath = indexPath;
        cell.operateBlock = ^int(int opt, NSIndexPath *indexPath) {
            return IFL(weakSelf.presenter, IFLListPresenterProtocol, operate:opt indexPath:indexPath);
        };
    };
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *cellIdentifier = [NSString stringWithFormat:@"tableView:cellFor%@:indexPath:", [IFLCellModel class]];
//    
//    IFLPlusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    
//    if (self.configCellBlock) {
//        self.configCellBlock(cell, [self getModel:indexPath.row], indexPath);
//    }
//    
//    return cell;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForIFLCellModel:(id)model indexPath:(NSIndexPath *)indexPath {
//    NSString *cellIdentifier = NSStringFromSelector(_cmd);
//
//    IFLPlusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//
//    if (self.configCellBlock) {
//        self.configCellBlock(cell, model, indexPath);
//    }
//
//    return cell;
//}

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
