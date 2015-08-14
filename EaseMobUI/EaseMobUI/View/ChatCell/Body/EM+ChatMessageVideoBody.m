//
//  EM+ChatMessageVideoBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageVideoBody.h"
#import "UIImageView+WebCache.h"
#import "EM+ChatMessageModel.h"

#define CELL_VIDEO_PADDING (1)

@implementation EM_ChatMessageVideoBody{
    UIImageView *imageView;
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
    imageView.bounds = self.bounds;
    imageView.center = CGPointMake(size.width / 2, size.height / 2);
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_ACTION_VIDEO forKey:kHandleActionName];
    return userInfo;
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