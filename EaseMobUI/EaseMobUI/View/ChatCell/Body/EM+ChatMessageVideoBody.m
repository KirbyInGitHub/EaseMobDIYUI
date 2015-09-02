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
#import "EM+ChatResourcesUtils.h"
#import "EM+ChatFileUtils.h"
#import "EM+ChatMessageUIConfig.h"

#define CELL_VIDEO_PADDING (1)

@implementation EM_ChatMessageVideoBody{
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *sizeLabel;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        imageView = [[UIImageView alloc]init];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
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
    imageView.frame = CGRectMake(self.config.bodyVideoPadding, self.config.bodyVideoPadding, size.height - self.config.bodyVideoPadding * 2, size.height - self.config.bodyVideoPadding * 2);
    nameLabel.frame = CGRectMake(imageView.frame.size.width + 10, self.config.bodyVideoPadding, size.width - imageView.frame.size.width - 10 , size.height / 3 * 2);
    sizeLabel.frame = CGRectMake(imageView.frame.size.width + 10, nameLabel.frame.size.height, (size.width - imageView.frame.size.width - 10) / 2 , size.height / 3);
}

- (NSMutableDictionary *)userInfo{
    NSMutableDictionary *userInfo = [super userInfo];
    [userInfo setObject:HANDLE_ACTION_VIDEO forKey:kHandleActionName];
    return userInfo;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.messageBody;
    
    nameLabel.text = videoBody.displayName;
    sizeLabel.text = [EM_ChatFileUtils stringFileSize:videoBody.fileLength];
    
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