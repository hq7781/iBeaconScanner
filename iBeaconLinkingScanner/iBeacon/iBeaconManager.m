//
//  iBeaconManager.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/30.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "iBeaconManager.h"
#import "Utils.h"
#import "Constants.h"
#import <UIKit/UIKit.h>

#if (SURPPORT_IBEACON)
@interface iBeaconManager () <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    NSUUID *proximityUUID;
    CLBeaconRegion *beaconRegion;
    CLBeacon *nearestBeacon;
    BOOL isMonitoring;
    BOOL canMonitoringHeading;

}
@property (nonatomic, weak) NSTimer *rangingTimer;
@end

@implementation iBeaconManager

- (BOOL)initIbeaconWithUUID:(NSString *)uuid identifier:(NSString *)identifier{
    return [self initIbeaconWithUUID:uuid major:0 minor:0 identifier:identifier];
}
/*
 *  initWithProximityUUID:major:identifier:
 */
- (BOOL)initIbeaconWithUUID:(NSString *)uuid major:(CLBeaconMajorValue)major identifier:(NSString *)identifier{
    return [self initIbeaconWithUUID:uuid major:major minor:0 identifier:identifier];
}
/*
 *  initWithProximityUUID:major:minor:identifier:
 */
- (BOOL)initIbeaconWithUUID:(NSString *)uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier{
    if ([uuid length] == 0) {
        return NO;
    }
    proximityUUID = [[NSUUID alloc] initWithUUIDString:uuid];
    if (proximityUUID == nil) {
        return NO;
    }
    isMonitoring = NO;
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; //最高精度
        locationManager.activityType = CLActivityTypeFitness; //ユーザが歩行移動のときに最適
        locationManager.pausesLocationUpdatesAutomatically = NO;//位置情報が自動的にOFFになる設定
        locationManager.allowsBackgroundLocationUpdates = YES;
        locationManager.distanceFilter = 10.0;//設定距離以上移動した場合に位置情報を取得
        //locationManager.distanceFilter = kCLDistanceFilterNone;//変更があるとすべて位置情報を通知
        // ヘディングの更新を開始する
        if ([CLLocationManager headingAvailable]) {
            locationManager.headingFilter = 1;
            canMonitoringHeading = YES;
        } else {
            canMonitoringHeading = NO;
        }
        
        if (major > 0 && minor > 0) {
            beaconRegion = [[CLBeaconRegion alloc]
                            initWithProximityUUID: proximityUUID major: major minor: minor identifier: identifier];
        } else if (major > 0) {
            beaconRegion = [[CLBeaconRegion alloc]
                            initWithProximityUUID: proximityUUID major: major identifier: identifier];
        } else {
            beaconRegion = [[CLBeaconRegion alloc]
                            initWithProximityUUID: proximityUUID identifier: identifier];
        }
        beaconRegion.notifyEntryStateOnDisplay = NO;
        beaconRegion.notifyOnEntry = YES;
        beaconRegion.notifyOnExit = YES;
        
        //if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            // requestAlwaysAuthorizationメソッドが利用できる場合(iOS8以上の場合)
            // 位置情報の取得許可を求めるメソッド
            //[locationManager requestWhenInUseAuthorization]; // support to iOS 11 ???
            [locationManager requestAlwaysAuthorization]; // background mode
        } else {
            NSLog(@"requestAlwaysAuthorizationメソッドが利用できない");
            // requestAlwaysAuthorizationメソッドが利用できない場合(iOS8未満の場合)
            //[locationManager startMonitoringForRegion: beaconRegion];
        }
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isMonitoring {
    return isMonitoring;
}

#pragma mark - <CLLocationManagerDelegate> methods
// 領域計測が開始した場合
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"didStartMonitoringForRegion() 領域計測開始通知");
    isMonitoring = YES;
//    if ([self.delegate respondsToSelector:@selector(didStartIBeaconRegion:)]) {
//        [self.delegate didStartIBeaconRegion:region];
//    }
    // 2017/12/06 new added!!!
    //[locationManager requestStateForRegion:region];
}

// 指定した領域に入った場合
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"didEnterRegion() 指定領域に進入通知");
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
    
//    if ([self.delegate respondsToSelector:@selector(didEnterIBeaconRegion:)]) {
//        [self.delegate didEnterIBeaconRegion:region];
//    }
}

// 指定した領域から出た場合
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"didExitRegion() 指定領域から退出通知");
    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
        [locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
//    if ([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]) {
//        [locationManager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
//    }
 
//    if ([self.delegate respondsToSelector:@selector(didExitIBeaconRegion:)]) {
//        [self.delegate didExitIBeaconRegion:region];
//    }
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    NSLog(@"didDetermineState() iBeacon状態の通知 state:%ld",(long)state);
    IBeaconRegionState iBeaconState = IBeaconRegionStateUnknown;
    switch (state) {
        case CLRegionStateInside:
            if([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]){
                iBeaconState = IBeaconRegionStateInside;
            }
            break;
        case CLRegionStateOutside:
            if([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]){
                iBeaconState = IBeaconRegionStateOutside;
            }
            break; // 2017/12/06 fixed
        case CLRegionStateUnknown:
            //iBeaconState = IBeaconRegionStateUnknown; // 2017/12/06 fixed
            if([region isMemberOfClass:[CLBeaconRegion class]] && [CLLocationManager isRangingAvailable]){
                iBeaconState = IBeaconRegionStateUnknown;
            }
            break;
        default:
            break;
    }
//    if ([self.delegate respondsToSelector:@selector(didDetermineState:forRegion:)]) {
//        [self.delegate didDetermineState:iBeaconState forRegion:region];
//    }
}

