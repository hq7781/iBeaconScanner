//
//  FileCell.m
//  iBeaconLinkingScanner
//
//  Created by Ken.Kou on 2016/11/07.
//  Copyright © 2016年 ENIXSOFT.,Co Ltd. All rights reserved.
//

#import "FileCell.h"

@implementation FileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
//    self.selectionStyle = UITableViewCellSelectionStyleBlue;
//    self.backgroundColor = UIColor.blueColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
//    if(highlighted){
//        self.alpha = 0.5f;
//        self.backgroundColor = UIColor.yellowColor;
//    } else {
//        self.alpha = 1.0f;
//        self.backgroundColor = UIColor.clearColor;
//    }
}

@end
