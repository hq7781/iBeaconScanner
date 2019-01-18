//
//  LogUtils.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/01.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogUtils : NSObject
- (instancetype)init;
- (void)append:(NSString *)log;
- (NSURL *)getFilePath;

+ (NSString*) getFormattedDateFor: (NSDate*) date;
+ (NSString*) getFormattedStringForSize: (unsigned long long) fileSize;
+ (NSString *)getFolderSizeForPath:(NSString *)folderPath;

@end
