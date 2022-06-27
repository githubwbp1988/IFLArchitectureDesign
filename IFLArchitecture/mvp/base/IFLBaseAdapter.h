//
//  IFLBaseAdapter.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLContext.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^ConfigCellBlock)(id cell, id model, NSIndexPath *indexPath);

@interface IFLBaseAdapter : IFLCAdapter <UITableViewDataSource>

@property(nonatomic, copy)ConfigCellBlock configCellBlock;
@property(nonatomic, strong)NSString *refresh;

- (void)configData:(NSArray *)modelArray;
- (id)getModel:(NSInteger)index;
- (NSInteger)dataCount;
- (void)needRefresh;

@end

NS_ASSUME_NONNULL_END
