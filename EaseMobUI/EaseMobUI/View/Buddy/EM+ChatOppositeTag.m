//
//  EM+ChatOppositeTag.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/26.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatOppositeTag.h"
#import "UIColor+Hex.h"
#import "EM+Common.h"

@implementation EM_ChatOppositeTag{
    UILabel *titleLabel;
    UIButton *iconView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - 35, frame.size.width, 35)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        
        CGFloat size = frame.size.height - titleLabel.frame.size.height;
        
        iconView = [[UIButton alloc]initWithFrame:CGRectMake((frame.size.width - size) / 2, 0, size, size)];
        [iconView setTitleColor:[UIColor colorWithHexRGB:TEXT_NORMAL_COLOR] forState:UIControlStateNormal];
        [iconView setTitleColor:[UIColor colorWithHexRGB:TEXT_SELECT_COLOR] forState:UIControlStateSelected];
        [self.contentView addSubview:iconView];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    titleLabel.text = _title;
}

- (void)setImage:(UIImage *)image{
    _image = image;
    if (!_font) {
        [iconView setImage:_image forState:UIControlStateNormal];
    }
}

- (void)setFont:(UIFont *)font{
    _font = font;
    iconView.titleLabel.font = _font;
    [iconView setImage:nil forState:UIControlStateNormal];
}

- (void)setIcon:(NSString *)icon{
    _icon = icon;
    [iconView setTitle:_icon forState:UIControlStateNormal];
    [iconView setImage:nil forState:UIControlStateNormal];
}

@end