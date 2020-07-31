//
//  UUDateTime.m
//  OCProject
//
//  Created by Pan on 2020/6/10.
//  Copyright © 2020 xyz. All rights reserved.
//

#import "UUDateTime.h"

NSString *const DateHyphenTimeColonFormat     = @"yyyy-MM-dd HH:mm:ss";
NSString *const DateUnderScoreTimeColonFormat = @"yyyy_MM_dd HH:mm:ss";
NSString *const DateSlashTimeColonFormat      = @"yyyy/MM/dd HH:mm:ss";
NSString *const DateHyphenFormat     = @"yyyy-MM-dd";
NSString *const DateUnderScoreFormat = @"yyyy_MM_dd";
NSString *const DateSlashFormat      = @"yyyy/MM/dd";
NSString *const TimeColonFormat      = @"HH:mm:ss";

@implementation UUDateTime

// 设定日期格式
+ (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
//    formatter.locale = [NSLocale currentLocale];
//    formatter.timeZone = [NSTimeZone systemTimeZone];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC-8"]; // 东八区时间
    return formatter;
}

// 当前年-月-日 时:分:秒
+ (NSString *)currentDateAndTime {
    return [self currentDateWithFormat:DateHyphenTimeColonFormat];
}

// 当前年-月-日
+ (NSString *)currentDateOnly {
    return [self currentDateWithFormat:DateHyphenFormat];
}

// 当前时:分:秒
+ (NSString *)currentTimeOnly {
    return [self currentDateWithFormat:TimeColonFormat];
}

// 获取当前格式化的日期
+ (NSString *)currentDateWithFormat:(NSString *)format {
    if (!format) format = DateHyphenTimeColonFormat;
    NSDateFormatter *formatter = [self dateFormatterWithFormat:format];
    return [formatter stringFromDate:[NSDate date]];
}

// 根据格式将字符串转换为时间类
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {
    if (!string || !format) return nil;
    NSDateFormatter *formatter = [self dateFormatterWithFormat:format];
    return [formatter dateFromString:string];
}

// 将输入的时间以特定格式的字符串输出
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    if (!date) return nil;
    if (!format) format = DateHyphenTimeColonFormat;
    NSDateFormatter *formatter = [self dateFormatterWithFormat:format];
    return [formatter stringFromDate:date];
}

