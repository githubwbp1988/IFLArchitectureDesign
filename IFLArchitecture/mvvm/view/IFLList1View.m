//
//  IFLList1View.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/27.
//

#import "IFLList1View.h"
#import "IFLPlusCell.h"
#import "IFLBaseAdapter.h"
#import "NSObject+IFLKVO.h"

@interface IFLList1View ()

@property(nonatomic, strong)UITableView *tableView;

@end

@implementation IFLList1View

- (void)createView {
    NSString *reuseCellId = [NSString stringWithFormat:@"tableView:cellFor%@Dic:", [IFLCellModel class]];
    
    CGRect frame = self.bounds;
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    [self addSubview:_tableView];
    
    [self.tableView registerClass:[IFLPlusCell class] forCellReuseIdentifier:reuseCellId];
    if (self.adapter) {
        _tableView.dataSource = (IFLBaseAdapter *)self.adapter;
        
        [self.adapter ifl_addObserver:self forKeyPath:@"refresh" options:IFLKeyValueObservingOptionNew context:NULL];
    }
}

- (void)ifl_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey, id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"refresh"]) {
        [self reload];
    }
}

- (void)reload {
    [self.tableView reloadData];
}

@end
