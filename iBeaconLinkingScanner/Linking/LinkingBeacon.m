//
//  LinkingBeacon.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "LinkingBeacon.h"
#import "Utils.h"
#import "Constants.h"

#if (SURPPORT_LINKING)
@interface LinkingBeacon () <BLEConnecterDelegate, BLEDelegateModelDelegate>{
    // BLEConnecter *bleConnecter;
    BOOL isScanning;
}
@property (strong,nonatomic)BLEConnecter *bleConnecter;

//@property (nonatomic) BOOL isStartPartialScanDevice;
@end

@implementation LinkingBeacon


#pragma mark - Linking methods Public methods
- (void)initLinkingBeacon {
    // BLEConnecterクラスのインスタンス生成
//    bleConnecter = [BLEConnecter sharedInstance];
    self.bleConnecter = [BLEConnecter sharedInstance];
    // デリゲートの登録 ※ペリフェラルを指定したい場合はdeviceUUIDを指定
//    [bleConnecter addListener:self deviceUUID:nil];
    [self.bleConnecter addListener:self deviceUUID:nil];
}
- (BOOL)isScanning {
    return isScanning;
}
- (void)scanStartLinkingBeacon {
    if (!isScanning) {
        [self.bleConnecter startPartialScanDevice];
        NSLog(@"%@: %s ■ビーコンのスキャンを開始しました。",[Utils getFormattedCurrentDate],__FUNCTION__);
    }
}
- (void)scanStopLinkingBeacon {
    isScanning = NO;
    // デバイス検索を停止する
    [self.bleConnecter stopPartialScanDevice];
    NSLog(@"%@: %s ■ビーコンのスキャンを停止しました。",[Utils getFormattedCurrentDate],__FUNCTION__);
}

#pragma mark - Linking methods Private methods

- (BOOL)filterDevice:(CBPeripheral*)peripheral withName:(NSString*) DeviceName {
    if ([DeviceName isEqualToString:peripheral.name]) {
        return YES;
    }
    return NO;
}
//- (BOOL)filterDevice:(CBPeripheral*)peripheral withId:(NSString*) DeviceId {
//    if ([DeviceId isEqualToString:peripheral]) {
//        return YES;
//    }
//    return NO;
//}

#pragma mark - <BLEDelegateModelDelegate> methods Beacon Linking
// ビーコンスキャン開始通知
- (void)startPartialScanDelegate {
    isScanning = YES;
    NSLog(@"ビーコンスキャン開始通知");

    if ([self.delegate respondsToSelector:@selector(startLinkingBeaconPartialScan)]) {
        [self.delegate startLinkingBeaconPartialScan];
    }
}

// ビーコンスキャンのタイムアウトの通知
- (void)partialScanTimeOutDelegate {
    NSLog(@"%s() ビーコンスキャンのタイムアウト",__FUNCTION__);

    if ([self.delegate respondsToSelector:@selector(startLinkingBeaconPartialScanTimeOut)]) {
        [self.delegate startLinkingBeaconPartialScanTimeOut];
    }
}

// ビーコンスキャンのBluetooth接続エラー通知
- (void)connectBluetoothWhenPartialScanError:(NSError *)error {
    NSLog(@"%s() ビーコンスキャンのBluetooth接続エラー通知",__FUNCTION__);
    
    if ([self.delegate respondsToSelector:@selector(connectLinkingBeaconBluetoothWhenPartialScanError:)]) {
        [self.delegate connectLinkingBeaconBluetoothWhenPartialScanError:error];
    }
}

// ビーコンスキャン開始時のBluetooth接続エラー通知
- (void)connectBluetoothWhenStartPartialScanError:(NSError *)error{
    NSLog(@"%s() ビーコンスキャン開始時のBluetooth接続エラー通知",__FUNCTION__);
    
    if ([self.delegate respondsToSelector:@selector(connectLinkingBeaconBluetoothWhenStartPartialScanError:)]) {
        [self.delegate connectLinkingBeaconBluetoothWhenStartPartialScanError:error];
    }
}

// アドバタイズ受信通知
- (void)receivedAdvertisement:(CBPeripheral*)peripheral advertisement:(NSDictionary*)data {
    NSLog(@"%@: %s ■ビーコンのスキャン受信されました。",[Utils getFormattedCurrentDate],__FUNCTION__);
    NSLog(@"%@: %@ %s",peripheral.name, peripheral.identifier,__FUNCTION__);
    if ([self.delegate respondsToSelector:@selector(receivedLinKingBeaconAdvertisement: advertisement:)]) {
        [self.delegate receivedLinKingBeaconAdvertisement:peripheral advertisement:data];
    }
    
//    if (![self filterDevice: peripheral withName: DEVICE_NAME])
//        return;
}

@end

#endif //(SURPPORT_LINKING)

