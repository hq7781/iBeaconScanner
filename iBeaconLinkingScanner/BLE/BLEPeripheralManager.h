//
//  BLEPeripheralManager.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/06.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

#if (SURPPORT_BLE)
@protocol BLEPeripheralManagerDelegate <NSObject>

@optional
- (void)DidStartAdvertising:(CBPeripheralManager *_Nullable)peripheral error:(NSError *_Nullable)error;
- (void)PeripheralDidUpdateState:(CBPeripheralManager *_Nullable)peripheral;

@end

@interface BLEPeripheralManager : NSObject

- (BOOL)initPeripheralWithUUID:(NSString *_Nullable)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *_Nonnull)identifier;
- (BOOL)startAdvertising;

@property (nonatomic, weak) id<BLEPeripheralManagerDelegate> delegate;

@end
#endif // (SURPPORT_BLE)
