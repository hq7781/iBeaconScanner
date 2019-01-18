//
//  MasterViewController.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Utils.h"
#import "DefaultsUtils.h"
#import "Constants.h"
//#import "AppDelegate.h"


#define UITAB_IBEACON 1
#define UITAB_LINKING 2

@interface MasterViewController () <CBCentralManagerDelegate> {
}
@property (retain,nonatomic) UIBarButtonItem *actionButton;
@property NSMutableArray *objects;
@property int tabTag;
@property (retain,nonatomic) UITabBarItem *tabBarItem;
@property BOOL isLogging;

#if (SURPPORT_BLE)
@property (strong, nonatomic) NSUUID *proximityUUID;
@property (strong, nonatomic) CBPeripheral * peripheral;
@property (nonatomic) NSMutableArray *peripherals;
#endif
@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // self.navigationItem.leftBarButtonItem = self.editButtonItem; not need
    self.isLogging = YES;
    self.actionButton = [[UIBarButtonItem alloc] initWithTitle:@"Pause"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(didChangeLoggingState:)];
    self.navigationItem.rightBarButtonItem = self.actionButton;

    UITabBarController *tabBarController = [self.splitViewController.viewControllers firstObject];
    UINavigationController *selectedNavigationViewController = (UINavigationController *)tabBarController.selectedViewController;

    self.tabTag = (int)tabBarController.tabBar.selectedItem.tag;
    //self.tabBarItem = [tabBarController.tabBar.items objectAtIndex:self.tabTag];
    self.tabBarItem = tabBarController.tabBar.selectedItem;

    // not show detail view HONG
   // self.detailViewController = (DetailViewController *)[selectedNavigationViewController topViewController];
#if (SURPPORT_BLE)
    [self setupBLECentralManager];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    if (1 == self.tabTag) {
        [Utils ToastWith:@"Entering iBeacon Logging"];
    } else if (2 == self.tabTag) {
        [Utils ToastWith:@"Entering Linking Logging"];
    }
#if (SURPPORT_BLE)
    if (!self.bleCentralManager) {
        [self setupBLECentralManager];
    }
//    AppDelegate *application = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    if (1 == [DefaultsUtils getBeaconMode]) {
//        application.ibeaconManager = nil;
//        self.blePeripheralManager = nil;
//        if(NO == [self setupBLECentralManager]) {
//            NSLog(@"setupBLECentralManager error");
//        }
//    }
//    if (2 == [DefaultsUtils getBeaconMode]) {
//        application.ibeaconManager = nil;
//        self.bleCentralManager = nil;
//        if (NO == [self setupBLEPeripheralManager]) {
//            NSLog(@"setupBLEPeripheralManager error");
//        }
//    }
#endif
}
- (void)viewDidDisappear:(BOOL)animated{
#if (SURPPORT_BLE)
    if (self.bleCentralManager) {
//        [bleCentralManager stopScan];
//        self.bleCentralManager = nil;
    }
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didChangeLoggingState:(id)sender {
    if (self.isLogging){
        self.isLogging = NO;
        _actionButton.title = @"Resume";
    } else {
        self.isLogging = YES;
        _actionButton.title = @"Pause";
    }
}

////// Add Event Log
- (void)insertNewEvent:(NSString *)logEvent {
    if (self.isLogging) {
        if (!self.objects) {
            self.objects = [[NSMutableArray alloc] init];
        }
        [self.objects insertObject:logEvent atIndex:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    return ; // not show detail view HONG
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object.description];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.tabTag == UITAB_IBEACON) {
        NSString *object = self.objects[indexPath.row];
        cell.textLabel.text = [NSString stringWithString: object];
    }
    else if (self.tabTag == UITAB_LINKING) {
        NSString *object = self.objects[indexPath.row];
        cell.textLabel.text = [NSString stringWithString: object];
    }
    else {
        NSDate *object = self.objects[indexPath.row];
        cell.textLabel.text = [object description];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#if (SURPPORT_BLE)
- (BOOL)setupBLECentralManager {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:CBCentralManagerOptionRestoreIdentifierKey,
                          CBCentralManagerOptionShowPowerAlertKey, nil];
    
    self.bleCentralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_queue_create("scanner.BLEQueue",NULL) options:dict];

    self.bleCentralManager.delegate = self;
    if (self.bleCentralManager) {
        return YES;
    } else {
        return NO;
    }
}
- (BOOL)setupBLEPeripheralManager {
    
    NSString* uuid = [DefaultsUtils getIBeaconUUID];
    int major = [DefaultsUtils getIBeaconMajor];
    int minor = [DefaultsUtils getIBeaconMinor];
    NSString* identifier = [DefaultsUtils getIBeaconIdentifier];
    self.blePeripheralManager = (BLEPeripheralManager *)[BLEPeripheralManager new];
    [self.blePeripheralManager initPeripheralWithUUID:uuid major:major minor:minor identifier:identifier];
    
    self.blePeripheralManager.delegate = self;
    return YES;
}
#pragma mark - <CBCentralManagerDelegate> methods
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    NSLog(@"TEST Updated central state: %ld", (long)central.state);
    NSString *state = nil;
    switch (central.state) {
        case CBCentralManagerStatePoweredOn: // is Open
        {
//            if (BLE_SCAN_UUID) {
//                NSArray *services = @[self.proximityUUID];
//                NSLog(@"BLE uuid:[%@] scan starting ...",services);
//                [self.bleCentralManager scanForPeripheralsWithServices:services options:nil];
//            } else if (BLE_SCAN_LINKING) {
//                CBUUID *serviceUUID_128Bit = [CBUUID UUIDWithString: SERVICE_UUID_LINKING_128BIT];
//                CBUUID *serviceUUID_16Bit = [CBUUID UUIDWithString: SERVICE_UUID_LINKING_16BIT];
//                NSArray *services = @[serviceUUID_128Bit,serviceUUID_16Bit];
//                NSLog(@"BLE Linking scan starting ...");
//                [self.bleCentralManager scanForPeripheralsWithServices:services options:nil];
//            } else {
//                NSLog(@"BLE All scan starting ...");
//                [self.bleCentralManager scanForPeripheralsWithServices:nil options:nil];
//            }
            [self StartTimerBLECentralScanPeripherals];
            state = @"PoweredOn ScanStart";
            break;
        }
        case CBCentralManagerStatePoweredOff: // OFF
            state = @"PoweredOff";
            break;
        case CBCentralManagerStateResetting:
            state = @"Resetting";
            break;
        case CBCentralManagerStateUnsupported:
            state = @"Unsupported";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"Unauthorized";
            break;
        case CBCentralManagerStateUnknown:
            state = @"Unknown";
            break;
        default:
            break;
    }
    NSString *message = [NSString stringWithFormat:@"CentralDidUpdateState: %@", state];
    //[self sendIBeaconLog:message];
   //////////////crash!  [self insertNewEvent:message];
}
//Peripheral Discovered ペリフェラル発見
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    NSLog(@"peripheral:%@, advertisementData:%@, RSSI:%@",
          peripheral, advertisementData, RSSI);

    if (![self.peripherals containsObject:peripheral]) {
        NSLog(@"peripheral.identifier : %@", peripheral.identifier);
        [self.peripherals addObject:peripheral.identifier];
        NSString *source = [NSString stringWithFormat:@"%@", peripheral.identifier];
        
        NSString *pattern = @"(^<.*> )";
        NSString *replacement = @"";
        
        NSRegularExpression *regexp = [NSRegularExpression
                                       regularExpressionWithPattern:pattern
                                       options:NSRegularExpressionCaseInsensitive
                                       error:nil];
        NSString *str = [regexp
                         stringByReplacingMatchesInString:source
                         options:NSMatchingReportProgress
                         range:NSMakeRange(0, source.length)
                         withTemplate:replacement];
        NSLog(@"UUID%@", str);
        NSLog(@"self.peripherals -> %@", self.peripherals);
        NSLog(@"self.peripherals count : %lu", (unsigned long)[self.peripherals count]);
            NSString *message = [NSString stringWithFormat:@"didDiscoverPeripheral  %@ RSSI: %@",peripheral, RSSI];
            //[self sendIBeaconLog:message];
        //////////////crash!     [self insertNewEvent:message];
    } else {
        // finded
        NSString *message = [NSString stringWithFormat:@"didDiscoverPeripheral  %@ RSSI: %@",peripheral, RSSI];
        //[self sendIBeaconLog:message];
      //////////////crash!  [self insertNewEvent:message];
    }
    // スキャン停止
    //[self.centralManager stopScan];
    // 接続開始
    //[central connectPeripheral:peripheral options:nil];
}
#pragma mark - <BLECentralManagerDelegate> methods
//- (void)CentralDidUpdateState:(CBCentralManager *_Nullable)central{
//}
//- (void)didDiscoverPeripheral:(CBPeripheral *_Nullable)peripheral
//            advertisementData:(NSDictionary *_Nullable)advertisementData
//                         RSSI:(NSNumber *_Nullable)RSSI{
//}

