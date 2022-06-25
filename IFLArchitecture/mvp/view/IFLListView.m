//
//  IFLListView.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLListView.h"
#import "IFLPlusCell.h"
#import "IFLBaseAdapter.h"

@interface IFLListView ()

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation IFLListView

#pragma mark IFLListPresenterProtocol -
- (void)createView {
    NSString *reuseCellId = [NSString stringWithFormat:@"tableView:cellFor%@Dic:", [IFLCellModel class]];
    
    CGRect frame = self.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    [self addSubview:_tableView];
    
    [self.tableView registerClass:[IFLPlusCell class] forCellReuseIdentifier:reuseCellId];
    if (self.adapter) {
        _tableView.dataSource = (IFLBaseAdapter *)self.adapter;
    }
}

- (void)dataUpdate {
    [_tableView reloadData];
}


@end
