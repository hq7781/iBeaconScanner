//
//  SettingViewController.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/25.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewController.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "DefaultsUtils.h"


@interface SettingViewController()
@property SettingTableViewController *settingTableVC;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
//                initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(toShare:)];
    
    UINavigationItem *item = [[UINavigationItem alloc] initWithTitle:@"Setting"];
//    item.leftBarButtonItem = shareButton;
    item.rightBarButtonItem = self.updateButton;
    item.hidesBackButton = YES;
    [self.navigationBar pushNavigationItem:item animated:NO];

    [self updateViewConstraints];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [Utils ToastWith:@"Entering Setting"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"settingTableviewVC"]) {
        self.settingTableVC = segue.destinationViewController;
        self.settingTableVC.parent = self;
    }
}

- (IBAction)toApply:(id)sender {
    if (!_settingTableVC) return;
    [self.view endEditing:YES];
    if ( ([_settingTableVC.enteredUUID1.text length] != MAX_LENGTH_UUID1)
        || ([_settingTableVC.enteredUUID2.text length] != MAX_LENGTH_UUID2)
        || ([_settingTableVC.enteredUUID3.text length] != MAX_LENGTH_UUID3)
        || ([_settingTableVC.enteredUUID4.text length] != MAX_LENGTH_UUID4)
        || ([_settingTableVC.enteredUUID5.text length] != MAX_LENGTH_UUID5)) {
        
        [Utils ToastWith:UI_STRING_AVAILABLE_UUID];
        return;
    }

    NSString * strUUID = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",
                          _settingTableVC.enteredUUID1.text, _settingTableVC.enteredUUID2.text,
                          _settingTableVC.enteredUUID3.text, _settingTableVC.enteredUUID4.text,
                          _settingTableVC.enteredUUID5.text];
    
    [DefaultsUtils setIBeaconUUID:[strUUID uppercaseString]];
    [DefaultsUtils setIBeaconMajor:[_settingTableVC.enteredMajor.text intValue]];
    [DefaultsUtils setIBeaconMinor:[_settingTableVC.enteredMinor.text intValue]];
    [DefaultsUtils setIBeaconIdentifier:_settingTableVC.enteredIdentifier.text];
    [DefaultsUtils setLinkingDeviceId:_settingTableVC.targetDeviceID.text];
    AppDelegate *application = (AppDelegate*)[[UIApplication sharedApplication] delegate];

//    if (0 == [DefaultsUtils getBeaconMode]) {
        if (NO == [application setupIBeaconManager]) {
            NSString * message = UI_STRING_INVALIDUUID;
            NSLog(@"%@", message);
            UIAlertController *alertController =
            [UIAlertController alertControllerWithTitle:@"確認"
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action =
            [UIAlertAction actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action) {NSLog(@"Clicked");}];
            [alertController addAction:action];
            [self presentViewController:alertController animated:YES
                             completion:^{NSLog(@"YES");}];
        }
//    }
}
- (void)toShare:(id)sender {
    AppDelegate *application = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //NSString *filepath = [[NSBundle mainBundle] pathForResource:filePath ofType:@"txt"];
    NSString *filepath = [[application.logger getFilePath] absoluteString];
    NSError * error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"Error reading file: %@", error.localizedDescription);
    }
    NSLog(@"contents: %@", fileContents);
    // AirDrop or Notes におくる場合は行単位で切って送信する
    NSArray *listArray = [fileContents componentsSeparatedByString:@"\n"];
    NSLog(@"items = %lu", (unsigned long)[listArray count]);

    NSArray *activityItems = listArray;
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityViewControntroller.popoverPresentationController.sourceView = self.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/4, 0, 0);
    }
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

@end
