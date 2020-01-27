//
//  PTDateManager.m
//  Friendly
//
//  Created by Sergey Borichev on 20.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRDateManager.h"

@implementation FRDateManager


+ (NSString*)dateStringForServerFromDate:(NSDate*)date
{
    
    return [self dateStringFromDate:date withFormat:@"YYYY-MM-dd"];
}

+ (NSString*)dateStringFromDate:(NSDate*)date withFormat:(NSString*)formatStr
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:formatStr];
    
    return [format stringFromDate:date];
}

+ (NSString*)eventStartStringFromDate:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    [self toGlobalTime:date];
    return [format stringFromDate:date];
}

+ (NSDate*)dateFromMessageCreateDateString:(NSString*)dateString
{
    dateString = [NSString stringWithFormat:@"%@+0000", dateString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    
    NSDate *currentDate = [dateFormatter dateFromString:dateString];
    
    
   
    
    return  currentDate;//[self dateFromString:dateString format:@"yyyy-MM-dd'T'HH:mm::ss"];
}

+ (NSDate*)dateFromServerWithString:(NSString*)dateString
{
    return [self dateFromString:dateString format:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];//"yyyy-MM-dd'T'HH:mm:ssZZZZ"
}

+ (NSInteger)userYearFromBirthday:(NSString*)birthdayString
{
    NSDate* fromDate = [self dateFromBirthdayFormat:birthdayString];
    return [self userYearFromBirthdayDate:fromDate];
}

+ (NSInteger)userYearFromBirthdayDate:(NSDate*)date
{
    NSDateComponents* components = [self componentFromDate:date toDate:[NSDate date]];
    return components.year;
}


+ (NSDateComponents*)componentFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate
{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                               fromDate:fromDate
                                                 toDate:toDate
                                                options:0];
    
    return components;
}

+ (NSString*)eventStartStringFromDateString:(NSString*)dateString
{
    NSDate* date = [NSDate new];
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"yyyy-dd MMM-h:mm a"];

    date = [format dateFromString:dateString];
    
    if ([[NSDate date] timeIntervalSinceDate:date]>0)
    {
        return @"0";
    }
    
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: date];
    date = [NSDate dateWithTimeInterval: seconds sinceDate: date];
    
     [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
//   if ([[NSDate date] timeIntervalSinceDate:date]>0)
//   {
//       return @"0";
//   }
    NSString* returnString = [format stringFromDate:date];
    return returnString;
}

+ (NSString*)timeStringFromServerDateString:(NSString*)dateString
{
    NSDate* date = [self dateFromServerWithString:dateString];
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    date = [NSDate dateWithTimeInterval: seconds sinceDate: date];
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"h:mm a"];
    return [format stringFromDate:date];
}

+ (NSString*)timeStringFromServerDate:(NSDate*)date
{
    
//    NSTimeZone *tz = [NSTimeZone localTimeZone];
//    NSInteger seconds = [tz secondsFromGMTForDate: date];
//    date = [NSDate dateWithTimeInterval: seconds sinceDate: date];
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"h:mm a"];
    return [format stringFromDate:date];
}

+ (NSString*)timeStringToServerDateString:(NSString*)dateString
{
    NSDate* date = [self dateFromServerWithString:dateString];
        NSTimeZone *tz = [NSTimeZone localTimeZone];
        NSInteger seconds = [tz secondsFromGMTForDate: date];
        date = [NSDate dateWithTimeInterval: seconds sinceDate: date];
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"h:mm a"];
    return [format stringFromDate:date];
}


+ (NSString*)dayMonthStringFromServerDateString:(NSString*)dateString
{
    NSDate* date = [self dateFromServerWithString:dateString];
       NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM"];
    return [format stringFromDate:date];
}

+ (NSDate *)dateForCallFromString:(NSString*)dateString
{
    return [self dateFromString:dateString format:@"yyyy-MM-dd' 'HH:mm:ss"];
}

+ (NSDate *)dateFromBirthdayFormat:(NSString*)birthdayString
{
    return [self dateFromString:birthdayString format:@"yyyy-MM-dd"];
}

+ (NSString*)dateForCreateEvent:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd MMM"];
    return [format stringFromDate:date];
}

+ (NSString *)timeForCreateEvent:(NSDate *)date
{
//    NSTimeZone *tz = [NSTimeZone localTimeZone];
//    NSInteger seconds = -[tz secondsFromGMTForDate: date];
//    date = [NSDate dateWithTimeInterval: seconds sinceDate: date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"h:mm a"];
    
    return [format stringFromDate:date];
}

+ (NSDate*)dateFromString:(NSString*)dateString format:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"..."];
    
//    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    
    NSDate *currentDate = [dateFormatter dateFromString:dateString];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
    currentDate = currentDate ? : [dateFormatter dateFromString:dateString];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    currentDate = currentDate ? : [dateFormatter dateFromString:dateString];
    if (dateString)
    {
        currentDate = [self toLocalTime:currentDate];
    }
    return currentDate;
}

+ (NSDate*)date:(NSDate*)date agoMonth:(NSInteger)agoMonth
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:-agoMonth];
    NSDate* oneMonthAgo = [gregorian dateByAddingComponents:offsetComponents toDate:date options:0];
    
    return oneMonthAgo;
}

