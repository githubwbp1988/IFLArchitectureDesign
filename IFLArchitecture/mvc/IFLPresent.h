//
//  IFLPresent.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IFLPresent : NSObject

@property (nonatomic, strong)NSMutableArray *dataArray;

- (int)operate:(int)opt indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
