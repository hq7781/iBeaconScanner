//
//  Constants.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/27.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "Constants.h"

// for iBeacon
NSString *const PROXIMITY_UUID = @"4DEDA6D2-2044-5DF1-500F-E4C3FD7DC71D";

// for linking service uuid
NSString *const SERVICE_UUID_LINKING_128BIT = @"45636901-5DF1-2044-500F-505234DEDA6D";
NSString *const SERVICE_UUID_LINKING_16BIT  = @"FE4E";

NSString *const BEACON_IDENTIFIER = @"com.enixsoft.iBeaconScan";
NSString *const DEVICE_NAME = @"device";
NSString *const DEVOLPER_MAIL_ADDRESS = @"hq7781@gmail.com";
// for logging
NSString *const DEFAULT_LOGFILE = @"ScanLog";
uint const MAX_SIZE_LOGFILE = 100 *1024 * 1024;  // 100 Mbyte
// for User interface
NSString *const UI_STRING_INVALIDUUID = @"有効なUUIDが入力されていません";
NSString *const UI_STRING_AVAILABLE_UUID = @"有効なUUIDが入力してください";
