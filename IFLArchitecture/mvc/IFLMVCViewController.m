//
//  IFLMVCViewController.m
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import "IFLMVCViewController.h"
#import "IFLPlusCell.h"
#import "IFLPresent.h"
#import "IFLDataSource.h"
#import "IFLView.h"

static NSString *const cellReuseIdentifier = @"cellReuseIdentifier_IFLPlusCell";

@interface IFLMVCViewController () <IFLPresentDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)IFLPresent *present;
@property (nonatomic, strong)IFLView *m_view;

@property (nonatomic, strong)IFLDataSource *datasource;

@end

@implementation IFLMVCViewController

// MVC模式
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.present = [[IFLPresent alloc] initWithDelegate:self];
    __weak typeof(self) weakSelf = self;
    self.datasource = [[IFLDataSource alloc] initWithCellReuseIdentifier:cellReuseIdentifier withConfigCellBlock:^(IFLPlusCell *cell,
                                                                                                                   IFLCellModel *model, NSIndexPath * _Nonnull indexPath) {
        cell.nameLabel.text = model.name;
        cell.numLabel.text = [NSString stringWithFormat:@"%i", model.num];
        cell.indexPath = indexPath;
        cell.operateBlock = ^int(int opt, NSIndexPath *indexPath) {
            return [weakSelf.present operate:opt indexPath:indexPath];
        };
    }];
    
    self.view = self.m_view;
}

- (UIView *)m_view {
    if (!_m_view) {
        __weak typeof(self) weakSelf = self;
        _m_view = [[IFLView alloc] initWithFrame:self.view.bounds cellReuseIdentifier:cellReuseIdentifier dataSourceBlock:^id<UITableViewDataSource> _Nonnull {
            return weakSelf.datasource;
        }];
    }
    return _m_view;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadDataSuccess {
    [self.datasource configData:self.present.dataArray];
    [self.m_view reload];
}

- (void)dealloc {
    NSLog(@" --- %s ---- ", __func__);
}

@end