#pragma mark - <BLEPeripheralManagerDelegate> methods
- (void)DidStartAdvertising:(CBPeripheralManager *_Nullable)peripheral error:(NSError *_Nullable)error{
    NSString *message = [NSString stringWithFormat:@"DidStartAdvertising  %@ error: %@",peripheral, error.debugDescription];
    //[self sendIBeaconLog:message];
   //////////////crash!  [self insertNewEvent:message];
}
- (void)PeripheralDidUpdateState:(CBPeripheralManager *_Nullable)peripheral{
    NSString *message = [NSString stringWithFormat:@"PeripheralDidUpdateState: %@", peripheral];
    //[self sendIBeaconLog:message];
   //////////////crash!  [self insertNewEvent:message];
}

#endif
#if (SURPPORT_BLE)
#define TOFLOATSECONDS(x) (float)(x)/(float)1000
- (void)StartTimerBLECentralScanPeripherals {
    NSInteger scanInterval = 5000;
    if (BLE_SCAN_UUID) {
        NSArray *services = @[self.proximityUUID];
        NSLog(@"BLE uuid:[%@] scan starting ...",services);
        [self.bleCentralManager scanForPeripheralsWithServices:services options:nil];
    } else if (BLE_SCAN_LINKING) {
        CBUUID *serviceUUID_128Bit = [CBUUID UUIDWithString: SERVICE_UUID_LINKING_128BIT];
        CBUUID *serviceUUID_16Bit = [CBUUID UUIDWithString: SERVICE_UUID_LINKING_16BIT];
        NSArray *services = @[serviceUUID_128Bit,serviceUUID_16Bit];
        NSLog(@"BLE Linking scan starting ...");
        [self.bleCentralManager scanForPeripheralsWithServices:services options:nil];
    } else {
        NSLog(@"BLE All scan starting ...");
        [self.bleCentralManager scanForPeripheralsWithServices:nil options:nil];
    }
    NSLog(@"StartTimerBLECentralScanPeripherals() Start");
    [self performSelector:@selector(StartTimerBLECentralScanPeripherals) withObject:nil afterDelay: TOFLOATSECONDS(scanInterval)];
}
#endif
@end