// 根据格式将时间间隔字符串转换为时间类
+ (NSString *)stringWithTimeInterval:(NSString *)time withFormat:(NSString *)format {
    if (!time || !format) return nil;
    NSTimeInterval timeInterval = [time longLongValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [self dateFormatterWithFormat:format];
    return [formatter stringFromDate:date];
}

// 将时间与现在对比，说明时间状态
+ (NSString *)timeStateConversionFromDate:(NSDate *)date{
    if (!date) return nil;
    
    NSTimeInterval timeInterval = [date timeIntervalSinceNow];
    BOOL isPrevious = timeInterval < 0;
    NSInteger interval = ABS(timeInterval);
    
    NSString *state = @"";
    if (interval < 60) {
        state = @"现在";
    } else if (interval < 60 * 60) {
        NSInteger minute = interval / 60;
        state = [NSString stringWithFormat:@"%d分钟%@", (int)minute, (isPrevious ? @"前" : @"后")];
    } else if (interval < 60 * 60 * 24) {
        NSInteger hour = interval / (60 * 60);
        state = [NSString stringWithFormat:@"%d小时%@", (int)hour, (isPrevious ? @"前" : @"后")];
    } else if (interval < 60 * 60 * 24 * 7) {
        NSInteger day = interval / (60 * 60 * 24);
        state = [NSString stringWithFormat:@"%d天%@", (int)day, (isPrevious ? @"前" : @"后")];
    } else {
        NSDateFormatter *formatter = [self dateFormatterWithFormat:DateHyphenFormat];
        state = [formatter stringFromDate:date];
    }
    return state;
}

// 将时间与现在对比，说明时间状态(年月日)
+ (NSString *)dateStateConversionFromDate:(NSDate *)date {
    if (!date) return nil;
    NSDateComponents *dateComponents = [self dateComponentsWithDate:date];
    NSDateComponents *todayComponents = [self currentDateComponents];
    
    NSMutableString *state = [[NSMutableString alloc] init];
    NSInteger year = dateComponents.year - todayComponents.year;
    if (year < -2 || year > 2) {
        [state appendFormat:@"%zd年", dateComponents.year];
    } else if (year == -2) {
        [state appendString:@"前年"];
    } else if (year == -1) {
        [state appendString:@"去年"];
    } else if (year == 0) {
        // nothing
    } else if (year == 1) {
        [state appendString:@"明年"];
    } else if (year == 2) {
        [state appendString:@"后年"];
    }
    if (state.length > 0) {
        [state appendFormat:@"%02zd月%02zd日", dateComponents.month, dateComponents.day];
        [state appendFormat:@"%02zd:%02zd:%02zd", dateComponents.hour, dateComponents.minute, dateComponents.second];
        return [state copy];
    }
    
    NSInteger month = dateComponents.month - todayComponents.month;
    if (month != 0) {
        [state appendFormat:@"%02zd月%02zd日", dateComponents.month, dateComponents.day];
        [state appendFormat:@"%02zd:%02zd:%02zd", dateComponents.hour, dateComponents.minute, dateComponents.second];
        return [state copy];
    }
    
    NSInteger day = dateComponents.day - todayComponents.day;
    if (day < -2 || day > 2) {
        [state appendFormat:@"%02zd月%02zd日", dateComponents.month, dateComponents.day];
    } else if (day == -2) {
        [state appendString:@"前天"];
    } else if (day == -1) {
        [state appendString:@"昨天"];
    } else if (day == 0) {
        [state appendString:@"今天"];
    } else if (day == 1) {
        [state appendString:@"明天"];
    } else if (day == 2) {
        [state appendString:@"后天"];
    }
    [state appendFormat:@"%02zd:%02zd:%02zd", dateComponents.hour, dateComponents.minute, dateComponents.second];
    return [state copy];
}

#pragma mark - NSDateComponents

// 当前年
+ (NSInteger)currentYear {
    return [self currentDateComponents].year;
}

// 当前月
+ (NSInteger)currentMonth {
    return [self currentDateComponents].month;
}

// 当前日
+ (NSInteger)currentDay {
    return [self currentDateComponents].day;
}

// 当前周几
+ (NSString *)currentWeekName {
    NSDateComponents *components = [self currentDateComponents];
    return [self weekNameWithDateComponents:components];
}

// 获取当前日历日期组成
+ (NSDateComponents *)currentDateComponents {
    return [self dateComponentsWithDate:[NSDate date]];
}

// 根据给定日期，获取日历日期组成
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date {
    if (!date) return nil;
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |
                          NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:unit fromDate:date];
    return components;
}

// 根据日历组成，转变为周几
+ (NSString *)weekNameWithDateComponents:(NSDateComponents *)components {
    if (!components) return nil;
    NSArray *weeks = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    if (weeks.count > components.weekday - 1) {
        return [weeks objectAtIndex:components.weekday - 1];
    }
    return nil;
}

// 根据日期字符串和格式，转变为周几
+ (NSString *)weekNameFromString:(NSString *)string withFormat:(NSString *)format {
    if (!string || !format) return nil;
    NSDate *date = [self dateFromString:string withFormat:format];
    NSDateComponents *components = [self dateComponentsWithDate:date];
    return [self weekNameWithDateComponents:components];
}


#pragma mark - Timer

+ (void)timerForSecondCountDown:(NSTimeInterval)timeInterval
                         action:(void (^)(NSTimeInterval remainingTime, BOOL *stop))actionBlock
                     completion:(void (^)(void))completionBlock {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);

    __block BOOL isStop = NO;
    __block double interval = ABS(timeInterval);
    dispatch_source_set_event_handler(timer, ^{
        
        if (interval > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (actionBlock) actionBlock(interval, &isStop);
                if (isStop) dispatch_source_cancel(timer);
            });
            interval --;
            
        } else {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) completionBlock();
            });
        }
    });
    dispatch_resume(timer);
}

@end
