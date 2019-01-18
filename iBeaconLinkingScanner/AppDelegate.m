//
//  AppDelegate.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"

#import "Utils.h"
#import "DefaultsUtils.h"
#import "Constants.h"

@interface AppDelegate () <UISplitViewControllerDelegate>
@property (nonatomic)  BOOL enableLocalNotification;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;

    self.enableLocalNotification = NO;
#if (SURPPORT_IBEACON)
    //add iBeacon
//    if (0 == [DefaultsUtils getBeaconMode]) {
        if(NO == [self setupIBeaconManager]) {
        //iBeaconが利用できないOS, Deviceの場合
        NSString *message = UI_STRING_INVALIDUUID;
        NSLog(@"%@", message);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"確認"
                                                                                 message:message
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {NSLog(@"Clicked");}];
        [alertController addAction:action];
        
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        [navigationController.topViewController presentViewController:alertController
                                                             animated:YES
                                                           completion:^{NSLog(@"YES");}];
        }
//    }
#endif

#if (SURPPORT_LINKING)
    self.beaconDevice = (LinkingBeacon *)[LinkingBeacon new];
    self.beaconDevice.delegate = self;
    [self.beaconDevice initLinkingBeacon];

#endif
    [DefaultsUtils setFlagLogging: YES];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//#if (SURPPORT_LINKING)
//        if (![self.beaconDevice isScanning]) {
//            [self.beaconDevice scanStartLinkingBeacon];
//        }
//#endif
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self sendIBeaconLog:@"applicationDidEnterBackground"];
    NSLog(@"applicationDidEnterBackground");
    self.enableLocalNotification = YES;

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self sendIBeaconLog:@"applicationWillEnterForeground"];
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //
    [self sendIBeaconLog:@"applicationDidBecomeActive"];
    self.enableLocalNotification = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self sendIBeaconLog:@"applicationWillTerminate"];
    NSLog(@"applicationWillTerminate");
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        
        return YES; // HONG
        
        // New TabBarUI
        if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]]) {
            DetailViewController *detailViewController = (DetailViewController *)[(UINavigationController *)secondaryViewController topViewController];
            
            if ([detailViewController detailItem] == nil) return NO;
            
            if ([primaryViewController isKindOfClass:[UITabBarController class]]) {
                for (UIViewController *viewController in [(UITabBarController *)primaryViewController viewControllers]) {
                    if ([viewController isKindOfClass:[UINavigationController class]]) {
                        if ([[(UINavigationController *)viewController topViewController] isKindOfClass:[MasterViewController class]]) {
                            detailViewController.hidesBottomBarWhenPushed = YES;
                            
                            [(UINavigationController *)viewController pushViewController:detailViewController animated:NO];
                            return YES;
                        }
                    }
                }
            }
        }
    // End New TabBarUI
    }
    return NO;
}

