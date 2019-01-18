//
//  SettingTableViewController.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/27.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"

@interface SettingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *enteredUUID1;
@property (weak, nonatomic) IBOutlet UITextField *enteredUUID2;
@property (weak, nonatomic) IBOutlet UITextField *enteredUUID3;
@property (weak, nonatomic) IBOutlet UITextField *enteredUUID4;
@property (weak, nonatomic) IBOutlet UITextField *enteredUUID5;

@property (weak, nonatomic) IBOutlet UITextField *enteredMajor;
@property (weak, nonatomic) IBOutlet UITextField *enteredMinor;
@property (weak, nonatomic) IBOutlet UITextField *enteredIdentifier;

//@property (weak, nonatomic) IBOutlet UISegmentedControl *segBeaconMode;

@property (weak, nonatomic) IBOutlet UITextField *targetDeviceID;

@property (weak, nonatomic) IBOutlet UISwitch *switchLog2File;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendMail;

@property (strong, nonatomic) SettingViewController *parent;
@property (retain, nonatomic) NSArray* textfields;
@end
