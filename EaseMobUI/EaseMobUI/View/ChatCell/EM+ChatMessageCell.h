//
//  EM+ChatMessageBaseCell.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/16.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EM+ChatMessageModel.h"
#import "EM+ChatMessageTextBubble.h"
#import "EM+ChatMessageImageBubble.h"
#import "EM+ChatMessageVideoBubble.h"
#import "EM+ChatMessageLocationBubble.h"
#import "EM+ChatMessageVoiceBubble.h"
#import "EM+ChatMessageFileBubble.h"

#define CELL_AVATAR_SIZE (50)
#define CELL_PADDING (15)
#define CELL_TIME_HEIGHT (20)
#define CELL_NAME_HEIGHT (20)
#define CELL_INDICATOR_SIZE (20)
#define CELL_BUBBLE_TAIL_WIDTH  (12)

extern NSString * const REUSE_IDENTIFIER_TEXT;
extern NSString * const REUSE_IDENTIFIER_IMAGE;
extern NSString * const REUSE_IDENTIFIER_VIDEO;
extern NSString * const REUSE_IDENTIFIER_LOCATION;
extern NSString * const REUSE_IDENTIFIER_VOICE;
extern NSString * const REUSE_IDENTIFIER_IFILE;
extern NSString * const REUSE_IDENTIFIER_COMMAND;
extern NSString * const REUSE_IDENTIFIER_UNKNOWN;

@protocol EM_ChatMessageCellDelegate;

@interface EM_ChatMessageCell : UITableViewCell

@property (nonatomic,strong) EM_ChatMessageModel *message;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak) id<EM_ChatMessageCellDelegate> delegate;

@property (nonatomic,strong,readonly) EM_ChatMessageBaseBubble *bubbleView;
@property (nonatomic, strong) UIView *extendView;

+ (CGFloat)cellBubbleMaxWidth:(CGFloat)cellMaxWidth;

+ (NSString *)cellIdFormMessageBodyType:(MessageBodyType)type;

+ (CGFloat)heightForCellWithMessage:(EM_ChatMessageModel *)message maxWidth:(CGFloat)max indexPath:(NSIndexPath *)indexPath;

+ (EM_ChatMessageCell *)cellFromMessageBodyType:(MessageBodyType)type reuseIdentifier:(NSString *)reuseIdentifier;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(MessageBodyType)type;

@end

@protocol EM_ChatMessageCellDelegate <NSObject>

@required

@optional

- (void)chatMessageCell:(EM_ChatMessageCell *)cell didTapAvatarWithChatter:(NSString *)chatter indexPath:(NSIndexPath *)indexPath;

- (void)chatMessageCell:(EM_ChatMessageCell *)cell resendMessageWithMessage:(EM_ChatMessageModel *)message indexPath:(NSIndexPath *)indexPath;

- (void)chatMessageCell:(EM_ChatMessageCell *)cell didTapMessageWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath;

- (void)chatMessageCell:(EM_ChatMessageCell *)cell didLongPressMessageWithUserInfo:(NSDictionary *)userInfo indexPath:(NSIndexPath *)indexPath;

- (void)chatMessageCell:(EM_ChatMessageCell *)cell didMenuSelectedWithAction:(EM_MENU_ACTION)action message:(EM_ChatMessageModel *)message indexPath:(NSIndexPath *)indexPath;

@end