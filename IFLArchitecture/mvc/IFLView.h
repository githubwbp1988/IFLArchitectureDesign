//
//  IFLView.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef id<UITableViewDataSource> _Nonnull (^DataSourceBlock)(void);

@interface IFLView : UIView

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, copy)DataSourceBlock dataSourceBlock;

- (instancetype)initWithFrame:(CGRect)frame
          cellReuseIdentifier:(NSString *)cellReuseIdentifier
              dataSourceBlock:(DataSourceBlock)dataSourceBlock;


@end

NS_ASSUME_NONNULL_END
