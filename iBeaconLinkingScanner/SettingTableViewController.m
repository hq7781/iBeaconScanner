//
//  SettingTableViewController.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/10/27.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "SettingTableViewController.h"
#import "Constants.h"
#import "Utils.h"
#import "DefaultsUtils.h"

@interface SettingTableViewController() <UITextFieldDelegate>

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    NSString *saveduuid = [DefaultsUtils getIBeaconUUID];
    if (saveduuid) {
        NSArray *uuids = [saveduuid componentsSeparatedByString:@"-"];
        //NSString *message = [NSString stringWithFormat: @"readed UUID: [%@-%@-%@-%@-%@]",uuids[0],uuids[1],uuids[2],uuids[3],uuids[4]];

        [self.enteredUUID1 setText: uuids[0]];
        [self.enteredUUID2 setText: uuids[1]];
        [self.enteredUUID3 setText: uuids[2]];
        [self.enteredUUID4 setText: uuids[3]];
        [self.enteredUUID5 setText: uuids[4]];
    }
    int savedMajor = [DefaultsUtils getIBeaconMajor];
    if (savedMajor > 0){
        [self.enteredMajor setText:[NSString stringWithFormat:@"%d",savedMajor]];
    }
    int savedMinor = [DefaultsUtils getIBeaconMinor];
    if (savedMinor > 0){
        [self.enteredMinor setText:[NSString stringWithFormat:@"%d",savedMinor]];
    }
    NSString *savedid = [DefaultsUtils getIBeaconIdentifier];
    if (savedid) {
        [self.enteredIdentifier setText: savedid];
    }
    NSString *deviceid = [DefaultsUtils getLinkingDeviceId];
    if (deviceid) {
        [self.targetDeviceID setText: deviceid];
    }
