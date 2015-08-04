//
//  MyDateType.m
//  TestProject
//
//  Created by 袁静 on 15/7/27.
//  Copyright (c) 2015年 yjing. All rights reserved.
//

#import "EM+ChatDataUtils.h"

@implementation EM_ChatDataUtils

+ (NSString *)stringMessageData:(int64_t)ndate
{
    NSString * mydateStr;
    //当前时间
    int64_t curtime = [[NSDate date] timeIntervalSince1970];
    NSString * curtimeStr=[self convertInt64FormatterToNSString1:curtime];
    //获取的时间
    NSString * temptimeStr=[self convertInt64FormatterToNSString1:ndate];
    
    /**********************************************************************/
    NSString * curYearStr=[self getMyYear:curtimeStr];
    NSString * tempYearStr=[self getMyYear:temptimeStr];
    
    NSString * curMonthStr=[self getMyMonth:curtimeStr];
    NSString * tempMonthStr=[self getMyMonth:temptimeStr];
    
    NSString * curDayStr=[self getMyDay:curtimeStr];
    NSString * tempDayStr=[self getMyDay:temptimeStr];
    
    
    if([curYearStr intValue]>[tempYearStr intValue]){
        //如果是去年，返回时间
        mydateStr=[self convertInt64FormatterToNSString2:ndate];
        return mydateStr;
    }
    /**********************************************************************/
    if([curYearStr intValue]==[tempYearStr intValue]){
        //如果是本年
        if([curMonthStr intValue]==[tempMonthStr intValue]){
            //如果是本月
            if([curDayStr intValue]==[tempDayStr intValue]){
                //如果是当天
                mydateStr=[self convertInt64FormatterToNSString6:ndate];
                return mydateStr;
            }else if ([curDayStr intValue]==[tempDayStr intValue]+1){
                //如果是昨天
                mydateStr=[NSString stringWithFormat:@"昨天 %@",[self convertInt64FormatterToNSString6:ndate]];
                return mydateStr;
            }else{
                //如果是之前很多天
                NSDate * tempDate=[self convertNSStringFormatter:[self convertInt64FormatterToNSString1:ndate]];
                BOOL isThisWeek=[self isDateThisWeek:tempDate];
                if(isThisWeek){
                    //如果是本周
                    mydateStr=[NSString stringWithFormat:@"%@ %@",[self convertWeekStrFormatterToNSString7:ndate],[self convertInt64FormatterToNSString6:ndate]];
                    return mydateStr;
                }else{
                    //如果不是本周
                    mydateStr=[NSString stringWithFormat:@"%@",[self convertInt64FormatterToNSString3:ndate]];
                    return mydateStr;
                }
                
            }
        }else{
            //如果不是本月
            mydateStr=[self convertInt64FormatterToNSString3:ndate];
            return mydateStr;
        }
        
        /**********************************************************************/
    }else{
        //如果是未来某天，O(∩_∩)O哈哈~，才怪
        return @"";
    }
    
    return @"";
}

/**
 *时间字符串转nsdate
 */
+ (NSDate *)convertNSStringFormatter:(NSString *)dateString
{
    if (!dateString) {return nil;}
    static NSDateFormatter *dateFormatter;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale systemLocale]];
    }
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *retDate = [dateFormatter dateFromString:dateString];
    return retDate;
}
/**
 *nsdate转时间字符串
 */
+ (NSString *)convertNSDateFormatter:(NSDate *)date
{
    if (!date) {return nil;}
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *retString = [NSString stringWithString:[dateFormatter stringFromDate:date]];
    return retString;
}
/**
 *时间字符串转x年x月x日
 */
+ (NSString *)convertNSStringFormatterToNSString:(NSString *)dateString
{
    NSArray *date_str1 = [dateString componentsSeparatedByString:@" "];
    NSArray *date_str2 = [(NSString *)[date_str1 objectAtIndex:0] componentsSeparatedByString:@"-"];
    
    NSString *retString = [NSString stringWithFormat:@"%@年%@月%@日", [date_str2 objectAtIndex:0], [date_str2 objectAtIndex:1], [date_str2 objectAtIndex:2]];
    return retString;
}
/**
 *获取时间字符串中的时分秒部分
 */
