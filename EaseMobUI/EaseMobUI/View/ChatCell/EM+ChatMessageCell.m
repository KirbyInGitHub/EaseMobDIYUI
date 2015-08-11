//
//  EM+ChatMessageBaseCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/16.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "UIColor+Hex.h"

#import "EM+ChatMessageCell.h"
#import "EM+ChatDataUtils.h"
#import "UIButton+WebCache.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatResourcesUtils.h"

#import "EM+ChatMessageTextBubble.h"
#import "EM+ChatMessageImageBubble.h"
#import "EM+ChatMessageVideoBubble.h"
#import "EM+ChatMessageLocationBubble.h"
#import "EM+ChatMessageVoiceBubble.h"
#import "EM+ChatMessageFileBubble.h"

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

+ (CGFloat)cellBubbleMaxWidth:(CGFloat)cellMaxWidth{
    CGFloat maxBubbleWidth = cellMaxWidth - CELL_PADDING * 2 - CELL_AVATAR_SIZE * 2 - CELL_BUBBLE_TAIL_WIDTH;
    return maxBubbleWidth;
}

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
    CGFloat maxBubbleWidth = [EM_ChatMessageCell cellBubbleMaxWidth:max];
    
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
        _avatarView.layer.cornerRadius = CELL_AVATAR_SIZE / 2;
        _avatarView.layer.masksToBounds = YES;
        [_avatarView setImage:[EM_ChatResourcesUtils cellImageWithName:@"avatar_default"] forState:UIControlStateNormal];
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
        _indicatorView.hidden = YES;
        _indicatorView.bounds = CGRectMake(0, 0, CELL_INDICATOR_SIZE, CELL_INDICATOR_SIZE);
        [self.contentView addSubview:_indicatorView];
        
        _retryButton = [[UIButton alloc]init];
        _retryButton.hidden = YES;
        [_retryButton setTitle:@"!" forState:UIControlStateNormal];
        [_retryButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_retryButton];
        
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.hidden = YES;
        _stateLabel.textColor = [UIColor blackColor];
        _stateLabel.font = [UIFont systemFontOfSize:10];
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
    
    
    CGSize bubbleSize = _message.bubbleSize;
    if (_message.extendShow) {
        if (_message.extendSize.width > bubbleSize.width) {
            bubbleSize.width = _message.extendSize.width;
        }
        bubbleSize.height += (_message.extendSize.height + CELL_BUBBLE_EXTEND_PADDING);
    }
    
    CGFloat centerX;
    
    if(_message.sender){
        _avatarView.frame = CGRectMake(size.width - CELL_AVATAR_SIZE - CELL_PADDING, _originY, CELL_AVATAR_SIZE, CELL_AVATAR_SIZE);
        _bubbleView.frame = CGRectMake(_avatarView.frame.origin.x - bubbleSize.width - CELL_BUBBLE_TAIL_WIDTH, _bubbleViewOriginY, bubbleSize.width, bubbleSize.height);
        
        centerX = _bubbleView.frame.origin.x - CELL_INDICATOR_SIZE / 2 * 3;
    }else{
        _avatarView.frame = CGRectMake(CELL_PADDING, _originY, CELL_AVATAR_SIZE, CELL_AVATAR_SIZE);
        _bubbleView.frame = CGRectMake(_avatarView.frame.origin.x + _avatarView.frame.size.width + CELL_BUBBLE_TAIL_WIDTH, _bubbleViewOriginY, bubbleSize.width, bubbleSize.height);
        centerX = _bubbleView.frame.origin.x + _bubbleView.frame.size.width + CELL_INDICATOR_SIZE / 2 * 3;
    }
    
    _indicatorView.center = CGPointMake(centerX, _bubbleView.frame.origin.y + _bubbleView.frame.size.height / 2);
    _retryButton.frame =_indicatorView.frame;
    
    _stateLabel.center = _indicatorView.center;
    [_stateLabel sizeToFit];
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
    
    if (_message.avatar) {
        [_avatarView sd_setImageWithURL:[[NSURL alloc] initWithString:_message.avatar] forState:UIControlStateNormal];
    }
    
    if (_message.sender) {
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _bubbleView.backgroundColor = [UIColor colorWithHEX:@"#EED2EE" alpha:1.0];
    }else{
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _bubbleView.backgroundColor = [UIColor colorWithHEX:@"#B5B5B5" alpha:1.0];
    }
    
    _timeLabel.text = [EM_ChatDataUtils stringMessageData:message.timestamp / 1000];
    _timeLabel.hidden = !_message.showTime;
    
    if (_message.message.deliveryState == eMessageDeliveryState_Failure
        || _message.message.deliveryState == eMessageDeliveryState_Delivered) {
        if (_indicatorView.isAnimating) {
            [_indicatorView stopAnimating];
        }
        _indicatorView.hidden = YES;
        _retryButton.hidden = _message.message.deliveryState == eMessageDeliveryState_Delivered;
        //_stateLabel.hidden = !(_message.message.deliveryState == eMessageDeliveryState_Delivered && _message.sender);
        if (_message.message.deliveryState == eMessageDeliveryState_Delivered && _message.sender) {
            if (_message.message.isReadAcked) {
                _stateLabel.text = @"已读";
            }else{
                _stateLabel.text = @"已送达";
            }
        }
    }else{
        if (!_indicatorView.isAnimating) {
            [_indicatorView startAnimating];
        }
        _indicatorView.hidden = NO;
    }
    
    _bubbleView.message = _message;
}

- (void)setExtendView:(UIView *)extendView{
    _bubbleView.extendView = extendView;
}

- (UIView *)extendView{
    return _bubbleView.extendView;
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

- (void)bubbleMenuAction:(EM_MENU_ACTION)action{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:didMenuSelectedWithAction:message:indexPath:)]) {
        [_delegate chatMessageCell:self didMenuSelectedWithAction:action message:self.message indexPath:self.indexPath];
    }
}

@end