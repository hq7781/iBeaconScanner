//
//  DefaultsUtils.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/31.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultsUtils : NSObject

+ (void)setIBeaconUUID:(NSString *)uuid;
+ (NSString *)getIBeaconUUID;

+ (void)setIBeaconMajor:(int)major;
+ (int)getIBeaconMajor;

+ (void)setIBeaconMinor:(int)minor;
+ (int)getIBeaconMinor;

+ (void)setIBeaconIdentifier:(NSString *)identifier;
+ (NSString *)getIBeaconIdentifier;

+ (void)setLinkingDeviceId:(NSString *)deviceId;
+ (NSString *)getLinkingDeviceId;
//+ (void)setBeaconMode:(int) mode;
//+ (int)getBeaconMode;
+ (void)setFlagLogging:(BOOL)flag;
+ (BOOL)getFlagLogging;
@end
