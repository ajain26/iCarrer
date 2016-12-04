//
//  BoardRoomCell.m
//  iCareer
//
//  Created by Hitesh on 12/4/16.
//  Copyright © 2016 Hitesh Kumar Singh. All rights reserved.
//

#import "BoardRoomCell.h"

@implementation BoardRoomCell
-(void)setDate:(NSString *)dateStr{
    NSString *finalDate = @"";
    if (![dateStr isKindOfClass:[NSNull class]] && dateStr) {
        NSArray *dateArray = [dateStr componentsSeparatedByString:@" "];
        if (dateArray.count > 0) {
            NSArray *date = [[dateArray objectAtIndex:0] componentsSeparatedByString:@"-"];
            if (date.count == 3) {
                int y = [[date objectAtIndex:0] intValue];
                int m = [[date objectAtIndex:1] intValue];
                int d = [[date objectAtIndex:2] intValue];
                finalDate = [NSString stringWithFormat:@"%@ %d, %d",[self getMonth:m], d, y];
            }
        }
    }
    self.dateLabel.text = finalDate;
}
-(NSString*)getMonth:(int)m{
    NSString *month = @"";
    NSArray *monthsArray = [[NSArray alloc] initWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    month = [monthsArray objectAtIndex:m-1];
    return month;
}
@end
