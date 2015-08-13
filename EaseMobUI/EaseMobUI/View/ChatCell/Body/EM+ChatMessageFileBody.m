//
//  EM+ChatMessageFileBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageFileBody.h"
#import "EM+ChatMessageModel.h"

@implementation EM_ChatMessageFileBody{
    UIImageView *fileView;
    UILabel *nameLabel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        fileView = [[UIImageView alloc]init];
        fileView.backgroundColor = [UIColor grayColor];
        [self addSubview:fileView];
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    fileView.bounds = self.bounds;
    fileView.center = CGPointMake(size.width / 2, size.height / 2);
    
    nameLabel.frame = CGRectMake(0, fileView.frame.origin.y + (fileView.frame.size.height - 30), fileView.frame.size.width, 30);
}

- (NSString *)handleAction{
    return HANDLE_ACTION_FILE;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMFileMessageBody *fileBody = (EMFileMessageBody *)message.messageBody;
    
    nameLabel.text = fileBody.displayName;
}

@end