// New TabBarUI
- (nullable UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController{

    return nil; // not show Detail View HONG
    
    UITabBarController *tabBarController = splitViewController.viewControllers.firstObject;
    UINavigationController *selectedNavigationViewController = (UINavigationController *)tabBarController.selectedViewController;
    
    if ([[selectedNavigationViewController topViewController] isKindOfClass:[DetailViewController class]]) {
        UIViewController *detailsViewController = [selectedNavigationViewController popViewControllerAnimated:NO];
        UINavigationController *detailsNavigationViewController = [[UINavigationController alloc] initWithRootViewController:detailsViewController];
        return detailsNavigationViewController;
    }
    return nil;
}
// End New TabBarUI
- (BOOL)splitViewController:(UISplitViewController *)splitViewController
   showDetailViewController:(UIViewController *)vc
                     sender:(id)sender {
    NSLog(@"UISplitViewController collapsed: %d", splitViewController.collapsed);
    return YES; // not need detail view?? HONG
    
    // TODO: add introspection
    if (splitViewController.collapsed) {
        // New TabBar UI
        UITabBarController *tabBarController = (UITabBarController *)splitViewController.viewControllers.firstObject;
        UINavigationController *selectedNavigationViewController = (UINavigationController *)tabBarController.selectedViewController;
        
        // push detail view on the navigation controller
        UIViewController *viewControllerToPush = vc;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController = (UINavigationController *)vc;
            viewControllerToPush = navController.topViewController;
        }
        viewControllerToPush.hidesBottomBarWhenPushed = YES;
        [selectedNavigationViewController pushViewController:viewControllerToPush animated:YES];
        // End New TabBar UI
        return YES;
    }
    return NO;
}
#if (SURPPORT_IBEACON)
- (BOOL)setupIBeaconManager {
    // Create new logging file
    self.logger = (LogUtils *)[ [LogUtils alloc] init];
    
    NSString* uuid = [DefaultsUtils getIBeaconUUID];
    int major = [DefaultsUtils getIBeaconMajor];
    int minor = [DefaultsUtils getIBeaconMinor];
    NSString* identifier = [DefaultsUtils getIBeaconIdentifier];
#if (USE_TEST_UUID) // for debug
    uuid = PROXIMITY_UUID;
    major = 1;
    minor = 0;
 #else
    if (!uuid) {
        uuid = PROXIMITY_UUID;
    }
#endif
    if (!identifier) {
        identifier = BEACON_IDENTIFIER;
    }
    
    self.ibeaconManager = (iBeaconManager *)[iBeaconManager new];
    self.ibeaconManager.delegate = self;
#if (USE_TEST_UUID) // for debug
    return [self.ibeaconManager initIbeaconWithUUID:uuid identifier:(NSString *)identifier];
#else
    if (major > 0 && minor > 0) {
        return [self.ibeaconManager initIbeaconWithUUID:uuid major:(CLBeaconMajorValue)major minor:(CLBeaconMinorValue)minor identifier:(NSString *)identifier];
    } else if (major > 0) {
        return [self.ibeaconManager initIbeaconWithUUID:uuid major:(CLBeaconMajorValue)major identifier:(NSString *)identifier];
    } else {
        return [self.ibeaconManager initIbeaconWithUUID:uuid identifier:(NSString *)identifier];
    }
#endif
    
    return NO;
}
#endif

- (void)logging:(NSString *)log {
    if(![DefaultsUtils getFlagLogging]) {
        NSLog(@"file logging is disabled!");
        return;
    }
    if (!self.logger) {
        self.logger = (LogUtils *)[ [LogUtils alloc] init];
    }
    [self.logger append:log];
}

- (void)sendIBeaconLog:(NSString *)message {
    if (!message) return;

    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UITabBarController* tabBarController = [splitViewController.viewControllers lastObject];
    // is iBeacon Logging View
    UINavigationController *navigationController = [tabBarController.viewControllers firstObject];
    if ([navigationController.topViewController isKindOfClass:[MasterViewController class]]) {
        NSString *log = [NSString stringWithFormat: @"[%@]: %@",[Utils getFormattedCurrentTime],message];
        [(MasterViewController*)navigationController.topViewController insertNewEvent:log];
    } else {
        NSLog(@"%s, %@",__FUNCTION__, navigationController.topViewController.description);
    }
    [self logging:message];
}
- (void)sendIBeaconLog_2:(NSString *)message {
    if (!message) return;
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UITabBarController* tabBarController = [splitViewController.viewControllers lastObject];
    // is iBeacon Logging View
    UINavigationController *navigationController = [tabBarController.viewControllers firstObject];
    if ([navigationController.topViewController isKindOfClass:[MasterViewController class]]) {
        NSString *log = [NSString stringWithFormat: @"%@",message];
        [(MasterViewController*)navigationController.topViewController insertNewEvent:log];
    } else {
        NSLog(@"%s, %@",__FUNCTION__, navigationController.topViewController.description);
    }
}

- (NSString *)getIBeaconInfo:(CLBeaconRegion *)region with:(NSDictionary *)data {
    return @"";
}
- (void)sendLinkingLog:(NSString *)message {
    if (!message) return;
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UITabBarController* tabBarController = [splitViewController.viewControllers lastObject];
    // is Linking Logging View
    UINavigationController *navigationController = [tabBarController.viewControllers objectAtIndex:1];
    if ([navigationController.topViewController isKindOfClass:[MasterViewController class]]) {
        NSString *log = [NSString stringWithFormat: @"[%@]: %@",[Utils getFormattedCurrentTime],message];
        [(MasterViewController*)navigationController.topViewController insertNewEvent:log];
    } else {
        NSLog(@"%s, %@",__FUNCTION__, navigationController.topViewController.description);
    }
    [self logging:message];
}

