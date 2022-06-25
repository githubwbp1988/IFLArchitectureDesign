//
//  IFLViewProtocol.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#ifndef IFLViewProtocol_h
#define IFLViewProtocol_h

#import "IFLMVPModel.h"

@protocol IFLViewProtocol <NSObject>

- (void)getDataSuccess:(IFLMVPModel *)model;

@end


#endif /* IFLViewProtocol_h */
