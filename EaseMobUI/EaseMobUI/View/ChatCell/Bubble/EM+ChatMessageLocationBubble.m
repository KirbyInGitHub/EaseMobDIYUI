//
//  EM+ChatMessageLocationBubble.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/21.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageLocationBubble.h"
#import "EM+ChatUIConfig.h"

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
        mapView.image = [UIImage imageNamed:RES_IMAGE_CELL(@"location_preview")];
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
    
    mapView.frame = CGRectMake(0, 0, size.width, size.height);
    
    addressLabel.frame = CGRectMake(0, size.height - 50, size.width , 50 );
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