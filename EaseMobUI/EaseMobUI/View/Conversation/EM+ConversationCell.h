//
//  EM+ConversationCell.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "SWTableViewCell.h"

@interface EM_ConversationCell : SWTableViewCell

@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) BOOL hiddenTopLine;
@property (nonatomic, assign) BOOL hiddenBottomLine;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end