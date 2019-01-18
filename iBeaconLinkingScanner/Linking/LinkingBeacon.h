//
//  LinkingBeacon.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Const.h"
#if (SURPPORT_LINKING)
#import <LinkingLibrary/LinkingLibrary.h>
#endif

@protocol LinkingBeaconDelegate <NSObject>

@optional
-(void)startLinkingBeaconPartialScan;
-(void)startLinkingBeaconPartialScanTimeOut;
-(void)connectLinkingBeaconBluetoothWhenPartialScanError:(NSError *)error;
-(void)connectLinkingBeaconBluetoothWhenStartPartialScanError:(NSError *)error;
-(void)receivedLinKingBeaconAdvertisement:(CBPeripheral*)peripheral advertisement:(NSDictionary*)data;
@end

@interface LinkingBeacon : NSObject
- (void)initLinkingBeacon;
- (BOOL)isScanning;
- (void)scanStartLinkingBeacon;
- (void)scanStopLinkingBeacon;

@property (nonatomic, weak) id<LinkingBeaconDelegate> delegate;


@end
