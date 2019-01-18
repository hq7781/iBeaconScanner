//
//  LogFileViewController.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/07.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "Constants.h"
#import "Utils.h"
#import "LogUtils.h"
#import "FolderCell.h"
#import "FileCell.h"
#import "MGSwipeTableCell.h"

@interface LogFileViewController : UITableViewController <MGSwipeTableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;

@end
