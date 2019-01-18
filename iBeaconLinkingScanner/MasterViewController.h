//
//  MasterViewController.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#if (SURPPORT_BLE)
#import "BLECentralManager.h"
#import "BLEPeripheralManager.h"
#endif
#import <CoreBluetooth/CoreBluetooth.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController
#if (SURPPORT_BLE)
<
BLECentralManagerDelegate
,BLEPeripheralManagerDelegate
>
#endif


@property (strong, nonatomic) DetailViewController *detailViewController;

- (void)insertNewEvent:(NSString*) logEvent;

#if (SURPPORT_BLE)
//@property (nonatomic) BLECentralManager    *bleCentralManager;
@property (nonatomic) CBCentralManager *bleCentralManager;
@property (nonatomic) BLEPeripheralManager *blePeripheralManager;

- (BOOL)setupBLECentralManager;
- (BOOL)setupBLEPeripheralManager;
#endif

@end

