//
//  EM+ChatBuddyTableHeader.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBuddyTableHeader.h"
#import "EM+Common.h"
#import "EM+ChatBuddyTagModel.h"

@implementation EM_ChatBuddyTableHeader{
    UIScrollView *_scroll;
    NSArray *_tags;
}

- (instancetype)initWithFrame:(CGRect)frame tags:(NSArray *)tags{
    self = [super initWithFrame:frame];
    if (self) {
        _tags = tags;
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, IS_PAD ? 60 : 44)];
        [self addSubview:_searchBar];
        
        _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _searchBar.frame.size.height, self.frame.size.width, self.frame.size.height - _searchBar.frame.size.height)];
        _scroll.contentSize = CGSizeMake(_scroll.frame.size.width / 4 * _tags.count, _scroll.frame.size.height);
        [self addSubview:_scroll];
        
        CGFloat tagButtonWidth = _scroll.frame.size.width / 4;
        for (int i = 0; i < _tags.count; i++) {
            EM_ChatBuddyTagModel *tag = _tags[i];
            UIButton *tagButton = [[UIButton alloc]initWithFrame:CGRectMake(i * tagButtonWidth, 0, tagButtonWidth, tagButtonWidth)];
            tagButton.tag = i;
            [tagButton setTitle:tag.title forState:UIControlStateNormal];
            [tagButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tagButton addTarget:self action:@selector(tagClicked:) forControlEvents:UIControlEventTouchUpInside];
            [_scroll addSubview:tagButton];
        }
    }
    return self;
}

- (void)tagClicked:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedWithBuddyTag:)]) {
        EM_ChatBuddyTagModel *tag = _tags[sender.tag];
        [self.delegate didSelectedWithBuddyTag:tag];
    }
}

@end