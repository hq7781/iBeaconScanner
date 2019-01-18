//
//  LogFileViewController.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/07.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "LogFileViewController.h"
#import "DetailViewController.h"

#import "MGSwipeButton.h"
#import "Utils.h"

@interface LogFileViewController ()
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSMutableArray *contents;
@property NSInteger selectedItem;
@end

@implementation LogFileViewController
- (void) viewDidLoad {
    [super viewDidLoad];
    
//    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler)];
//    tapGesture.numberOfTapsRequired = 1;
//    self.navigationTitle.userInteractionEnabled = YES;
//    [self.navigationTitle addGestureRecognizer:tapGesture];
    [self initLongPressGesture];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    self.selectedItem = -1;

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionShareButton:)];
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(actionDeleteButton:)];
    //self.navigationItem.rightBarButtonItems = @[shareButton,deleteButton];
    self.navigationItem.title = @"ログファイル";
    self.navigationItem.leftBarButtonItem = shareButton;
    self.navigationItem.rightBarButtonItem = deleteButton;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //if (!self.path) {
        //self.path = @"/";
        NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
        self.path = documentDirectory;
    //}
    [self setPath:self.path];
    [self orderContentsArray];
    [self.tableView reloadData];
}

- (void) setPath:(NSString *)path {
    _path = path;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    self.contents = [self deleteAllHiddenFilesFromArray:[fileManager contentsOfDirectoryAtPath:self.path error:nil]];
    //self.navigationTitle.text = [self.path lastPathComponent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -Gestures
- (void)initLongPressGesture {
    UILongPressGestureRecognizer *longPressGesture=
    [[UILongPressGestureRecognizer alloc]initWithTarget:self
                                                 action:@selector(handleLongPressGesture)];
    [self.tableView addGestureRecognizer:longPressGesture];
}
- (void)handleLongPressGesture {
    if (self.selectedItem < 0) {
        [Utils ToastWith:@"ファイルが選択されていません"];
        return;
    }
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"View File?" message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DetailViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        NSMutableArray *contents = [NSMutableArray arrayWithArray:
                                    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil]];
        NSString *folder = [contents objectAtIndex:self.selectedItem];
        NSString *filepath = [self.path stringByAppendingPathComponent:folder];
        
        NSError * error;
        NSString *fileContents = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"Error reading file: %@", error.localizedDescription);
            [Utils ToastWith:@"読み込みエラー発生しました"];
            return ;
        }
        viewController.detailItem = fileContents;
        [self showViewController:viewController sender:nil];
        [alertController dismissViewControllerAnimated:NO completion:nil];
        
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -Private Methods

- (BOOL) isDirectoryForPath:(NSIndexPath *)indexPath {
    BOOL isDirectory = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:[self getStringPathForIndexPath:indexPath]
                                         isDirectory:&isDirectory];
    return isDirectory;
}

- (NSString *)getStringPathForIndexPath:(NSIndexPath *)indexPath {
    NSString* fileName = [self.contents objectAtIndex:indexPath.row];
    NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
    return filePath;
}

