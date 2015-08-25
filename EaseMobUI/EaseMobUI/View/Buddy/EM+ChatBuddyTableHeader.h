//
//  EM+ChatBuddyTableHeader.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EM_ChatBuddyTagModel;

@protocol EM_ChatBuddyTableHeaderDelegate;

@interface EM_ChatBuddyTableHeader : UIView

@property (nonatomic, strong, readonly) UISearchBar *searchBar;
@property (nonatomic, weak) id<EM_ChatBuddyTableHeaderDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame  tags:(NSArray *)tags;

@end

@protocol EM_ChatBuddyTableHeaderDelegate <NSObject>

@required
@optional

- (void)didSelectedWithBuddyTag:(EM_ChatBuddyTagModel *)tag;

@end