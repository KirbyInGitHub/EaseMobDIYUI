//
//  EM+ChatMessageBaseCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/16.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageCell.h"
#import "UIButton+WebCache.h"
#import "EM+ChatMessageBubble.h"
#import "EM+ChatMessageUIConfig.h"
#import "EM+ChatDateUtils.h"
#import "EM+ChatResourcesUtils.h"

#import "EM+ChatMessageModel.h"

#import "UIColor+Hex.h"

@interface EM_ChatMessageCell()<EM_ChatMessageContentDelegate>

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *avatarView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UIButton *retryButton;
@property (nonatomic,strong) UILabel *stateLabel;

@end

@implementation EM_ChatMessageCell

+ (CGFloat)cellBubbleMaxWidth:(CGFloat)cellMaxWidth config:(EM_ChatMessageUIConfig *)config{
    CGFloat maxBubbleWidth = cellMaxWidth - config.messagePadding * 2 - config.messageAvatarSize * 2 - config.messageTailWithd;
    return maxBubbleWidth;
}

+ (CGFloat)heightForCellWithMessage:(EM_ChatMessageModel *)message  maxWidth:(CGFloat)max indexPath:(NSIndexPath *)indexPath config:(EM_ChatMessageUIConfig *)config{
    CGFloat contentHeight = config.messageTopPadding;
    if (message.extend.showTime) {
        contentHeight += config.messageTimeLabelHeight;
    }
    CGFloat maxBubbleWidth = [EM_ChatMessageCell cellBubbleMaxWidth:max config:config];
    CGSize bubbleSize = [message bubbleSizeFormMaxWidth:maxBubbleWidth config:config];
    
    CGFloat height = bubbleSize.height + ( message.message.messageType == eMessageTypeChat ? 0 : config.messageNameLabelHeight);
    if (height > config.messageAvatarSize) {
        contentHeight += height;
    }else{
        contentHeight += config.messageAvatarSize;
    }
    
    return contentHeight;
}

- (instancetype)initWithBodyClass:(Class)bodyClass extendClass:(Class)extendClass reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        _avatarView = [[UIButton alloc]init];
        _avatarView.layer.masksToBounds = YES;
        [_avatarView setImage:[EM_ChatResourcesUtils cellImageWithName:@"avatar_default"] forState:UIControlStateNormal];
        [_avatarView addTarget:self action:@selector(avatarClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_avatarView];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_timeLabel];
        
        _bubbleView = [[EM_ChatMessageBubble alloc]initWithBodyClass:bodyClass withExtendClass:extendClass];
        _bubbleView.layer.cornerRadius = 6;
        _bubbleView.layer.masksToBounds = YES;
        _bubbleView.bodyView.delegate = self;
        _bubbleView.extendView.delegate = self;
        [self.contentView addSubview:_bubbleView];
        
        _indicatorView = [[UIActivityIndicatorView alloc]init];
        _indicatorView.hidden = YES;
        _indicatorView.bounds = CGRectMake(0, 0, self.config.messageIndicatorSize, self.config.messageIndicatorSize);
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
        _timeLabel.frame = CGRectMake(size.width / 4, self.config.messageTopPadding, size.width / 2, 0);
    }else{
        _timeLabel.frame = CGRectMake(size.width / 4, self.config.messageTopPadding, size.width / 2, self.config.messageTimeLabelHeight);
    }
    
    CGFloat _originY = _timeLabel.frame.origin.y + _timeLabel.frame.size.height;
    
    CGFloat _nameLabelOriginX = self.config.messageAvatarSize + self.config.messageTopPadding;
    if (_nameLabel.hidden) {
        _nameLabel.frame = CGRectMake(_nameLabelOriginX, _originY, size.width - _nameLabelOriginX * 2, 0);
    }else{
        _nameLabel.frame = CGRectMake(_nameLabelOriginX, _originY, size.width - _nameLabelOriginX * 2, self.config.messageNameLabelHeight);
    }

    CGFloat _bubbleViewOriginY = _nameLabel.frame.origin.y + _nameLabel.frame.size.height;
    
    
    CGSize bubbleSize = [_message bubbleSizeFormMaxWidth:[EM_ChatMessageCell cellBubbleMaxWidth:
                                                          size.width config:self.config] config:self.config];
    
    CGFloat centerX;
    
    if(_message.sender){
        _avatarView.frame = CGRectMake(size.width - self.config.messageAvatarSize - self.config.messagePadding, _originY, self.config.messageAvatarSize, self.config.messageAvatarSize);
        _bubbleView.frame = CGRectMake(_avatarView.frame.origin.x - bubbleSize.width - self.config.messageTailWithd, _bubbleViewOriginY, bubbleSize.width, bubbleSize.height);
        
        centerX = _bubbleView.frame.origin.x - self.config.messageIndicatorSize / 2 * 3;
    }else{
        _avatarView.frame = CGRectMake(self.config.messagePadding, _originY, self.config.messageAvatarSize, self.config.messageAvatarSize);
        _bubbleView.frame = CGRectMake(_avatarView.frame.origin.x + _avatarView.frame.size.width + self.config.messageTailWithd, _bubbleViewOriginY, bubbleSize.width, bubbleSize.height);
        centerX = _bubbleView.frame.origin.x + _bubbleView.frame.size.width + self.config.messageIndicatorSize / 2 * 3;
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

- (void)setConfig:(EM_ChatMessageUIConfig *)config{
    _config = config;
    _bubbleView.config = _config;
    if (config.avatarStyle == EM_AVATAR_STYLE_CIRCULAR) {
        _avatarView.layer.cornerRadius = self.config.messageAvatarSize / 2;
    }else{
        _avatarView.layer.cornerRadius = 0;
    }
    
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    _message = message;

    _nameLabel.text = message.nickName;
    _nameLabel.hidden = message.message.messageType == eMessageTypeChat;
    
    if (_message.avatar) {
        [_avatarView sd_setImageWithURL:[[NSURL alloc] initWithString:_message.avatar] forState:UIControlStateNormal];
    }
    
    if (_message.sender) {
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _bubbleView.backgroundView.backgroundColor = [UIColor colorWithHEX:@"#EED2EE" alpha:1.0];
    }else{
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _bubbleView.backgroundView.backgroundColor = [UIColor colorWithHEX:@"#B5B5B5" alpha:1.0];
    }
    _bubbleView.message = _message;
    
    _timeLabel.text = [EM_ChatDateUtils stringFormatterMessageDateFromTimeInterval:message.message.timestamp / 1000];
    _timeLabel.hidden = !_message.extend.showTime;
    
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
}

#pragma mark - EM_ChatMessageContentDelegate
- (void) contentTap:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:didTapWithUserInfo:indexPath:)]) {
        [_delegate chatMessageCell:self didTapWithUserInfo:userInfo indexPath:self.indexPath];
    }
}

- (void) contentLongPress:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:didLongPressWithUserInfo:indexPath:)]) {
        [_delegate chatMessageCell:self didLongPressWithUserInfo:userInfo indexPath:self.indexPath];
    }
}

- (void) contentMenu:(UIView *)content action:(NSString *)action withUserInfo:(NSDictionary *)userInfo{
    if (_delegate && [_delegate respondsToSelector:@selector(chatMessageCell:didMenuSelectedWithUserInfo:indexPath:)]) {
        [_delegate chatMessageCell:self didMenuSelectedWithUserInfo:userInfo indexPath:self.indexPath];
    }
}

@end