// Beacon信号を検出した場合
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSLog(@"didRangeBeacons() Beacon信号を検出通知 count:%lu", (unsigned long)beacons.count);
//    if ([self.delegate respondsToSelector:@selector(didRangeBeacons:inRegion:)]) {
//        [self.delegate didRangeBeacons:beacons inRegion:region];
//    }
}

// 領域観測に失敗した場合
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"monitoringDidFailForRegion() Beacon領域観測に失敗通知");
//    if ([self.delegate respondsToSelector:@selector(monitoringDidFailForRegion:withError:)]) {
//        [self.delegate monitoringDidFailForRegion:region withError:error];
//    }
}

// 位置情報更新時
// not iBeacon
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSString *message = [NSString stringWithFormat:@"didUpdate latitude=%f, longitude=%f, accuracy=%f, time=%@",
                         [newLocation coordinate].latitude, [newLocation coordinate].longitude,
                         newLocation.horizontalAccuracy, newLocation.timestamp];
    NSLog(@"didUpdateToLocation() Beacon位置情報更新通知 %@", message);
}

// 変更された位置情報を取得 startUpdatingLocationが呼ばれたら
// not iBeacon
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    for (CLLocation *location in locations) {
        NSLog(@"didUpdateLocations() 位置情報変更通知 latitude=%f, longitude=%f, accuracy=%f, time=%@",  [location coordinate].latitude, [location coordinate].longitude, location.horizontalAccuracy, location.timestamp);
    }
}
// not iBeacon
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"DidPauseLocationUpdates() 位置情報更新DidPause");
}
// not iBeacon
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    NSLog(@"DidResumeLocationUpdates() 位置情報更新DidResume");
}
// not iBeacon
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(nullable NSError *)error {
    NSLog(@"didFinishDeferredUpdatesWithError() error:%@",error.debugDescription);
}
// not iBeacon 現在地のどのぐらい滞在しているか
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    NSLog(@"didVisit() visit:latitude:%f latitude:%f, accuracy:%f [%@-%@]",
          visit.coordinate.latitude, visit.coordinate.longitude, visit.horizontalAccuracy, visit.arrivalDate,visit.departureDate);
}
// not iBeacon
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    NSLog(@"didUpdateHeading() 方位情報 x:%f,y:%f,z:%f",newHeading.x,newHeading.y,newHeading.z);
}
// not iBeacon
- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
   NSLog(@"ShouldDisplayHeadingCalibration() NO");
    return NO;
}

// ユーザが位置情報の使用を許可変更時
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusNotDetermined) {
        // ユーザが位置情報の使用を許可していない
    } else if(status == kCLAuthorizationStatusAuthorizedAlways) {
        // ユーザが位置情報の使用を常に許可している場合
        [locationManager startMonitoringForRegion: beaconRegion];
        [locationManager startRangingBeaconsInRegion:beaconRegion];
//        [self startTimerRangingBeaconsInRegion];
//        [self startRangingBeaconsInRegionTimer];
//        [locationManager startUpdatingLocation];
//        if (canMonitoringHeading) [locationManager startUpdatingHeading];
//        [locationManager startMonitoringVisits];
    } else if(status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        // ユーザが位置情報の使用を使用中のみ許可している場合
        [locationManager startMonitoringForRegion: beaconRegion];
        [locationManager startRangingBeaconsInRegion:beaconRegion];
//         [self startTimerRangingBeaconsInRegion];
//        [self startRangingBeaconsInRegionTimer];
//        [locationManager startUpdatingLocation];
//        if (canMonitoringHeading) [locationManager startUpdatingHeading];
//        [locationManager startMonitoringVisits];
    }
    NSLog(@"didChangeAuthorizationStatus() status: %d", status);
}

#define TOFLOATSECONDS(x) (float)(x)/(float)1000
- (void)startTimerRangingBeaconsInRegion {
    NSInteger RangingInterval = 5000;
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    NSLog(@"StartTimerRangingBeaconsInRegion() Start");
    [self performSelector:@selector(startTimerRangingBeaconsInRegion) withObject:nil afterDelay: TOFLOATSECONDS(RangingInterval)];
}

- (void)startRangingBeaconsInRegionTimer {
    NSInteger RangingInterval = 5000;
    if (self.rangingTimer) {
        [self.rangingTimer invalidate];
    }
    self.rangingTimer = [NSTimer scheduledTimerWithTimeInterval:TOFLOATSECONDS(RangingInterval) target:self selector:@selector(RangingBeaconsTimerFired:) userInfo:nil repeats:YES];
}
- (void)stopRangingBeaconsInRegionTimer {
    if (self.rangingTimer && [self.rangingTimer isValid]) {
        [self.rangingTimer invalidate];
    }
    self.rangingTimer = nil;
}

- (void)RangingBeaconsTimerFired:(NSTimer *)timer {
    NSLog(@"RangingBeaconsTimerFired() Fired");
    //[locationManager startMonitoringForRegion: beaconRegion];
    [locationManager startRangingBeaconsInRegion:beaconRegion];
}
@end

#endif // (SURPPORT_IBEACON)
