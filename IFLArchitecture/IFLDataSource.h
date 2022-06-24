//
//  IFLDataSource.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ConfigCellBlock)(id cell, id model, NSIndexPath *indexPath);

@interface IFLDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong)NSMutableArray *dataArray;

- (instancetype)initWithCellReuseIdentifier:(NSString *)cellReuseIdentifier withConfigCellBlock:(ConfigCellBlock)configCellBlock;

- (void)configData:(NSArray *)data;


@end

NS_ASSUME_NONNULL_END
