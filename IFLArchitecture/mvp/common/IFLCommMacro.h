//
//  IFLCommMacro.h
//  IFLArchitecture
//
//  Created by erlich wang on 2022/6/25.
//

#ifndef IFLCommMacro_h
#define IFLCommMacro_h

#define IFL(instance, protocol, message) [(id<protocol>)(instance) message]

typedef NS_OPTIONS(NSUInteger, IFLViewSubscribeViewModuleBusType) {
    IFLViewSubscribeViewModuleBusType0 = 1,
    IFLViewSubscribeViewModuleBusType1 = 1 << 1,
    IFLViewSubscribeViewModuleBusType2 = 1 << 2,
    IFLViewSubscribeViewModuleBusType3 = 1 << 3,
    IFLViewSubscribeViewModuleBusType4 = 1 << 4,
    IFLViewSubscribeViewModuleBusType5 = 1 << 5,
    IFLViewSubscribeViewModuleBusType6 = 1 << 6,
    IFLViewSubscribeViewModuleBusType7 = 1 << 7,
    IFLViewSubscribeViewModuleBusType8 = 1 << 8,
    IFLViewSubscribeViewModuleBusType9 = 1 << 9
};


#endif /* IFLCommMacro_h */
