//
//  EM+ChatMessageFileBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageFileBody.h"
#import "EM+ChatMessageModel.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatMessageUIConfig.h"

@implementation EM_ChatMessageFileBody{
    UIImageView *fileView;
    UILabel *nameLabel;
    UILabel *sizeLabel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        fileView = [[UIImageView alloc]init];
        fileView.backgroundColor = [UIColor grayColor];
        [self addSubview:fileView];
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.numberOfLines = 0;
        nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        nameLabel.textColor = [UIColor blackColor];
        [self addSubview:nameLabel];
        
        sizeLabel = [[UILabel alloc]init];
        sizeLabel.textAlignment = NSTextAlignmentLeft;
        sizeLabel.textColor = [UIColor grayColor];
        sizeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:sizeLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    fileView.frame = CGRectMake(self.config.bodyFilePadding, self.config.bodyFilePadding, size.height - self.config.bodyFilePadding * 2, size.height - self.config.bodyFilePadding * 2);
    nameLabel.frame = CGRectMake(fileView.frame.size.width + 10, self.config.bodyFilePadding, size.width - fileView.frame.size.width - 10 , size.height / 3 * 2);
    sizeLabel.frame = CGRectMake(fileView.frame.size.width + 10, nameLabel.frame.size.height, (size.width - fileView.frame.size.width - 10) / 2 , size.height / 3);
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_ACTION_FILE forKey:kHandleActionName];
    return userInfo;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMFileMessageBody *fileBody = (EMFileMessageBody *)message.messageBody;
    
    nameLabel.text = fileBody.displayName;
    sizeLabel.text = [EM_ChatFileUtils stringFileSize:fileBody.fileLength];
}

@end