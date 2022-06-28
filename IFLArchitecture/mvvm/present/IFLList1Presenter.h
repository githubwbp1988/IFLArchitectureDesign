//
//  IFLList1Presenter.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/27.
//

#import <Foundation/Foundation.h>
#import "IFLBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IFLList1PresenterProtocol <IFLBasePresenterProtocol>

@optional
// presenter
- (void)loadData:(NSString *)urlString;
- (void)dataUpdate;
- (int)operate:(int)opt indexPath:(NSIndexPath *)indexPath;

// adapter 回调
- (void)loadDataSuccess:(NSArray *)modelArray;

@end


@interface IFLList1Presenter : IFLBasePresenter <IFLList1PresenterProtocol>


@end


NS_ASSUME_NONNULL_END
