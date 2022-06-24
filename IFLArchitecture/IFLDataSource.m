//
//  IFLDataSource.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/24.
//

#import "IFLDataSource.h"
#import <UIKit/UIKit.h>

@interface IFLDataSource () 

@property(nonatomic, strong)NSString * cellReuseIdentifier;
@property(nonatomic, copy)ConfigCellBlock configCellBlock;

@end

@implementation IFLDataSource

- (instancetype)initWithCellReuseIdentifier:(NSString *)cellReuseIdentifier withConfigCellBlock:(ConfigCellBlock)configCellBlock {
    if (self = [super init]) {
        self.cellReuseIdentifier = cellReuseIdentifier;
        self.configCellBlock = configCellBlock;
    }
    return self;
}

- (void)configData:(NSArray *)data {
    if (!data) {
        return;
    }
    if ([self.dataArray count] > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:data];
}


#pragma mark UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
    id model = self.dataArray[indexPath.row];
    self.configCellBlock(cell, model, indexPath);
    return cell;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:5];
    }
    return _dataArray;
    
}

@end
