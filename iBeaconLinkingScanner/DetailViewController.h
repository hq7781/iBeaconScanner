//
//  DetailViewController.h
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/24.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

//@property (strong, nonatomic) NSDate *detailItem;
@property (strong, nonatomic) NSString *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextView *textlog;

- (void)setDetailItem:(NSString *)newDetailItem;
@end

