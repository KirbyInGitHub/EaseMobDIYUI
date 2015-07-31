//
//  EM+ChatMessageImageBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageImageBubble.h"
#import "UIImageView+WebCache.h"

#define CELL_IMAGE_PADDING (1)

@implementation EM_ChatMessageImageBubble{
    UIImageView *imageView;
}

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody maxWithd:(CGFloat)max{
    EMImageMessageBody *imageBody = messageBody;
    
    CGSize size = imageBody.thumbnailSize;
    if (size.width > max - CELL_IMAGE_PADDING) {
        size.height = (max - CELL_IMAGE_PADDING)/ size.width * size.height;
        size.width = max - CELL_IMAGE_PADDING;
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
    imageView.frame = CGRectMake(CELL_IMAGE_PADDING, CELL_IMAGE_PADDING, size.width - CELL_IMAGE_PADDING * 2, size.height - CELL_IMAGE_PADDING * 2 - self.message.extendSize.height - CELL_BUBBLE_EXTEND_PADDING);
    
    if (self.extendView) {
        self.extendView.center = CGPointMake(size.width / 2, size.height - CELL_IMAGE_PADDING - self.message.extendSize.height / 2);
    }
    if (self.extendLine) {
        self.extendLine.frame = CGRectMake(0, self.extendView.frame.origin.y + CELL_BUBBLE_EXTEND_PADDING, size.width, CELL_BUBBLE_EXTEND_PADDING);
    }
}

- (NSString *)handleAction{
    return HANDLE_ACTION_IMAGE;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMImageMessageBody *imageBody = (EMImageMessageBody *)message.messageBody;
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:imageBody.thumbnailLocalPath];
    if (image) {
        imageView.image = image;
    }else{
        if (imageBody.thumbnailRemotePath) {
            [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:imageBody.thumbnailRemotePath] placeholderImage:nil options:SDWebImageRetryFailed
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