- (NSString *)getLinkingDeviceInfo:(CBPeripheral *)peripheral with:(NSDictionary *) data {
    NSDate *date = [data objectForKey:@"date"];
    long headerIdentifier = [[data objectForKey:@"headerIdentifier"]longValue];
    long individualNumber = [[data objectForKey:@"individualNumber"]longValue];
    long serviceID = [[data objectForKey:@"serviceID"]longValue];
    float distanceInformation = [[data objectForKey:@"distanceInformation"]floatValue];
    long version = [[data objectForKey:@"version"]longValue];
    NSNumber *rssi = [data objectForKey:@"rssi"];
    float txPowerLevel = [[data objectForKey:@"txPowerLevel"]floatValue];
    long serviceData = [[data objectForKey:@"serviceData"]longValue];
    float temperature = [[data objectForKey:@"temperature"]floatValue];
    float humidity = [[data objectForKey:@"humidity"]floatValue];
    float atmosphericPressure = [[data objectForKey:@"atmosphericPressure"]floatValue];
    BOOL isChargingRequired = [[data objectForKey:@"isChargingRequired"]boolValue];
    float remainingPercentage = [[data objectForKey:@"remainingPercentage"]floatValue];
    short buttonIdentifier = [[data objectForKey:@"buttonIdentifier"]shortValue];
    BOOL isOpen = [[data objectForKey:@"isOpen"]boolValue];
    BOOL isHuman = [[data objectForKey:@"isHuman"]boolValue];
    BOOL isVibration = [[data objectForKey:@"isVibration"]boolValue];
    
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSLog(@"device : %@", peripheral.name);
    NSLog(@"date : %@", date);
    NSLog(@"headerIdentifier : %ld", headerIdentifier);
    NSLog(@"individualNumber : %ld", individualNumber);
    NSLog(@"serviceID : %ld", serviceID);
    NSLog(@"distanceInformation : %f", distanceInformation);
    NSLog(@"version : %ld", version);
    NSLog(@"RSSI : %@", rssi);
    NSLog(@"txPowerLevel : %f", txPowerLevel);
    NSLog(@"serviceData : %ld", serviceData);
    NSLog(@"temperature : %f", temperature);
    NSLog(@"humidity : %f", humidity);
    NSLog(@"atmosphericPressure : %f", atmosphericPressure);
    NSLog(@"isChargingRequired : %@", isChargingRequired ? @"YES" : @"NO");
    NSLog(@"remainingPercentage : %f", remainingPercentage);
    NSLog(@"buttonIdentifier : %hi", buttonIdentifier);
    NSLog(@"isOpen : %@", isOpen ? @"YES" : @"NO");
    NSLog(@"isHuman : %@", isHuman ? @"YES" : @"NO");
    NSLog(@"isVibration : %@", isVibration ? @"YES" : @"NO");
    NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
    NSString *message = [NSString stringWithFormat:
                         @"Name: %@\n       Vender Id: [%ld] Device Id: [%ld] RSSI: [%@]", peripheral.name, headerIdentifier,individualNumber, rssi];
    return message;
};