+ (NSDate*)dateForRemoveEventChat:(NSDate*)eventDate
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-1];
    NSDate* removeDate = [gregorian dateByAddingComponents:offsetComponents toDate:eventDate options:0];
    
    return removeDate;

}


+ (NSDate*)monthAgoFromDate:(NSDate*)date
{
    return [self date:date agoMonth:1];
}

+ (NSString*) currentDateString
{
    return [self dateStringForServerFromDate:[NSDate date]];
}

+ (NSString*)currentDateStringWithFormat:(NSString*)format
{
   
    return [self stringFromDate:[NSDate date] withFormat:format];
}

+ (NSString*)stringFromDate:(NSDate*)date withFormat:(NSString*)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"..."]];
    [dateFormatter setDateFormat:format];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSString*)stringDateFromServerStringDate:(NSString*)dateString
{
    NSDate* date = [self dateFromServerWithString:dateString];
    return [self stringFromDate:date withFormat:@"MMM dd, YYYY"];
}

+ (NSString*)dayOfweekFromString:(NSString*)dateStr
{
    NSDate* date = [self dateFromServerWithString:dateStr];
    return [self dayOfWeek:date];
}

+ (NSString*)dayOfWeek:(NSDate*)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE"];
    NSString* str  = [dateFormat stringFromDate:date];
    
    return str;
}


+ (NSString*)dayOfMonthFromString:(NSString*)dateStr
{
    NSDate* date = [self dateFromServerWithString:dateStr];
    return [self dayOfMonth:date];
}

+ (NSString *)date:(NSDate*)date format:(NSString*)format
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

+ (NSString*)dayOfMonth:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    
    return [NSString stringWithFormat:@"%ld",(long)components.day];
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

static NSInteger const kSecondInMinutes = 60;
static NSInteger const kSecondInAnHours = 3600;
static NSInteger const kSecondInDay = 86400;

+ (NSString*)dateForChatRoomFromDate:(NSDate*)date
{
    if (!date)
    {
        return nil;
    }
    NSLog(@"%@", date);
    NSDate* date1 = [self toLocalTime:[NSDate date]];
    NSDate* date2 = [self toLocalTime:date];
    NSTimeInterval distanceBetweenDates = [date1 timeIntervalSinceDate:date2];
    
    if ([@(distanceBetweenDates)  isEqual: [NSDecimalNumber notANumber]]) {
        return nil;
    }
    
    NSInteger time = 0;
    if (distanceBetweenDates < kSecondInMinutes) {
        return @"Just Now";
    }
    if (distanceBetweenDates < kSecondInAnHours)
    {
        time = distanceBetweenDates / kSecondInMinutes;
        return [NSString stringWithFormat:@"%ldm", (long)time];
    }
    else if (distanceBetweenDates < kSecondInDay)
    {
        time = distanceBetweenDates / kSecondInAnHours;
        return [NSString stringWithFormat:@"%ldh", (long)time];
    }
    else
    {
        time = distanceBetweenDates / kSecondInDay;
        return [NSString stringWithFormat:@"%ldd", (long)time];
    }
}

+ (NSDate *) toLocalTime:(NSDate*)date
{
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    
    NSInteger seconds = [tz secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}


+ (BOOL)isDateEarlierThanToday:(NSString*)dateString
{
    NSDate* date = [self dateFromString:dateString format:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate* today = [NSDate date];
    if (([date compare:today] == NSOrderedSame)||([date compare:today] == NSOrderedAscending))
    {
        return YES;
    }
    else
    {
        return NO;
    }

}

+ (NSString*)groupTime:(NSDate*)date {
    return [self stringFromDate:date withFormat:@"EEEE dd'th', YYYY"];
}

+ (NSDate*)dateForCurrenTimeZoneFromDate:(NSDate*)currentDate {
    
    NSTimeZone* currentTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* nowTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:currentDate];
    NSInteger nowGMTOffset = [nowTimeZone secondsFromGMTForDate:currentDate];
    
    NSTimeInterval interval = nowGMTOffset - currentGMTOffset;
    NSDate* nowDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:currentDate];
    return nowDate;
}

+ (NSDate*)getThisWeek {
    
    return [self getSunday];
}

+ (NSArray*)getThisWeekend {
    
    NSDate *second = [self getSunday];
    
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setDay:-2];
    
    NSDate* first = [gregorian dateByAddingComponents:offsetComponents toDate:second options:0];
        
    return @[first, second];
}


+ (NSDate*)getSunday {
    
    NSDate *now = [NSDate date];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitHour fromDate:now];
    NSInteger weekday = [dateComponents weekday];
    
    NSDate *nextSunday = nil;
    if (weekday == 1 && [dateComponents hour] < 5) {
        // The next day is today
        nextSunday = now;
    }
    else  {
        NSInteger daysTillNextSunday = 8 - weekday;
        int secondsInDay = 86400; // 24 * 60 * 60
        nextSunday = [now dateByAddingTimeInterval:secondsInDay * daysTillNextSunday];
    }
    
    
    NSDate *date = nextSunday;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: date];
    [components setHour: 23];
    [components setMinute: 59];
    [components setSecond: 59];
    
   return [gregorian dateFromComponents: components];

}


+(NSDate*) toGlobalTime:(NSDate*)date
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}

@end
