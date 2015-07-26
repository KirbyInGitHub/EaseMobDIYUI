//
//  EM+ChatMessageState.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/23.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBase.h"
#import "EM+ChatVersion.h"

#define MESSAGE_DETAILS_COLUMN_MESSAGE_ID       (@"messageId")
#define MESSAGE_DETAILS_COLUMN_DETAILS          (@"details")
#define MESSAGE_DETAILS_COLUMN_BODY_TYPE        (@"messageBodyType")
#define MESSAGE_DETAILS_COLUMN_TYPE             (@"messageType")

@interface EM_ChatMessageState : EM_ChatBase

@property (nonatomic,copy) NSString *messageId;
@property (nonatomic,assign) BOOL details;
@property (nonatomic,assign) NSInteger messageBodyType;
@property (nonatomic,assign) NSInteger messageType;
@property (nonatomic,assign) BOOL checking;

@end