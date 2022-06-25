//
//  NSObject+IFLC.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import <Foundation/Foundation.h>

#import "IFLContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (IFLC)

@property(nonatomic, strong)IFLContext          *context;

@end

NS_ASSUME_NONNULL_END
