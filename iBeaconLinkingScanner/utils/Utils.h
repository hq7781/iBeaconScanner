//
//  Utils.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
// トースト表示
+ (void)ToastWith:(NSString *_Nullable) message;
// デバッグモードかを取得
+ (BOOL)isDebug;
// デバッグ時のみ実行
+ (void)debug:(void (^ _Nullable)(void)) function;

+ (NSString *_Nullable)getFormattedCurrentDate;
+ (NSString *_Nullable)getFormattedDate:(NSDate *_Nullable)date;
+ (NSString *_Nullable)getFormattedCurrentWithMsec;
+ (NSString *_Nullable)getFormattedDateForFilename;
+ (NSString *_Nullable)getFormattedCurrentTime;
//ローカルメッセージ送信
+ (void)sendLocalNotificationForMessage:(NSString *_Nullable)message;

+ (BOOL)isNotNumbericOnly:(NSString*_Nullable) string;
+ (BOOL)isNotAlphaNumericOnly:(NSString*_Nullable) string;
@end
