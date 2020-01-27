//
//  PTDateManager.h
//  Friendly
//
//  Created by Sergey Borichev on 20.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRDateManager : NSObject

+ (NSDate *)monthAgoFromDate:(NSDate*)date;
+ (NSString*)dateStringFromDate:(NSDate*)date withFormat:(NSString*)formatStr;
+ (NSDate *)date:(NSDate*)date agoMonth:(NSInteger)agoMonth;
+ (NSDate *)dateFromServerWithString:(NSString*)dateString; // @"yyyy-MM-dd'T'HH:mm:ssZZZZ"
+ (NSDate *)dateForCallFromString:(NSString*)dateString; // @"yyyy-MM-dd' 'HH:mm:ss"
+ (NSDate *)dateFromBirthdayFormat:(NSString*)birthdayString; // @"yyyy-MM-dd"

+ (NSDate*)dateForRemoveEventChat:(NSDate*)eventDate;
+ (NSDateComponents*)componentFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;
+ (NSInteger)userYearFromBirthday:(NSString*)birthdayString;

+ (NSString*)eventStartStringFromDate:(NSDate*)date;
+ (NSString *)date:(NSDate*)date format:(NSString*)format;
+ (NSString *)dayMonthStringFromServerDateString:(NSString*)dateString;
+ (NSString*)timeStringToServerDateString:(NSString*)dateString;
+ (NSString *)timeStringFromServerDateString:(NSString*)dateString;
+ (NSString *)currentDateString;
+ (NSString *)currentDateStringWithFormat:(NSString*)format;
+ (NSString *)dateStringForServerFromDate:(NSDate*)date;
+ (NSString *)stringFromDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSString *)stringDateFromServerStringDate:(NSString*)dateString;
+ (NSDate*)dateFromMessageCreateDateString:(NSString*)dateString;
+ (BOOL)isDateEarlierThanToday:(NSString*)dateString;
+ (NSString*)dayOfWeek:(NSDate*)date;
+ (NSString*)dayOfMonth:(NSDate*)date;

+ (NSInteger)userYearFromBirthdayDate:(NSDate*)date;
+ (NSString*)timeStringFromServerDate:(NSDate*)date;

+ (NSString *)eventStartStringFromDateString:(NSString*)dateString;
+ (NSString *)dateForCreateEvent:(NSDate*)date;
+ (NSString *)timeForCreateEvent:(NSDate*)date;

+ (NSString *)dayOfweekFromString:(NSString*)dateStr;
+ (NSString *)dayOfMonthFromString:(NSString*)dateStr;

+ (BOOL)date:(NSDate *)date isBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate;
+ (BOOL)isSameDayWithDate1:(NSDate *)date1 date2:(NSDate *)date2;

+ (NSString*)dateForChatRoomFromDate:(NSDate*)date;
+ (NSString*)groupTime:(NSDate*)date;

+ (NSDate*)getThisWeek;
+ (NSArray*)getThisWeekend;

+ (NSDate*)getSunday;
+ (NSDate*)toGlobalTime:(NSDate*)date;
+ (NSDate*)toLocalTime:(NSDate*)date;

@end
