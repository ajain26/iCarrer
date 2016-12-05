//
//  NewsRoomCell.m
//  iCareer
//
//  Created by Hitesh on 12/4/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "NewsRoomCell.h"

@implementation NewsRoomCell

-(void)assignTime:(NSString*)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate *date = [dateFormatter dateFromString:time];
    NSLog(@"%@",date);
    /*NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [date dateByAddingTimeInterval:timeZoneSeconds];
    NSLog(@"%@",dateInLocalTimezone);*/
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *years = [gregorianCalendar components:NSCalendarUnitYear fromDate:date toDate:[NSDate date] options:0];
    NSDateComponents *months = [gregorianCalendar components:NSCalendarUnitMonth fromDate:date toDate:[NSDate date] options:0];
    NSDateComponents *days = [gregorianCalendar components:NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:0];
    NSDateComponents *hours = [gregorianCalendar components:NSCalendarUnitHour fromDate:date toDate:[NSDate date] options:0];
    NSDateComponents *min = [gregorianCalendar components:NSCalendarUnitMinute fromDate:date toDate:[NSDate date] options:0];
    NSString *setTime = @"";
    if (years.year > 0) {
        if (years.year < 2) {
            setTime = [NSString stringWithFormat:@"%ld year ago",(long)years.year];
        } else {
            setTime = [NSString stringWithFormat:@"%ld years ago",(long)years.year];
        }
    } else if (months.month > 0) {
        if (months.month < 2) {
            setTime = [NSString stringWithFormat:@"%ld month ago",(long)months.month];
        } else {
            setTime = [NSString stringWithFormat:@"%ld months ago",(long)months.month];
        }
    } else if (days.day > 0) {
        if (days.day < 2) {
            setTime = [NSString stringWithFormat:@"%ld day ago",(long)days.day];
        } else {
            setTime = [NSString stringWithFormat:@"%ld days ago",(long)days.day];
        }
    } else if (hours.hour > 0) {
        if (hours.hour < 2) {
            setTime = [NSString stringWithFormat:@"%ld hour ago",(long)hours.hour];
        } else {
            setTime = [NSString stringWithFormat:@"%ld hours ago",(long)hours.hour];
        }
    } else if (min.minute > 0) {
        if (min.minute < 2) {
            setTime = [NSString stringWithFormat:@"%ld minute ago",(long)min.minute];
        } else {
            setTime = [NSString stringWithFormat:@"%ld minutes ago",(long)min.minute];
        }
    }
    self.timeLabel.text = setTime;
}

@end
