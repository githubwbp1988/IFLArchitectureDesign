//
//  NSObject+IFLKVC.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (IFLKVC)

- (void)ifl_setValue:(nullable id)value forKey:(NSString *)key;
- (nullable id)ifl_valueForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
