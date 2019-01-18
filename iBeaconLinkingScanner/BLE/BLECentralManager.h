//
//  BLECentralManager.h
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
@protocol BLECentralManagerDelegate <NSObject>

@optional
- (void)CentralDidUpdateState:(CBCentralManager *_Nullable)central;
- (void)didDiscoverPeripheral:(CBPeripheral *_Nullable)peripheral
            advertisementData:(NSDictionary *_Nullable)advertisementData
                         RSSI:(NSNumber *_Nullable)RSSI;

@end
@interface BLECentralManager : NSObject

//- (id)initCentral:(UIViewController *)controller WithUUID:(NSString *)uuid;

@property (nonatomic, weak) id<BLECentralManagerDelegate> delegate;
@end
#endif // (SURPPORT_BLE)