//    int beaconMode = [DefaultsUtils getBeaconMode];
//    if (beaconMode < 3 && beaconMode >= 0) {
//        self.segBeaconMode.selectedSegmentIndex = beaconMode;
//    } else {
//        self.segBeaconMode.selectedSegmentIndex = 0;
//    }

    self.enteredUUID1.delegate = self;
    self.enteredUUID2.delegate = self;
    self.enteredUUID3.delegate = self;
    self.enteredUUID4.delegate = self;
    self.enteredUUID5.delegate = self;
    self.enteredMajor.delegate = self;
    self.enteredMinor.delegate = self;
    self.enteredIdentifier.delegate = self;
    self.targetDeviceID.delegate = self;
    self.textfields = [[NSArray alloc] initWithObjects:
                           _enteredUUID1,_enteredUUID2,_enteredUUID3,_enteredUUID4,_enteredUUID5,
                           _enteredMajor,_enteredMinor,_enteredIdentifier,_targetDeviceID, nil];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFromTableView:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITextFieldDelegate> methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int maxLength = 0;
    if ([textField isEqual:self.enteredUUID1]) {
        // ASCII & Number only
        if (([string length] != 0) && [Utils isNotAlphaNumericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_UUID1;
    } else if ([textField isEqual:self.enteredUUID2]) {
        // ASCII & Number only
        if (([string length] != 0) && [Utils isNotAlphaNumericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_UUID2;
    } else if ([textField isEqual:self.enteredUUID3]) {
        // ASCII & Number only
        if (([string length] != 0) && [Utils isNotAlphaNumericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_UUID3;
    }    if ([textField isEqual:self.enteredUUID4]) {
        // ASCII & Number only
        if (([string length] != 0) && [Utils isNotAlphaNumericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_UUID4;
    } else if ([textField isEqual:self.enteredUUID5]) {
        // ASCII & Number only
        if (([string length] != 0) && [Utils isNotAlphaNumericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_UUID5;
    } else if ([textField isEqual:self.enteredMajor]) {
        // Number only
        if (([string length] != 0) && [Utils isNotNumbericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_MAJOR;
    } else if ([textField isEqual:self.enteredMinor]) {
        // Number only
        if (([string length] != 0) && [Utils isNotNumbericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_MINOR;
    } else if ([textField isEqual:self.enteredIdentifier]) {
        maxLength = MAX_LENGTH_IDENTIFIER;
    } else if ([textField isEqual:self.targetDeviceID]) {
        // Number only
        if (([string length] != 0) && [Utils isNotNumbericOnly:string]){return NO;}
        maxLength = MAX_LENGTH_DEVICEID;
    }

    if ((textField.text.length >= maxLength) && (range.length == 0)) {
        [textField resignFirstResponder];
        NSInteger nextTag = textField.tag + 1;
        if (nextTag < self.textfields.count) {
            [self.textfields[nextTag] becomeFirstResponder];
        }
        return NO; // return NO to not change text
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.enteredUUID1]) {
        BOOL isUUID1 = ([self.enteredUUID1.text length] == MAX_LENGTH_UUID1)? YES:NO;
        if (isUUID1) {
            [_enteredUUID1 resignFirstResponder];
        } else {
            [Utils ToastWith:@"Pls input an Correct UUID!"];
        }
    } else if ([textField isEqual:self.enteredUUID2]) {
        BOOL isUUID2 = ([self.enteredUUID2.text length] == MAX_LENGTH_UUID2)? YES:NO;
        if (isUUID2) {
            [_enteredUUID2 resignFirstResponder];
        } else {
            [Utils ToastWith:@"Pls input an Correct UUID!"];
        }
    } else if ([textField isEqual:self.enteredUUID3]) {
        BOOL isUUID3 = ([self.enteredUUID3.text length] == MAX_LENGTH_UUID3)? YES:NO;
        if (isUUID3) {
            //self.uuid = _enteredUUID1.text;
            [_enteredUUID3 resignFirstResponder];
        } else {
            [Utils ToastWith:@"Pls input an Correct UUID!"];
        }
    } else if ([textField isEqual:self.enteredUUID4]) {
        BOOL isUUID4 = ([self.enteredUUID4.text length] == MAX_LENGTH_UUID4)? YES:NO;
        if (isUUID4) {
            //self.uuid = _enteredUUID1.text;
            [_enteredUUID4 resignFirstResponder];
        } else {
            [Utils ToastWith:@"Pls input an Correct UUID!"];
        }
    } else if ([textField isEqual:self.enteredUUID5]) {
        BOOL isUUID5 = ([self.enteredUUID5.text length] == MAX_LENGTH_UUID5)? YES:NO;
        if (isUUID5) {
            //self.uuid = _enteredUUID5.text;
            [_enteredUUID5 resignFirstResponder];
        } else {
            [Utils ToastWith:@"Pls input an Correct UUID!"];
        }
    } else if ([textField isEqual:self.enteredMajor]) {
        NSScanner *scanner = [NSScanner scannerWithString:_enteredMajor.text];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if (isNumeric) {
            [_enteredMajor resignFirstResponder];
        } else {
            [Utils ToastWith:@"Pls input an Major Number"];
        }
    } else if ([textField isEqual:self.enteredMinor]) {
        NSScanner *scanner = [NSScanner scannerWithString:_enteredMinor.text];
        BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
        if (isNumeric) {
            [_enteredMinor resignFirstResponder];
        } else {
            [Utils ToastWith:@"Pls input an Minor Number"];
        }
    } else if ([textField isEqual:self.enteredIdentifier]) {
        [_enteredIdentifier resignFirstResponder];
    } else if ([textField isEqual:self.targetDeviceID]){
        [_enteredIdentifier resignFirstResponder];
    }
    [textField resignFirstResponder];
    return YES;
}

//- (IBAction)didChangedBeaconMode:(id)sender {
//    [DefaultsUtils setBeaconMode:(int)_segBeaconMode.selectedSegmentIndex];
//}

- (IBAction)didChangedLogging2File:(id)sender {
    [DefaultsUtils setFlagLogging: _switchLog2File.isOn];
}
- (IBAction)sendLogFileToEmail:(id)sender {
    
    NSString *strUrl = [NSString stringWithFormat:@"mailto:%@", DEVOLPER_MAIL_ADDRESS];
    NSURL *url = [NSURL URLWithString:strUrl];

    [UIApplication.sharedApplication openURL:url];
    /*
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    [mailController setSubject:@"Some Subject"];
    [mailController addAttachmentData:data
                             mimeType:@"application/kpt"
                             fileName:@"originalFileName.kpt"];

    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    [mailComposeViewController setSubject:@"Data Export"];
    [mailComposeViewController setMessageBody:@"Here's the data that I am exporting" isHTML:NO];
    [mailComposeViewController addAttachmentData:textFileContentsData mimeType:@"text/plain" fileName:@"data.txt"];
    [self presentModalViewController:mailComposeViewController animated:YES];
     */
}

- (void)handleTapFromTableView:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark - <UIGestureRecognizerDelegate> methods

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
 #pragma mark - <MFMailComposeViewControllerDelegate> methods
 //MessageUI.framework
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
 */
@end
