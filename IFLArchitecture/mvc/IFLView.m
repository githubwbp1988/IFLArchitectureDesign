//
//  IFLView.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/24.
//

#import "IFLView.h"
#import "IFLPlusCell.h"

@implementation IFLView

- (instancetype)initWithFrame:(CGRect)frame
          cellReuseIdentifier:(NSString *)cellReuseIdentifier
              dataSourceBlock:(DataSourceBlock)dataSourceBlock {
    if (self = [super initWithFrame:frame]) {
        self.dataSourceBlock = dataSourceBlock;
        [self configTable:cellReuseIdentifier];
    }
    return self;
}

- (void)reload {
    [self.tableView reloadData];
}

- (void)configTable:(NSString *)cellReuseIdentifier {
    self.tableView =  [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = UIColor.whiteColor;
    [self.tableView registerClass:[IFLPlusCell class] forCellReuseIdentifier:cellReuseIdentifier];
    
    if (self.dataSourceBlock) {
        self.tableView.dataSource = self.dataSourceBlock();
    }
}

@end
