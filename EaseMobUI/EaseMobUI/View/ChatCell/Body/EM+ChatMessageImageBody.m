//
//  EM+ChatMessageImageBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageImageBody.h"
#import "UIImageView+WebCache.h"
#import "EM+ChatMessageModel.h"

#define CELL_IMAGE_PADDING (1)

@implementation EM_ChatMessageImageBody{
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
    [userInfo setObject:HANDLE_ACTION_IMAGE forKey:kHandleActionName];
    return userInfo;
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