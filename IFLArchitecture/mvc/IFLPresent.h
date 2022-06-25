//
//  IFLPresent.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IFLBasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IFLPresentDelegate <NSObject>

- (void)loadDataSuccess;

@end

@interface IFLPresent : IFLBasePresenter

@property (nonatomic, strong)NSMutableArray *dataArray;

- (instancetype)initWithDelegate:(id<IFLPresentDelegate>)delegate;
- (int)operate:(int)opt indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
