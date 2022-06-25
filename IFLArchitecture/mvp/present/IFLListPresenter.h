//
//  IFLListPresenter.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import "IFLBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IFLListPresenterProtocol <NSObject>

@optional
// presenter
- (void)loadData:(NSString *)urlString;
- (void)dataUpdate;
- (int)operate:(int)opt indexPath:(NSIndexPath *)indexPath;

// adapter 回调
- (void)loadDataSuccess:(NSArray *)modelArray;

// view
- (void)createView;

@end

@interface IFLListPresenter : IFLBasePresenter <IFLListPresenterProtocol>


@end

NS_ASSUME_NONNULL_END
