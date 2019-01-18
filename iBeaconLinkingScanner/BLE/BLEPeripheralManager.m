//
//  BLEPeripheralManager.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/06.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "BLEPeripheralManager.h"
#import "Constants.h"
#import "Const.h"

#if (SURPPORT_BLE)
@interface BLEPeripheralManager () <CBPeripheralManagerDelegate>
@property (strong, nonatomic) IBOutlet CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) IBOutlet NSUUID *proximityUUID;
@property (nonatomic) CLBeaconMajorValue major;
@property (nonatomic) CLBeaconMinorValue minor;
@property (strong, nonatomic) IBOutlet NSString *identifier;
@end

@implementation BLEPeripheralManager

- (BOOL)initPeripheralWithUUID:(NSString *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier {
    self.proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    self.major = major;
    self.minor = minor;
    self.identifier = identifier;
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    if (self.peripheralManager.state == CBPeripheralManagerStatePoweredOn) {
        [self startAdvertising];
    }
    return YES;
}

- (BOOL)startAdvertising {
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:self.proximityUUID
                                                                           major:self.major
                                                                           minor:self.minor
                                                                      identifier:self.identifier];
    NSDictionary *beaconPeripheralData = [beaconRegion peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    return YES;
}

// iBeacon通信が開始したとき
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(DidStartAdvertising:error:)]) {
        [self.delegate DidStartAdvertising:peripheral error:error];
    }
    if (error) {
        //  [self :[NSString stringWithFormat:@"%@", error]];
        NSLog(@"DidStartAdvertising peripheral state: %ld error:%@", (long)peripheral.state, error.debugDescription);
    } else {
        //  [self :@"Start Advertising"];
        NSLog(@"DidStartAdvertising peripheral state: %ld", (long)peripheral.state);
    }
}

// iBeacon通信が更新したとき
- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral {
    NSLog(@"Updated peripheral state: %ld", (long)peripheral.state);
    if ([self.delegate respondsToSelector:@selector(PeripheralDidUpdateState:)]) {
        [self.delegate PeripheralDidUpdateState:peripheral];
    }
    NSString *message;
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOff:
            message = @"PoweredOff";
            break;
        case CBPeripheralManagerStatePoweredOn:
            message = @"PoweredOn";
            [self startAdvertising];
            break;
        case CBPeripheralManagerStateResetting:
            message = @"Resetting";
            break;
        case CBPeripheralManagerStateUnauthorized:
            message = @"Unauthorized";
            break;
        case CBPeripheralManagerStateUnknown:
            message = @"Unknown";
            break;
        case CBPeripheralManagerStateUnsupported:
            message = @"Unsupported";
            break;
            
        default:
            break;
    }
    //[self sendLocalNotificationForMessage:[@"PeripheralManager did update state: " stringByAppendingString:message]];
}
@end
#endif //(SURPPORT_BLE)
