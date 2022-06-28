//
//  IFLList1View.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/27.
//

#import "IFLList1View.h"
#import "IFLPlusCell.h"
#import "IFLBaseAdapter.h"

@interface IFLList1View ()

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation IFLList1View

#pragma mark IFLBasePresenterProtocol -
- (void)createView {
    [super createView];
    NSString *reuseCellId = [NSString stringWithFormat:@"tableView:cellFor%@Dic:", [IFLCellModel class]];
    
    CGRect frame = self.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    [self addSubview:_tableView];
    
    [self.tableView registerClass:[IFLPlusCell class] forCellReuseIdentifier:reuseCellId];
    if (self.adapter) {
        _tableView.dataSource = (IFLBaseAdapter *)self.adapter;
    }
}

- (void)reload {
    [self.tableView reloadData];
}

@end
