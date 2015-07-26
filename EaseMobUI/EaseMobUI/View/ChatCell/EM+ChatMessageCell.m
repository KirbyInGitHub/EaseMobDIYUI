//
//  EM+ChatMessageBaseCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/16.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UIColor+Hex.h"

#import "EM+ChatMessageCell.h"

@interface EM_ChatMessageCell()<EM_ChatMessageBubbleDelegate>

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *avatarView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UIButton *retryButton;
@property (nonatomic,strong) UILabel *stateLabel;

@end

@implementation EM_ChatMessageCell

NSString * const REUSE_IDENTIFIER_TEXT = @"REUSE_IDENTIFIER_TEXT";
NSString * const REUSE_IDENTIFIER_IMAGE = @"REUSE_IDENTIFIER_IMAGE";
NSString * const REUSE_IDENTIFIER_VIDEO = @"REUSE_IDENTIFIER_VIDEO";
NSString * const REUSE_IDENTIFIER_LOCATION = @"REUSE_IDENTIFIER_LOCATION";
NSString * const REUSE_IDENTIFIER_VOICE = @"REUSE_IDENTIFIER_VOICE";
NSString * const REUSE_IDENTIFIER_IFILE = @"REUSE_IDENTIFIER_IFILE";
NSString * const REUSE_IDENTIFIER_COMMAND = @"REUSE_IDENTIFIER_COMMAND";
NSString * const REUSE_IDENTIFIER_UNKNOWN = @"REUSE_IDENTIFIER_UNKNOWN";

+ (NSString *)cellIdFormMessageBodyType:(MessageBodyType)type{
    NSString *cellId = REUSE_IDENTIFIER_UNKNOWN;
    switch (type) {
        case eMessageBodyType_Text:{
            cellId = @"TEXT_REUSE_IDENTIFIER";
        }
            break;
        case eMessageBodyType_Image:{
            cellId = @"IMAGE_REUSE_IDENTIFIER";
        }
            break;
        case eMessageBodyType_Video:{
            cellId = @"VIDEO_REUSE_IDENTIFIER";
        }
            break;
        case eMessageBodyType_Location:{
            cellId = @"LOCATION_REUSE_IDENTIFIER";
        }
            break;
        case eMessageBodyType_Voice:{
            cellId = @"VOICE_REUSE_IDENTIFIER";
        }
            break;
        case eMessageBodyType_File:{
            cellId = @"FILE_REUSE_IDENTIFIER";
        }
            break;
        case eMessageBodyType_Command:{
            cellId = @"COMMAND_REUSE_IDENTIFIER";
        }
            break;
    }
    return cellId;
}

+ (CGFloat)heightForCellWithMessage:(EM_ChatMessageModel *)message  maxWidth:(CGFloat)max indexPath:(NSIndexPath *)indexPath{
    id<IEMMessageBody> messageBody = message.messageBody;
    
    CGFloat contentHeight = CELL_PADDING * 2;
    if (message.showTime) {
        contentHeight += CELL_TIME_HEIGHT;
    }
    CGFloat maxBubbleWidth = max - CELL_PADDING * 2 - CELL_AVATAR_SIZE * 2;
    
    switch (message.bodyType) {
        case eMessageBodyType_Text:{
            message.bubbleSize = [EM_ChatMessageTextBubble sizeForBubbleWithMessage:messageBody maxWithd:maxBubbleWidth];
        }
            break;
        case eMessageBodyType_Image:{
            message.bubbleSize = [EM_ChatMessageImageBubble sizeForBubbleWithMessage:messageBody maxWithd:maxBubbleWidth];
        }
            break;
        case eMessageBodyType_Video:{
            message.bubbleSize = [EM_ChatMessageVideoBubble sizeForBubbleWithMessage:messageBody maxWithd:maxBubbleWidth];
        }
            break;
        case eMessageBodyType_Location:{
            message.bubbleSize = [EM_ChatMessageLocationBubble sizeForBubbleWithMessage:messageBody maxWithd:maxBubbleWidth];
        }
            break;
        case eMessageBodyType_Voice:{
            message.bubbleSize = [EM_ChatMessageVoiceBubble sizeForBubbleWithMessage:messageBody maxWithd:maxBubbleWidth];
        }
            break;
        case eMessageBodyType_File:{
            message.bubbleSize = [EM_ChatMessageFileBubble sizeForBubbleWithMessage:messageBody maxWithd:maxBubbleWidth];
        }
            break;
        default:
            break;
    }
    
    CGFloat height = message.bubbleSize.height + ( message.messageType == eMessageTypeChat ? 0 : CELL_NAME_HEIGHT);
    if (height > CELL_AVATAR_SIZE) {
        contentHeight += height;
    }else{
        contentHeight += CELL_AVATAR_SIZE;
    }
    
    return contentHeight;
}

