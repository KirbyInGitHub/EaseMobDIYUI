//
//  EM+ChatOppositeHeader.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EM_ChatOppositeHeaderBlock)(NSInteger section);

@interface EM_ChatOppositeHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger section;

- (void)setChatOppositeHeaderBlock:(EM_ChatOppositeHeaderBlock)block;

@end