//
//  FileCell.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/07.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
@interface FileCell :UITableViewCell //  MGSwipeTableCell //UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fileNamelabel;
@property (weak, nonatomic) IBOutlet UILabel *fileDateModifiedLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@end
