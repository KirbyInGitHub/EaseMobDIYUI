//
//  EM+MessageBaseView.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/7/3.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBaseView.h"

@implementation EM_ChatBaseView

- (instancetype)init{
    self = [super init];
    if (self) {
        _backgroundView = [[UIImageView alloc]init];
        _backgroundView.backgroundColor = [UIColor colorWithHexRGB:0xF8F8F8];
        self.layer.masksToBounds = YES;
        [self addSubview:_backgroundView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize size = self.frame.size;
    
    _backgroundView.frame= CGRectMake(0, 0, size.width, size.height);
}

- (void)setBackgroundView:(UIView *)backgroundView{
    if (_backgroundView.superview) {
        [_backgroundView removeFromSuperview];
    }
    _backgroundView = backgroundView;
    
    [self insertSubview:_backgroundView atIndex:0];
    [self setNeedsDisplay];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    
    if (![_backgroundView isMemberOfClass:[UIImageView class]]) {
        [_backgroundView removeFromSuperview];
        _backgroundView = [[UIImageView alloc]init];
        [self addSubview:_backgroundView];
    }
    
    UIImageView *imageView = (UIImageView *)_backgroundView;
    imageView.image = _backgroundImage;
    [self setNeedsDisplay];
}

@end