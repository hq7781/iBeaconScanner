//
//  AppDelegate.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "LogUtils.h"
#if (SURPPORT_IBEACON)
#import "iBeaconManager.h"
#endif

#if (SURPPORT_LINKING)
#import "LinkingBeacon.h"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate
#if (SURPPORT_IBEACON)
,iBeaconManagerDelegate
#endif
#if (SURPPORT_LINKING)
,LinkingBeaconDelegate
#endif
>

@property (strong, nonatomic) UIWindow *window;

#if (SURPPORT_IBEACON)
@property (nonatomic) iBeaconManager *ibeaconManager;

- (BOOL)setupIBeaconManager;
#endif


#if (SURPPORT_LINKING)
@property (nonatomic) LinkingBeacon *beaconDevice;
#endif
@property (nonatomic) LogUtils *logger;

- (void)logging:(NSString *)log;

@end