#if (SURPPORT_IBEACON)
#pragma mark - <iBeaconManagerDelegate> methods
- (void)didStartIBeaconRegion:(CLRegion *)region {
    NSString *message = [NSString stringWithFormat:@"Start Monitoring"];
    [self sendIBeaconLog:message];
}
- (void)didEnterIBeaconRegion:(CLRegion *)region {
    NSString *message = [NSString stringWithFormat:@"EnterRegion: %@", region.identifier];
    [self sendIBeaconLog:message];
}
- (void)didExitIBeaconRegion:(CLRegion *)region {
    NSString *message = [NSString stringWithFormat:@"ExitRegion: %@", region.identifier];
    [self sendIBeaconLog:message];
}
- (void)didDetermineState:(IBeaconRegionState)state forRegion:(CLRegion *)region {
    NSString *message = nil;
    switch (state) {
        case IBeaconRegionStateInside://iBeacon の範囲内に入った時に行う処理を記述する
            message = [NSString stringWithFormat: @"Inside: %@", region.identifier];
            break;
        case IBeaconRegionStateOutside:
            message = [NSString stringWithFormat: @"Outside: %@", region.identifier];
            break;
        case IBeaconRegionStateUnknown:
            message = [NSString stringWithFormat: @"UnknownState: %@", region.identifier];
            break;
        default:
            break;
    }
    if (message) {
        [self sendIBeaconLog:message];
    }
}
- (void)didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
#if (SURPPORT_LINKING)
//    if (![self.beaconDevice isScanning]) {
//        [self.beaconDevice scanStartLinkingBeacon];
//    }
#endif
    if (0 == beacons.count) {
           [self logging:@"haven't any beacons in Region"];
        NSLog(@"%s, %@",__FUNCTION__, @"beacons.count == 0");
        return;
    }
    CLBeacon *nearestBeacon = beacons.firstObject;
    NSString *rangeMessage;
    
    switch (nearestBeacon.proximity) {
        case CLProximityImmediate:
            rangeMessage = @"Imme";
            break;
        case CLProximityNear:
            rangeMessage = @"Near";
            break;
        case CLProximityFar:
            rangeMessage = @"Far ";
            break;
        default:
            rangeMessage = @"Unk ";
            break;
    }
    NSString *message = [NSString stringWithFormat:
                         @"uuid: %@\n[%@]: %@ %f[m] major: %@ minor: %@",
                         nearestBeacon.proximityUUID.UUIDString, [Utils getFormattedCurrentTime], rangeMessage,
                         nearestBeacon.accuracy, nearestBeacon.major, nearestBeacon.minor];
    [self logging:message];
    [self sendIBeaconLog_2:message];
    NSLog(@"iBeacon信号: %@",message);
    if (self.enableLocalNotification) {
        [Utils sendLocalNotificationForMessage:message];
    }
//#if (SURPPORT_LINKING)
//    if (![self.beaconDevice isScanning]) {
//        [self.beaconDevice scanStartLinkingBeacon];
//    }
//#endif
}

- (void)monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSString *message = [NSString stringWithFormat: @"Monitoring Failed error: %@", error.debugDescription];
    [self sendIBeaconLog:message];
}
- (void)didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSString *message = [NSString stringWithFormat:@"Location Authorization Status has been changed!"];
    [self sendIBeaconLog:message];
}
#endif //(SURPPORT_IBEACON)

#if (SURPPORT_LINKING)
#pragma mark - <LinkingBeaconDelegate> methods
- (void)startLinkingBeaconPartialScan {
    NSLog(@"%s, %@",__FUNCTION__, @"Start Linking Partial Scan");
    [self sendLinkingLog:@"Start Linking Partial Scan"];
}
- (void)startLinkingBeaconPartialScanTimeOut {
    NSLog(@"%s, %@",__FUNCTION__, @"Linking Partial Scan TimeOut");
    [self sendLinkingLog:@"Linking Partial Scan TimeOut"];
}
- (void)connectLinkingBeaconBluetoothWhenPartialScanError:(NSError *)error {
    NSString *message = [NSString stringWithFormat:@"ScanError: %@", error.debugDescription];
    NSLog(@"%s, %@",__FUNCTION__,message);
    [self sendLinkingLog:message];
}
- (void)connectLinkingBeaconBluetoothWhenStartPartialScanError:(NSError *)error {
    NSString *message = [NSString stringWithFormat:@"Start ScanError: %@", error.debugDescription];
    NSLog(@"%s, %@",__FUNCTION__,message);
    [self sendLinkingLog:message];
}
- (void)receivedLinKingBeaconAdvertisement:(CBPeripheral*)peripheral advertisement:(NSDictionary*)data{
    NSString *debugMessage = [NSString stringWithFormat: @"received LinKing Advertisement %@", data];
    NSLog(@"%@",debugMessage);
    long device = [[data objectForKey:@"individualNumber"]longValue];
    long targetDevice = [[DefaultsUtils getLinkingDeviceId] longLongValue];
   if ((0 != targetDevice) && (device != targetDevice)) { return;} // not logging
    
    NSString *message = [NSString stringWithFormat:@"%@",
                             [self getLinkingDeviceInfo:peripheral with:data]];
    [self sendLinkingLog:message];
}
#endif

@end
