//
//  MyDateType.h
//  TestProject
//
//  Created by 袁静 on 15/7/27.
//  Copyright (c) 2015年 yjing. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef enum mydateState{
//    date_today=0, //今天日期格式  04:00
//    date_last_day=1,//昨天日期格式 昨天 04:00
//    date_this_week=2,//本周日期格式 星期一 04:00
//    date_this_year=3,//本年日期格式 07-27 04:00
//    date_last_year=4,//前年日期格式 2014-7-27 04:00
//    
//}mydateState;

@interface EM_ChatDateUtils : NSObject

+ (NSString *)stringMessageDate:(int64_t)ndate;

@end