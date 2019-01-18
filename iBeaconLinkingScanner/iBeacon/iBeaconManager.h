//
//  iBeaconManager.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/30.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Const.h"
#import <CoreLocation/CoreLocation.h>
#if (SURPPORT_IBEACON)

typedef NS_ENUM(NSInteger, IBeaconRegionState) {
    IBeaconRegionStateUnknown = -1,
    IBeaconRegionStateInside = 0,
    IBeaconRegionStateOutside = 1
};

@protocol iBeaconManagerDelegate <NSObject>

@optional
- (void)didStartIBeaconRegion:(CLRegion *)region;
- (void)didEnterIBeaconRegion:(CLRegion *)region;
- (void)didExitIBeaconRegion:(CLRegion *)region;
- (void)didDetermineState:(IBeaconRegionState)state forRegion:(CLRegion *)region;
- (void)didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;
- (void)monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error;
- (void)didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
@end

@interface iBeaconManager : NSObject

- (BOOL)initIbeaconWithUUID:(NSString *)uuid identifier:(NSString *)identifier;
- (BOOL)initIbeaconWithUUID:(NSString *)uuid major:(CLBeaconMajorValue)major identifier:(NSString *)identifier;
- (BOOL)initIbeaconWithUUID:(NSString *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier;

- (BOOL)isMonitoring;
//- (void)monitoringStartIBeaconLocate;
//- (void)monitoringStopIBeaconLocate;

@property (nonatomic, weak) id<iBeaconManagerDelegate> delegate;

@end
#endif //(SURPPORT_IBEACON)