- (void)createNewFolderWithName:(NSString *)folderName {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString* folderPath = [self.path stringByAppendingPathComponent:folderName];
    NSMutableArray* tempContents = nil;
    NSInteger index = 0;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    if (self.contents) {
        tempContents = [NSMutableArray arrayWithArray:self.contents];
    } else {
        tempContents = [NSMutableArray array];
    }
    if ([fileManager fileExistsAtPath:folderPath]) {
        [self showModalWithMessage:@"Folder already exists"];
    } else {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
        [tempContents insertObject:folderName atIndex:index];
        self.contents = [NSArray arrayWithArray:tempContents];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (void) orderContentsArray {
    NSMutableArray* contents = [NSMutableArray array];
    if (self.contents) {
        contents = [NSMutableArray arrayWithArray:self.contents];
        NSMutableArray* folders = [NSMutableArray array];
        NSMutableArray* files = [NSMutableArray array];
        
        for (NSString* item in contents) {
            BOOL isDir = NO;
            [[NSFileManager defaultManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:item] isDirectory:&isDir];
            
            if (isDir) {
                [folders addObject:item];
            } else {
                [files addObject:item];
            }
        }
        
        contents = [NSMutableArray arrayWithArray:folders];
        [contents addObjectsFromArray:files];
        self.contents = contents;
    }
}

- (NSArray *)deleteAllHiddenFilesFromArray:(NSArray *)array {
    NSMutableArray* tempArray = [NSMutableArray array];
    for (NSString* item in array) {
        if (![item hasPrefix:@"."]) {
            [tempArray addObject:item];
        }
    }
    return [NSArray arrayWithArray:tempArray];
}

- (void)showModalWithMessage:(NSString *)message {
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Attention!" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -Actions
- (IBAction)actionShareButton:(UIButton *)sender{
    if (self.selectedItem < 0) {
        [Utils ToastWith:@"ファイルが選択されていません"];
        return;
    }
    
    NSMutableArray *contents = [NSMutableArray arrayWithArray:
                                [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil]];
    NSString *folder = [contents objectAtIndex:self.selectedItem];
    NSString *filepath = [self.path stringByAppendingPathComponent:folder];
    
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


- (IBAction)actionDeleteButton:(UIButton *)sender{
    if(self.selectedItem < 0) {
        [Utils ToastWith:@"ファイルが選択されていません"];
        return;
    }
    [self.tableView beginUpdates];
    NSMutableArray *contents = [NSMutableArray arrayWithArray:
                                [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil]];
    NSString *folder = [contents objectAtIndex:self.selectedItem];
    NSString *path = [self.path stringByAppendingPathComponent:folder];
    
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [contents removeObject:folder];
    
    self.contents = [NSArray arrayWithArray:contents];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.selectedItem inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    self.selectedItem = -1;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isDirectoryForPath:indexPath]) {
        NSString* fileName = [self.contents objectAtIndex:indexPath.row];
        NSString* filePath = [self.path stringByAppendingPathComponent:fileName];
        
        UIStoryboard* storyboard = self.storyboard;
        LogFileViewController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"LogFileViewController"];
        viewController.path = filePath;
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        for (NSInteger index=0; index < [self.tableView numberOfRowsInSection:0]; index++) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            if (indexPath.row == index) {
                if (self.selectedItem == index) {
                    cell.backgroundColor = UIColor.clearColor;
                    self.selectedItem = -1;
                } else {
                    cell.backgroundColor = UIColor.lightGrayColor;
                    self.selectedItem = index;
                }
            } else {
                cell.backgroundColor = UIColor.clearColor;
            }
        }
    }
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* fileIdentifier = @"FileCell";
    static NSString* folderIdentifier = @"FolderCell";
    
    NSString* name = [self.contents objectAtIndex:indexPath.row];
    NSString* path = [self.path stringByAppendingPathComponent:name];
    NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    if ([self isDirectoryForPath:indexPath]) {
        FolderCell* cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
        cell.folderNameLabel.text = name;
        cell.folderSizeLabel.text = [LogUtils getFolderSizeForPath:path];
        return cell;
    } else {
        FileCell* cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
        cell.fileNamelabel.text = name;
        cell.fileSizeLabel.text = [LogUtils getFormattedStringForSize:[attributes fileSize]];
        cell.fileDateModifiedLabel.text = [Utils getFormattedDate:[attributes fileModificationDate]];

#if 0 // MGSwipeTableCell
        cell.leftSwipeSettings.transition = MGSwipeTransitionBorder; //MGSwipeTransitionRotate3D;
        cell.leftExpansion.buttonIndex = 1;
        cell.leftExpansion.fillOnTrigger = NO;
        cell.delegate = self;
        cell.leftButtons = [self createLeftButtons:indexPath];
#endif
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        NSMutableArray *contents = [NSMutableArray arrayWithArray:
                                    [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil]];
        NSString *folder = [contents objectAtIndex:indexPath.row];
        NSString *path = [self.path stringByAppendingPathComponent:folder];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        //[contents removeObject:folder];
        //self.contents = [NSMutableArray arrayWithArray:contents];
        [self.contents removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [tableView endUpdates];
    }
}

- (void)leftButtonToShare:(id)sender With:(NSIndexPath *)indexPath {
    NSMutableArray *contents = [NSMutableArray arrayWithArray:
                                [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.path error:nil]];
    NSString *folder = [contents objectAtIndex:indexPath.row];
    NSString *filepath = [self.path stringByAppendingPathComponent:folder];

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

/////  swipe Table
- (NSArray *)createLeftButtons:(NSIndexPath *)indexPath {
     NSMutableArray * result = [NSMutableArray array];
    MGSwipeButton *shareButton = [MGSwipeButton buttonWithTitle:@"Share"
                                                           icon:nil backgroundColor:UIColor.lightGrayColor
                                                       callback:^BOOL(MGSwipeTableCell * sender){
                                                           NSLog(@"Convenience callback received (left).");
                                                           [self leftButtonToShare:sender With:indexPath];
                                                           return YES;
                                                       }];
    [result addObject:shareButton];
    return result;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSArray* indexPaths = [self.tableView indexPathsForVisibleRows];
    NSIndexPath *firstIndexPath = indexPaths.firstObject;
    NSIndexPath *lastIndexPath = indexPaths.lastObject;
    
    for (NSInteger index=firstIndexPath.row; index < lastIndexPath.row ; index++) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (self.selectedItem == index) {
            cell.backgroundColor = UIColor.lightGrayColor;
        } else {
            cell.backgroundColor = UIColor.clearColor;
        }
    }
    [self.tableView reloadData];
}


#if 0 // MGSwipeTableCell
#pragma mark -MGSwipeTableCellDelegate
-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings {
    swipeSettings.transition = MGSwipeTransitionBorder;//MGSwipeTransitionRotate3D;;
//
    if (direction == MGSwipeDirectionLeftToRight) {
        expansionSettings.buttonIndex = 1;
        expansionSettings.fillOnTrigger = NO;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        return [self createLeftButtons:indexPath];
    }
    return nil;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");

    return YES;
}
#endif
@end
