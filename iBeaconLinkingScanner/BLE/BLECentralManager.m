//
//  BLECentralManager.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/06.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "BLECentralManager.h"

#if (SURPPORT_BLE)
@interface BLECentralManager () <CBCentralManagerDelegate>
@property (strong, nonatomic) IBOutlet CBCentralManager *centralManager;
@property (strong, nonatomic) IBOutlet NSUUID *proximityUUID;
@property (strong, nonatomic) IBOutlet CBPeripheral * peripheral;
@property (nonatomic) NSMutableArray *peripherals;

@end
NSMutableArray * a_peripheral;

@implementation BLECentralManager
//- (id)initCentral:(UIViewController *)controller WithUUID:(NSString *)uuid {
//    self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
//    //self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
//    self.centralManager = [[CBCentralManager alloc] initWithDelegate:controller queue:nil options:nil];
//    if (self.centralManager) {
//    self.peripherals = [NSMutableArray array];
//    a_peripheral = [NSMutableArray array];
//        return self.centralManager;
//    }
//    return nil;
//}
// centralManager 状態変換された場合
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    NSLog(@"Updated central state: %ld", (long)central.state);
    if ([self.delegate respondsToSelector:@selector(CentralDidUpdateState:)]) {
        [self.delegate CentralDidUpdateState:central];
    }
    
    switch (central.state) {
        case CBCentralManagerStatePoweredOn: // is Open
        {   // スキャン開始
            NSArray *services = @[self.proximityUUID];
            [self.centralManager scanForPeripheralsWithServices:services
                                                        options:nil];
            break;
        }
        case CBCentralManagerStatePoweredOff: // OFF
            break;
        case CBCentralManagerStateResetting:
            break;
        case CBCentralManagerStateUnsupported:
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        default:
            break;
    }
}

//Peripheral Discovered ペリフェラル発見
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    NSLog(@"peripheral:%@, advertisementData:%@, RSSI:%@",
          peripheral, advertisementData, RSSI);
    if ([self.delegate respondsToSelector:@selector(didDiscoverPeripheral:advertisementData:RSSI:)]) {
        [self.delegate didDiscoverPeripheral:peripheral advertisementData:advertisementData RSSI:RSSI];
    }
    
    if (![self.peripherals containsObject:peripheral]) {
        NSLog(@"peripheral.identifier : %@", peripheral.identifier);
        
        [self.peripherals addObject:peripheral.identifier];
        NSString *source = [NSString stringWithFormat:@"%@", peripheral.identifier];
        
        NSString *pattern = @"(^<.*> )";
        NSString *replacement = @"";
        
        NSRegularExpression *regexp = [NSRegularExpression
                                       regularExpressionWithPattern:pattern
                                       options:NSRegularExpressionCaseInsensitive
                                       error:nil];
        NSString *str = [regexp
                         stringByReplacingMatchesInString:source
                         options:NSMatchingReportProgress
                         range:NSMakeRange(0, source.length)
                         withTemplate:replacement];
        NSLog(@"UUID%@", str);
        [a_peripheral addObject:str];
        
        NSLog(@"self.peripherals -> %@", self.peripherals);
        NSLog(@"a_peripheral -> %@", a_peripheral);
        NSLog(@"self.peripherals count : %lu", (unsigned long)[self.peripherals count]);
        NSLog(@"a_peripheral count : %lu", (unsigned long)[a_peripheral count]);
    }
    // スキャン停止
    //[self.centralManager stopScan];
    // 接続開始
    //[central connectPeripheral:peripheral options:nil];
}

@end
#endif // (SURPPORT_BLE)
