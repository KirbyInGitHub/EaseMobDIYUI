//
//  EM+ConversationCell.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/25.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ConversationCell.h"
#import "EM+ChatResourcesUtils.h"
#import "EM+Common.h"
#import "UIColor+Hex.h"

@implementation EM_ConversationCell{
    UILabel *_timeLabel;
    UIView *_topLineView;
    UIView *_bottomLineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.imageView.layer.masksToBounds = YES;
        
        self.rightUtilityButtons = [self rightButtons];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_timeLabel];
        
        _topLineView = [[UIView alloc]init];
        _topLineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:_topLineView];
        
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = [UIColor colorWithHEX:LINE_COLOR alpha:1.0];
        [self.contentView addSubview:_bottomLineView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _timeLabel.center = CGPointMake(size.width - _timeLabel.frame.size.width / 2 - 5, self.textLabel.center.y);

    self.imageView.frame = CGRectMake(LEFT_PADDING, TOP_PADDING, size.height - TOP_PADDING * 2, size.height - TOP_PADDING * 2);
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + COMMON_PADDING;
    textFrame.size.width = _timeLabel.frame.origin.x - textFrame.origin.x;
    self.textLabel.frame = textFrame;
    
    CGRect detailFrame = self.detailTextLabel.frame;
    detailFrame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width + COMMON_PADDING;
    detailFrame.size.width = _timeLabel.frame.origin.x - detailFrame.origin.x;
    self.detailTextLabel.frame = detailFrame;
    
    _topLineView.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width, 0, size.width, LINE_HEIGHT);
    
    _topLineView.frame = CGRectMake(self.imageView.frame.origin.x, size.height - LINE_HEIGHT, size.width, LINE_HEIGHT);
}

- (NSArray *)rightButtons{
    NSMutableArray *rightUtilityButtons = [[NSMutableArray alloc]init];
    //[rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:[EM_ChatResourcesUtils stringWithName:@"common.delete"]];
    return rightUtilityButtons;
}

- (void)setTime:(NSString *)time{
    _time = time;
    _timeLabel.text = _time;
    [_timeLabel sizeToFit];
}

- (void)setHiddenTopLine:(BOOL)hiddenTopLine{
    _hiddenTopLine = hiddenTopLine;
    _topLineView.hidden = _hiddenTopLine;
}

- (void)setHiddenBottomLine:(BOOL)hiddenBottomLine{
    _hiddenBottomLine = hiddenBottomLine;
    _bottomLineView.hidden = _hiddenBottomLine;
}

@end