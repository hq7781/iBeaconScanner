//
//  Constants.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/27.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

// for iBeacon
#define MAX_LENGTH_UUID1 8
#define MAX_LENGTH_UUID2 4
#define MAX_LENGTH_UUID3 4
#define MAX_LENGTH_UUID4 4
#define MAX_LENGTH_UUID5 12
#define MAX_LENGTH_MAJOR 4
#define MAX_LENGTH_MINOR 6
#define MAX_LENGTH_IDENTIFIER 20
#define MAX_LENGTH_DEVICEID 6

extern NSString *const PROXIMITY_UUID;
// for linking service uuid
extern NSString *const SERVICE_UUID_LINKING_128BIT;
extern NSString *const SERVICE_UUID_LINKING_16BIT;
extern NSString *const BEACON_IDENTIFIER;
extern NSString *const DEVICE_NAME;
extern NSString *const DEVOLPER_MAIL_ADDRESS;
extern NSString *const DEFAULT_LOGFILE;
extern uint const MAX_SIZE_LOGFILE;

extern NSString *const UI_STRING_INVALIDUUID;
extern NSString *const UI_STRING_AVAILABLE_UUID;