+ (NSString *)convertNSStringFormatterToNSString2:(NSString *)dateString
{
    NSArray *date_str1 = [dateString componentsSeparatedByString:@" "];
    NSString *date_str2 = (NSString *)[date_str1 objectAtIndex:1];
    return date_str2;
}
/**
 *获取时间字符串的年
 */
+ (NSString *)getMyYear:(NSString *)dateString
{
    NSArray *date_str1 = [dateString componentsSeparatedByString:@" "];
    NSArray *date_str2 = [(NSString *)[date_str1 objectAtIndex:0] componentsSeparatedByString:@"-"];
    return [date_str2 objectAtIndex:0];
}
/**
 *获取时间字符串的月
 */
+ (NSString *)getMyMonth:(NSString *)dateString
{
    NSArray *date_str1 = [dateString componentsSeparatedByString:@" "];
    NSArray *date_str2 = [(NSString *)[date_str1 objectAtIndex:0] componentsSeparatedByString:@"-"];
    return [date_str2 objectAtIndex:1];
}
/**
 *获取时间字符串的日
 */
+ (NSString *)getMyDay:(NSString *)dateString
{
    NSArray *date_str1 = [dateString componentsSeparatedByString:@" "];
    NSArray *date_str2 = [(NSString *)[date_str1 objectAtIndex:0] componentsSeparatedByString:@"-"];
    return [date_str2 objectAtIndex:2];
}
/**
 *获取时间字符串的时
 */
+ (NSString *)getMyHour:(NSString *)dateString
{
    NSArray *date_str1 = [dateString componentsSeparatedByString:@" "];
    NSArray *date_str2 = [(NSString *)[date_str1 objectAtIndex:1] componentsSeparatedByString:@"-"];
    return [date_str2 objectAtIndex:0];
}
/**
 *获取时间字符串的分
 */
+ (NSString *)getMyMinute:(NSString *)dateString
{
    NSArray *date_str1 = [dateString componentsSeparatedByString:@" "];
    NSArray *date_str2 = [(NSString *)[date_str1 objectAtIndex:1] componentsSeparatedByString:@"-"];
    return [date_str2 objectAtIndex:1];
}
/**
 *据时间戳获取完整的时间字符串
 */
+ (NSString*)convertInt64FormatterToNSString1:(int64_t)tt
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:tt];
    return  [dateFormatter stringFromDate:date];
}
/**
 *据时间戳获取除秒的时间字符串
 */
+ (NSString*)convertInt64FormatterToNSString2:(int64_t)tt
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:tt];
    return  [dateFormatter stringFromDate:date];
}
/**
 *据时间戳获取除年、秒的时间字符串
 */
+ (NSString*)convertInt64FormatterToNSString3:(int64_t)tt
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:tt];
    return  [dateFormatter stringFromDate:date];
}
/**
 *据时间戳获取年月日的时间字符串
 */
+ (NSString*)convertInt64FormatterToNSString4:(int64_t)tt
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:tt];
    return  [dateFormatter stringFromDate:date];
}
/**
 *据时间戳获取月日的时间字符串
 */
+ (NSString*)convertInt64FormatterToNSString5:(int64_t)tt
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:tt];
    return  [dateFormatter stringFromDate:date];
}
/**
 *据时间戳获取时分的时间字符串
 */
+ (NSString*)convertInt64FormatterToNSString6:(int64_t)tt
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:tt];
    return  [dateFormatter stringFromDate:date];
}
/**
 *据时间戳获取日期
 */
+ (NSString *)convertWeekStrFormatterToNSString7:(int64_t)tt
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    NSInteger week = [comps weekday];
    
    NSString * weekStr;
    if(week==1){
        weekStr=@"星期天";
    }else if (week==2){
        weekStr=@"星期一";
    }else if (week==3){
        weekStr=@"星期二";
    }else if (week==4){
        weekStr=@"星期三";
    }else if (week==5){
        weekStr=@"星期四";
    }else if (week==6){
        weekStr=@"星期五";
    }else if (week==7){
        weekStr=@"星期六";
    }
    
    return weekStr;
}
/**
 *判断一个日期是否在当前一周内
 */
+ (BOOL)isDateThisWeek:(NSDate *)date {
    
    NSDate *start;
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSWeekCalendarUnit startDate:&start interval: &extends forDate:today];
    
    if(!success)
        return NO;
    
    NSTimeInterval dateInSecs = [date timeIntervalSinceReferenceDate];
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
        return YES;
    }else {
        return NO;
    }
}

@end