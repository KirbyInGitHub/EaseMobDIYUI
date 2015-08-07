//
//  EM+ChatMessageLocationBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageLocationBubble.h"
#import "EM+ChatUIConfig.h"
#import "EM+ChatMessageModel.h"
#import "EM+ChatResourcesUtils.h"

@implementation EM_ChatMessageLocationBubble{
    UIImageView *mapView;
    UILabel *addressLabel;
}

+ (CGSize)sizeForBubbleWithMessage:(id)messageBody maxWithd:(CGFloat)max{
    return  CGSizeMake(max / 4 * 3, max / 4 * 3);
}

- (instancetype)init{
    self = [super init];
    if (self) {
        mapView = [[UIImageView alloc]init];
        mapView.image = [EM_ChatResourcesUtils cellImageWithName:@"location_preview"];
        [self addSubview:mapView];
        
        addressLabel = [[UILabel alloc]init];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
        addressLabel.numberOfLines = 0;
        [self addSubview:addressLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    
    mapView.frame = CGRectMake(0, 0, size.width, size.height - self.message.extendSize.height - CELL_BUBBLE_EXTEND_PADDING);
    
    addressLabel.frame = CGRectMake(mapView.frame.origin.x, mapView.frame.origin.y + (mapView.frame.size.height - 44), mapView.frame.size.width , 44);
    
    if (self.extendView) {
        self.extendView.center = CGPointMake(size.width / 2, size.height - self.message.extendSize.height / 2);
    }
    if (self.extendLine) {
        self.extendLine.frame = CGRectMake(0, self.extendView.frame.origin.y + CELL_BUBBLE_EXTEND_PADDING, size.width, CELL_BUBBLE_EXTEND_PADDING);
    }
}

- (NSString *)handleAction{
    return HANDLE_ACTION_LOCATION;
}

- (void)setMessage:(EM_ChatMessageModel *)message{
    [super setMessage:message];
    
    EMLocationMessageBody *locationBody = (EMLocationMessageBody *)message.messageBody;
    addressLabel.text = locationBody.address;
}

@end