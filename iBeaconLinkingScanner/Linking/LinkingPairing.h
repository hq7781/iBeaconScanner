//
//  LinkingPairing.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#if (SURPPORT_LINKING)
#import <LinkingLibrary/LinkingLibrary.h>
#endif

@protocol LinkingPairingDelegate <NSObject>

@optional

@end

@interface LinkingPairing : NSObject

@end