+ (EM_ChatMessageCell *)cellFromMessageBodyType:(MessageBodyType)type reuseIdentifier:(NSString *)reuseIdentifier{
    EM_ChatMessageCell * cell = [[EM_ChatMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier type:type];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(MessageBodyType)type{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        _avatarView = [[UIButton alloc]init];
        _avatarView.backgroundColor = [UIColor grayColor];
        _avatarView.layer.cornerRadius = CELL_AVATAR_SIZE / 2;
        [_avatarView addTarget:self action:@selector(avatarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_avatarView];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_timeLabel];
        
        switch (type) {
            case eMessageBodyType_Text:{
                _bubbleView = [[EM_ChatMessageTextBubble alloc]init];
            }
                break;
            case eMessageBodyType_Image:{
                _bubbleView = [[EM_ChatMessageImageBubble alloc]init];
            }
                break;
            case eMessageBodyType_Video:{
                _bubbleView = [[EM_ChatMessageVideoBubble alloc]init];
            }
                break;
            case eMessageBodyType_Location:{
                _bubbleView = [[EM_ChatMessageLocationBubble alloc]init];
            }
                break;
            case eMessageBodyType_Voice:{
                _bubbleView = [[EM_ChatMessageVoiceBubble alloc]init];
            }
                break;
            case eMessageBodyType_File:{
                _bubbleView = [[EM_ChatMessageFileBubble alloc]init];
            }
                break;
            default:{
                _bubbleView = [[EM_ChatMessageBaseBubble alloc]init];
            }
                break;
        }
        _bubbleView.layer.cornerRadius = 6;
        _bubbleView.layer.masksToBounds = YES;
        _bubbleView.delegate = self;
        [self.contentView addSubview:_bubbleView];
        
        _indicatorView = [[UIActivityIndicatorView alloc]init];
        [self.contentView addSubview:_indicatorView];
        
        _retryButton = [[UIButton alloc]init];
        [_retryButton addTarget:self action:@selector(retryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_retryButton];
        
        _stateLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_stateLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    if (_timeLabel.hidden) {
        _timeLabel.frame = CGRectMake(size.width / 4, CELL_PADDING, size.width / 2, 0);
    }else{
        _timeLabel.frame = CGRectMake(size.width / 4, CELL_PADDING, size.width / 2, CELL_TIME_HEIGHT);
    }
    
    CGFloat _originY = _timeLabel.frame.origin.y + _timeLabel.frame.size.height;
    
    CGFloat _nameLabelOriginX = CELL_AVATAR_SIZE + CELL_PADDING;
    if (_nameLabel.hidden) {
        _nameLabel.frame = CGRectMake(_nameLabelOriginX, _originY, size.width - _nameLabelOriginX * 2, 0);
    }else{
        _nameLabel.frame = CGRectMake(_nameLabelOriginX, _originY, size.width - _nameLabelOriginX * 2, CELL_NAME_HEIGHT);
    }

    CGFloat _bubbleViewOriginY = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
    CGFloat _indicatorViewPadding = (CELL_AVATAR_SIZE + CELL_PADDING - CELL_INDICATOR_SIZE) / 2;
    CGFloat _indicatorViewOriginY = _bubbleView.frame.origin.y + (_bubbleView.frame.size.height - CELL_INDICATOR_SIZE) / 2;
    
    if(_message.sender){
        _avatarView.frame = CGRectMake(size.width - CELL_AVATAR_SIZE - CELL_PADDING, _originY, CELL_AVATAR_SIZE, CELL_AVATAR_SIZE);
        _bubbleView.frame = CGRectMake(_avatarView.frame.origin.x - _message.bubbleSize.width, _bubbleViewOriginY, _message.bubbleSize.width, _message.bubbleSize.height);
        
        _indicatorView.frame = CGRectMake(_bubbleView.frame.origin.x - _indicatorViewPadding - CELL_INDICATOR_SIZE, _indicatorViewOriginY, CELL_INDICATOR_SIZE, CELL_INDICATOR_SIZE);
    }else{
        _avatarView.frame = CGRectMake(CELL_PADDING, _originY, CELL_AVATAR_SIZE, CELL_AVATAR_SIZE);
        _bubbleView.frame = CGRectMake(_avatarView.frame.origin.x + _avatarView.frame.size.width, _bubbleViewOriginY, _message.bubbleSize.width, _message.bubbleSize.height);
        
        _indicatorView.frame = CGRectMake(_bubbleView.frame.origin.x + _bubbleView.frame.size.width + _indicatorViewPadding, _indicatorViewOriginY, CELL_INDICATOR_SIZE, CELL_INDICATOR_SIZE);
    }
    _retryButton.frame =_indicatorView.frame;
    _stateLabel.frame = _indicatorView.frame;
}

- (void)avatarClicked:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:didTapAvatarWithChatter:indexPath:)]) {
        [_delegate chatMessageCell:self didTapAvatarWithChatter:self.message.message.from indexPath:self.indexPath];
    }
}

- (void)retryClicked:(id)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:resendMessageWithMessage:indexPath:)]) {
        [_delegate chatMessageCell:self resendMessageWithMessage:self.message indexPath:self.indexPath];
    }
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    _message = message;
    
    _nameLabel.text = message.nickName;
    _nameLabel.hidden = message.messageType == eMessageTypeChat;
    
    if (_message.sender) {
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _bubbleView.backgroundColor = [UIColor colorWithHEX:@"#EED2EE" alpha:1.0];
    }else{
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _bubbleView.backgroundColor = [UIColor colorWithHEX:@"#B5B5B5" alpha:1.0];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%ld",message.timestamp];
    _timeLabel.hidden = !_message.showTime;
    
    _bubbleView.message = _message;
}

#pragma mark - EM_ChatMessageBubbleDelegate
- (void)bubbleTapWithUserInfo:(NSDictionary *)userInfo{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:didTapMessageWithUserInfo:indexPath:)]) {
        [_delegate chatMessageCell:self didTapMessageWithUserInfo:userInfo indexPath:self.indexPath];
    }
}

- (void)bubbleLongPressWithUserInfo:(NSDictionary *)userInfo{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:didLongPressMessageWithUserInfo:indexPath:)]) {
        [_delegate chatMessageCell:self didLongPressMessageWithUserInfo:userInfo indexPath:self.indexPath];
    }
}

@end