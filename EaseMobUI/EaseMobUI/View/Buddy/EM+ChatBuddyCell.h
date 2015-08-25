//
//  EM+ChatBuddyCell.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EM_ChatBuddyCell : UITableViewCell

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *details;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) UIImage *avatarImage;

@end