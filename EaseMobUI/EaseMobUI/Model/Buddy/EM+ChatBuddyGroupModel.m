//
//  EM+ChatBuddyGroupModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBuddyGroupModel.h"

@implementation EM_ChatBuddyGroupModel

NSString * const kEMChatBuddyGroupSignBuddy = @"kEMChatBuddyGroupSignBuddy";

+ (NSArray *)defaultGroup{
    NSMutableArray *group = [[NSMutableArray alloc]init];
    [group addObject:[[EM_ChatBuddyGroupModel alloc]initWithSign:kEMChatBuddyGroupSignBuddy title:@"我的好友"]];
    return group;
}

- (instancetype)initWithSign:(NSString *)sign title:(NSString *)title{
    self = [super init];
    if (self) {
        self.sign = sign;
        self.title = title;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual) {
        EM_ChatBuddyGroupModel *tag = object;
        isEqual = [tag.sign isEqualToString:self.sign];
    }
    return isEqual;
}

@end