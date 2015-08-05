//
//  EM+ChatMessageVideoBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageVideoBubble.h"
#import "UIImageView+WebCache.h"
#import "EM+ChatMessageModel.h"

#define CELL_VIDEO_PADDING (1)

@implementation EM_ChatMessageVideoBubble{
    UIImageView *imageView;
}

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody maxWithd:(CGFloat)max{
    EMVideoMessageBody *videoBody = messageBody;
    CGSize size = videoBody.size;
    if (size.width > max - CELL_VIDEO_PADDING) {
        size.height = (max - CELL_VIDEO_PADDING)/ size.width * size.height;
        size.width = max - CELL_VIDEO_PADDING;
    }
    return size;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    imageView.frame = CGRectMake(CELL_VIDEO_PADDING, CELL_VIDEO_PADDING, size.width - CELL_VIDEO_PADDING * 2, size.height - CELL_VIDEO_PADDING * 2 - self.message.extendSize.height - CELL_BUBBLE_EXTEND_PADDING);
    
    if (self.extendView) {
        self.extendView.center = CGPointMake(size.width / 2, size.height - CELL_VIDEO_PADDING - self.message.extendSize.height / 2);
    }
    if (self.extendLine) {
        self.extendLine.frame = CGRectMake(0, self.extendView.frame.origin.y + CELL_BUBBLE_EXTEND_PADDING, size.width, CELL_BUBBLE_EXTEND_PADDING);
    }
}

- (NSString *)handleAction{
    return HANDLE_ACTION_VIDEO;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.messageBody;
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:videoBody.thumbnailLocalPath];
    if (image) {
        imageView.image = image;
    }else{
        if (videoBody.thumbnailRemotePath) {
            [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:videoBody.thumbnailRemotePath] placeholderImage:nil options:SDWebImageRetryFailed
             | SDWebImageLowPriority
             | SDWebImageProgressiveDownload
             | SDWebImageRefreshCached
             | SDWebImageHighPriority
             | SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                 
             } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                 
             }];
        }
    }
}
@end