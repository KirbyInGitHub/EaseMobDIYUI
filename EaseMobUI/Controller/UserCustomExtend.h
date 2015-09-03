//
//  UserCustomExtend.h
//  EaseMobUI
//
//  Created by 周玉震 on 15/8/14.
//  Copyright (c) 2015年 周玉震. All rights reserved.
//

#import "EM+ChatMessageExtend.h"

//key
#define kExtendAttributeKeyExtend           (kExtendAttributeNameExtend)


//name
#define kExtendAttributeNameExtend          (@"extendProperty")

@interface UserCustomExtend : EM_ChatMessageExtend

@property (nonatomic, copy) NSString *extendProperty;

@end