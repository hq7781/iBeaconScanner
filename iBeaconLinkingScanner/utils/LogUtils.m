//
//  LogUtils.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/01.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "LogUtils.h"
#import "Utils.h"
#import "Constants.h"

@interface LogUtils ()
@property (nonatomic)NSURL *filePath;
@end

@implementation LogUtils

- (instancetype)init {
    if (self = [super init]) {
        [self createNewLogFile];
    }
    return self;
}
- (void)createNewLogFile {
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    NSString *filename = [NSString stringWithFormat:@"%@%@", DEFAULT_LOGFILE, [Utils getFormattedDateForFilename]];
    //NSURL [NSURL fileURLWithPath:self.filePath];
    //NSString [self.filePath absoluteString]
    self.filePath = [[[NSURL URLWithString:documentDirectory]
                      URLByAppendingPathComponent:filename]
                     URLByAppendingPathExtension:@"log"];
}
- (void)append:(NSString *)log {
    @synchronized(self) {
        if (!log || log.length == 0) {
            return;
        }
        unsigned long long fileSize =
        [[[NSFileManager defaultManager] attributesOfItemAtPath:self.filePath.absoluteString error:nil] fileSize];
        if (MAX_SIZE_LOGFILE < fileSize) {
            [self createNewLogFile];
        }
        
        NSError      *error = nil;
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingToURL:self.filePath error:&error];
        if (!fileHandle) {
            [[NSFileManager defaultManager] createFileAtPath:self.filePath.absoluteString contents:nil attributes:nil];
            fileHandle = [NSFileHandle fileHandleForWritingToURL:self.filePath error:&error];
            if (!fileHandle){
                NSLog(@"%@", [error localizedDescription]);
                return;
            }
        }

        NSString *logData = [NSString stringWithFormat:@"%@, %@\r\n", [Utils getFormattedCurrentWithMsec], log];
        
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[logData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO]];
        [fileHandle closeFile];
    }
}

- (NSURL *)getFilePath {
    return  self.filePath;
}

+ (NSString*) getFormattedDateFor: (NSDate*) date{
    static NSDateFormatter* formatter = nil;
    if (!formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy hh:mm a"];
    }
    
    return [formatter stringFromDate:date];
}

+ (NSString *)getFormattedStringForSize:(unsigned long long)fileSize {
    NSString *fileSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return fileSizeStr;
}

+ (NSString *)getFolderSizeForPath:(NSString *)folderPath {
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    
    NSString *file;
    unsigned long long int folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [fileAttributes fileSize];
    }
    return [self getFormattedStringForSize:folderSize];
}

@end
