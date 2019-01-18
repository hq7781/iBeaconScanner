//
//  Utils.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "Utils.h"
#import <UIKit/UIKit.h>

@implementation Utils
// トースト表示
+ (void)ToastWith:(NSString*) message{
    if (!Utils.isDebug) return;

    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.message = message;
    //[alert addButtonWithTitle:@"確認"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    });
    [alert show];
}

// デバッグモードかを取得
+ (BOOL)isDebug {
#if DEBUG
    return YES;
#else
    return NO;
#endif
}

// デバッグ時のみ実行
+ (void)debug:(void (^ __nullable)(void))function {
#if DEBUG
    if (!function) return;
    function();
#else
#endif
}

#pragma mark - gen current date String
+ (NSDateFormatter *)getDateFormatterWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ja_JP"];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"JST"];
    [formatter setDateFormat:format];
    return formatter;
}
//現在の時間文字列取得
+ (NSString *)getFormattedCurrentDate {
    NSDateFormatter *formatter = [Utils getDateFormatterWithFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSString*) getFormattedDate:(NSDate *)date {
    NSDateFormatter* formatter = [Utils getDateFormatterWithFormat:@"yyyy/MM/dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}
+ (NSString *)getFormattedCurrentWithMsec {
    NSDateFormatter *formatter = [Utils getDateFormatterWithFormat:@"yyyy/MM/dd HH:mm:ss.SSS"];
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSString *)getFormattedDateForFilename {
    NSDateFormatter *formatter = [Utils getDateFormatterWithFormat:@"yyyyMMddHHmmss"];
    return [formatter stringFromDate:[NSDate date]];
}
+ (NSString *)getFormattedCurrentTime {
    NSDateFormatter *formatter = [Utils getDateFormatterWithFormat:@"HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark - Send Local Notification
//ローカルメッセージ送信
+ (void)sendLocalNotificationForMessage:(NSString *)message {
    UILocalNotification *localNotification = [UILocalNotification new];
    localNotification.alertBody = message;
    localNotification.fireDate = [NSDate date];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

+ (BOOL)isNotNumbericOnly:(NSString*) string {
    // Number only
    NSCharacterSet *numberSet = [NSCharacterSet decimalDigitCharacterSet];
    BOOL isNotNumbericOnly = ![[string stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
    if (isNotNumbericOnly) {
        NSLog(@"isNotNumbericOnly: %@",(isNotNumbericOnly? @"Yes":@"No"));
        return YES;
    }
    return NO;
}
+ (BOOL)isNotAlphaNumericOnly:(NSString*) string {
    // ASCII & Number only
    NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet *numberSet = [NSCharacterSet decimalDigitCharacterSet];
    BOOL isNotAlphaNumericOnly = ![[string stringByTrimmingCharactersInSet:alphanumericSet] isEqualToString:@""]
    && ![[string stringByTrimmingCharactersInSet:numberSet] isEqualToString:@""];
    if (isNotAlphaNumericOnly) {
        NSLog(@"isAplhaNumericOnly: %@",(isNotAlphaNumericOnly? @"Yes":@"No"));
        return YES;
    }
    return NO;
}
@end
