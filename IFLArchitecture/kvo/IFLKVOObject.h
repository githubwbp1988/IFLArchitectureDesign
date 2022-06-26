//
//  IFLKVOObject.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import <Foundation/Foundation.h>
#import "NSObject+IFLKVO.h"

NS_ASSUME_NONNULL_BEGIN

@interface IFLKVOObject : NSObject {
    @public
    NSString *nickName;
}

@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *address;

@property(nonatomic, strong)NSString *progress;
@property(nonatomic, assign)double received;
@property(nonatomic, assign)double total;

@property(nonatomic, strong)NSMutableArray *mArray;

@end

NS_ASSUME_NONNULL_END
