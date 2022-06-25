//
//  IFLBaseViewController.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#import <UIKit/UIKit.h>
#import "NSObject+IFLC.h"

NS_ASSUME_NONNULL_BEGIN

@interface IFLBaseViewController : UIViewController

- (void)configMVP:(NSString *)name configAdapter:(BOOL)configAdapter;

@end

NS_ASSUME_NONNULL_END
