//
//  DefaultsUtils.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/31.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "DefaultsUtils.h"

#define KEY_UUID @"defualt_uuid"
#define KEY_MAJOR @"defualt_major"
#define KEY_MINOR @"defualt_minor"
#define KEY_IDENTIFIER @"defualt_identifier"
#define KEY_DEVICEID @"defualt_deviceid"
#define KEY_BEACONMODE @"defualt_beaconmode"
#define KEY_LOGGING @"defualt_logging"

@implementation DefaultsUtils

+ (void)setIBeaconUUID:(NSString *)uuid {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:uuid forKey:KEY_UUID];
    [defaults synchronize];
}
+ (NSString *)getIBeaconUUID {
    NSString *uuid = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:KEY_UUID] isKindOfClass:[NSString class]]){
        uuid = [defaults objectForKey:KEY_UUID];
    } else {
        uuid = [[defaults objectForKey:KEY_UUID] stringValue];
    }
    return uuid;
}

+ (void)setIBeaconMajor:(int)major {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [[NSNumber alloc] initWithInt:major] forKey:KEY_MAJOR];
    [defaults synchronize];
}
+ (int)getIBeaconMajor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int major = [[defaults objectForKey:KEY_MAJOR] intValue];
    return major;
}

+ (void)setIBeaconMinor:(int)minor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: [[NSNumber alloc] initWithInt:minor] forKey:KEY_MINOR];
    [defaults synchronize];
}
+ (int)getIBeaconMinor {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int minor = [[defaults objectForKey:KEY_MINOR] intValue];
    return minor;
}

+ (void)setIBeaconIdentifier:(NSString *)identifier {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:identifier forKey:KEY_IDENTIFIER];
    [defaults synchronize];
}
+ (NSString *)getIBeaconIdentifier {
    NSString *identifier = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:KEY_IDENTIFIER] isKindOfClass:[NSString class]]){
        identifier = [defaults objectForKey:KEY_IDENTIFIER];
    } else {
        identifier = [[defaults objectForKey:KEY_IDENTIFIER] stringValue];
    }
    return identifier;
}

+ (void)setLinkingDeviceId:(NSString *)deviceId {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceId forKey:KEY_DEVICEID];
    [defaults synchronize];
}
+ (NSString *)getLinkingDeviceId {
    NSString *deviceId = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:KEY_DEVICEID] isKindOfClass:[NSString class]]){
        deviceId = [defaults objectForKey:KEY_DEVICEID];
    } else {
        deviceId = [[defaults objectForKey:KEY_DEVICEID] stringValue];
    }
    return deviceId;
}
//+ (void)setBeaconMode:(int) mode {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject: [[NSNumber alloc] initWithInt:mode] forKey:KEY_BEACONMODE];
//    
//    [defaults synchronize];
//}
//+ (int)getBeaconMode{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    int mode = [[defaults objectForKey:KEY_BEACONMODE] intValue];
//    return mode;
//}

+ (void)setFlagLogging:(BOOL)flag {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: (flag)? @YES:@NO forKey:KEY_LOGGING];
    [defaults synchronize];
}
+ (BOOL)getFlagLogging {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL flag = [[defaults objectForKey:KEY_LOGGING] boolValue];
    return flag;
}

@end
