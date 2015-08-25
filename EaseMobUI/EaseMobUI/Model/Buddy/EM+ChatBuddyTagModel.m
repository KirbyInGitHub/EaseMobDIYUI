//
//  EM+ChatBuddyTagModel.m
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/24.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatBuddyTagModel.h"

@implementation EM_ChatBuddyTagModel

NSString * const kEMChatBuddyTagNameNewBuddy = @"kEMChatBuddyTagNameNewBuddy";
NSString * const kEMChatBuddyTagNameCarefor = @"kEMChatBuddyTagNameCarefor";
NSString * const kEMChatBuddyTagNameGroup = @"kEMChatBuddyTagNameGroup";
NSString * const kEMChatBuddyTagNameBlacklist = @"kEMChatBuddyTagNameBlacklist";

+ (NSArray *)defaultTags{
    NSMutableArray *tags = [[NSMutableArray alloc]init];
    [tags addObject:[EM_ChatBuddyTagModel defaultTagWithNewBuddy]];
    [tags addObject:[EM_ChatBuddyTagModel defaultTagWithCarefor]];
    [tags addObject:[EM_ChatBuddyTagModel defaultTagWithGroup]];
    [tags addObject:[EM_ChatBuddyTagModel defaultTagWithBlacklist]];
    
    return tags;
}

+ (EM_ChatBuddyTagModel *)defaultTagWithNewBuddy{
    EM_ChatBuddyTagModel *tagNewBuddy = [[EM_ChatBuddyTagModel alloc]initWithName:kEMChatBuddyTagNameNewBuddy title:@"新朋友"];
    return tagNewBuddy;
}
+ (EM_ChatBuddyTagModel *)defaultTagWithCarefor{
    EM_ChatBuddyTagModel *tagCarefor = [[EM_ChatBuddyTagModel alloc]initWithName:kEMChatBuddyTagNameCarefor title:@"特别关心"];
    return tagCarefor;
}
+ (EM_ChatBuddyTagModel *)defaultTagWithGroup{
    EM_ChatBuddyTagModel *tagGroup = [[EM_ChatBuddyTagModel alloc]initWithName:kEMChatBuddyTagNameGroup title:@"群组"];
    return tagGroup;
}
+ (EM_ChatBuddyTagModel *)defaultTagWithBlacklist{
    EM_ChatBuddyTagModel *tagBlacklist = [[EM_ChatBuddyTagModel alloc]initWithName:kEMChatBuddyTagNameBlacklist title:@"黑名单"];
    return tagBlacklist;
}

- (instancetype)initWithName:(NSString *)name title:(NSString *)title{
    self = [super init];
    if (self) {
        self.name = name;
        self.title = title;
        self.show = YES;
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    BOOL isEqual = [super isEqual:object];
    if (!isEqual) {
        EM_ChatBuddyTagModel *tag = object;
        isEqual = [tag.name isEqualToString:self.name];
    }
    return isEqual;
}

@end