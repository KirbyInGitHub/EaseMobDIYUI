//
//  EM+ChatMessageFileBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageFileBubble.h"

@implementation EM_ChatMessageFileBubble{
    UIImageView *fileView;
    UILabel *nameLabel;
}

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody maxWithd:(CGFloat)max{
    CGSize superSize = [super sizeForBubbleWithMessage:messageBody maxWithd:max];
    CGSize size = CGSizeMake(max / 2, max / 2);
    size.height += superSize.height;
    size.width += superSize.width;
    
    return size;
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
    fileView.frame = CGRectMake(CELL_BUBBLE_RIGHT_PADDING, CELL_BUBBLE_TOP_PADDING, size.width - CELL_BUBBLE_RIGHT_PADDING - CELL_BUBBLE_LEFT_PADDING, size.height - CELL_BUBBLE_TOP_PADDING - CELL_BUBBLE_BOTTOM_PADDING);
    
    nameLabel.frame = CGRectMake(CELL_BUBBLE_RIGHT_PADDING, size.height - CELL_BUBBLE_BOTTOM_PADDING - 30, size.width - CELL_BUBBLE_RIGHT_PADDING - CELL_BUBBLE_LEFT_PADDING, 30);
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