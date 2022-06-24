//
//  IFLPlusCell.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import <UIKit/UIKit.h>
#import "IFLCellModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef int (^CellOperateBlock)(int opt, NSIndexPath *indexPath);

@interface IFLPlusCell : UITableViewCell

@property(nonatomic, strong)UIButton *minusBtn;
@property(nonatomic, strong)UIButton *plusBtn;
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *numLabel;

@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, copy)CellOperateBlock operateBlock;

@end

NS_ASSUME_NONNULL_END
