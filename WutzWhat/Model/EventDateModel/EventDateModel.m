//
//  EventDateModel.m
//  WutzWhat
//
//  Created by iPhone Development on 3/16/13.
//
//

#import "EventDateModel.h"

@implementation EventDateModel

@synthesize mondayEndTime, mondayStartTime, tuesdayEndTime, tuesdayStartTime, wednesdayEndTime, wednesdayStartTime, thursdayEndTime, thursdayStartTime, fridayEndTime, fridayStartTime, saturdayEndTime, saturdayStartTime, sundayEndTime, sundayStartTime;


-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.mondayEndTime = [self isValueExist:[dict objectForKey:@"monday_close_time"]] ? [dict objectForKey:@"monday_close_time"] : @"";
    self.mondayStartTime = [self isValueExist:[dict objectForKey:@"monday_open_time"]] ? [dict objectForKey:@"monday_open_time"] : @"";
    
    self.tuesdayEndTime = [self isValueExist:[dict objectForKey:@"tuesday_close_time"]] ? [dict objectForKey:@"tuesday_close_time"] : @"";
    self.tuesdayStartTime = [self isValueExist:[dict objectForKey:@"tuesday_open_time"]] ? [dict objectForKey:@"tuesday_open_time"] : @"";
    
    self.wednesdayEndTime = [self isValueExist:[dict objectForKey:@"wednesday_close_time"]] ? [dict objectForKey:@"wednesday_close_time"] : @"";
    self.wednesdayStartTime = [self isValueExist:[dict objectForKey:@"wednesday_open_time"]] ? [dict objectForKey:@"wednesday_open_time"] : @"";
    
    self.thursdayEndTime = [self isValueExist:[dict objectForKey:@"thursday_close_time"]] ? [dict objectForKey:@"thursday_close_time"] : @"";
    self.thursdayStartTime = [self isValueExist:[dict objectForKey:@"thursday_open_time"]] ? [dict objectForKey:@"thursday_open_time"] : @"";
    
    self.fridayEndTime = [self isValueExist:[dict objectForKey:@"friday_close_time"]] ? [dict objectForKey:@"friday_close_time"] : @"";
    self.fridayStartTime = [self isValueExist:[dict objectForKey:@"friday_open_time"]] ? [dict objectForKey:@"friday_open_time"] : @"";
    
    self.saturdayEndTime = [self isValueExist:[dict objectForKey:@"saturday_close_time"]] ? [dict objectForKey:@"saturday_close_time"] : @"";
    self.saturdayStartTime = [self isValueExist:[dict objectForKey:@"saturday_open_time"]] ? [dict objectForKey:@"saturday_open_time"] : @"";
    
    self.sundayEndTime = [self isValueExist:[dict objectForKey:@"sunday_close_time"]] ? [dict objectForKey:@"sunday_close_time"] : @"";
    self.sundayStartTime = [self isValueExist:[dict objectForKey:@"sunday_open_time"]] ? [dict objectForKey:@"sunday_open_time"] : @"";
    
    
    return self;
}


+(NSString *)getEventTimeFromDictionary:(NSDictionary *)eventTime
{
    EventDateModel *model = [[EventDateModel alloc] initWithDictionary:eventTime];
    
    NSString *time = [[NSString alloc] init];
    
    if (![model.mondayEndTime isEqualToString:@""] && ![model.mondayStartTime isEqualToString:@""])
    {
        if(([model.mondayStartTime isEqualToString:@"00:00:00"] && [model.mondayEndTime isEqualToString:@"00:00:00"]) || ([model.mondayStartTime isEqualToString:@"12:00:00"] && [model.mondayEndTime isEqualToString:@"00:00:00"]) || ([model.mondayStartTime isEqualToString:@"00:00:00"] && [model.mondayEndTime isEqualToString:@"12:00:00"]))
            time = [time stringByAppendingString:@"Open 24 Hours\n"];
        else
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%@    -  %@\n", [model getAMPMTimeFormat:model.mondayStartTime], [model getAMPMTimeFormat:model.mondayEndTime]]];
    }else {
        time = [time stringByAppendingString:@"Closed\n"];
    }
    if (![model.tuesdayEndTime isEqualToString:@""] && ![model.tuesdayStartTime isEqualToString:@""])
    {
        if(([model.tuesdayStartTime isEqualToString:@"00:00:00"] && [model.tuesdayEndTime isEqualToString:@"00:00:00"]) || ([model.tuesdayStartTime isEqualToString:@"12:00:00"] && [model.tuesdayEndTime isEqualToString:@"00:00:00"]) || ([model.tuesdayStartTime isEqualToString:@"00:00:00"] && [model.tuesdayEndTime isEqualToString:@"12:00:00"]))
            time = [time stringByAppendingString:@"Open 24 Hours\n"];
        else
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%@    -  %@\n", [model getAMPMTimeFormat:model.tuesdayStartTime], [model getAMPMTimeFormat:model.tuesdayEndTime]]];
    }else {
        time = [time stringByAppendingString:@"Closed\n"];
    }
    if (![model.wednesdayEndTime isEqualToString:@""] && ![model.wednesdayStartTime isEqualToString:@""])
    {
        if(([model.wednesdayStartTime isEqualToString:@"00:00:00"] && [model.wednesdayEndTime isEqualToString:@"00:00:00"]) || ([model.wednesdayStartTime isEqualToString:@"12:00:00"] && [model.wednesdayEndTime isEqualToString:@"00:00:00"]) || ([model.wednesdayStartTime isEqualToString:@"00:00:00"] && [model.wednesdayEndTime isEqualToString:@"12:00:00"]))
            time = [time stringByAppendingString:@"Open 24 Hours\n"];
        else
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%@    -  %@\n", [model getAMPMTimeFormat:model.wednesdayStartTime], [model getAMPMTimeFormat:model.wednesdayEndTime]]];
    }else {
        time = [time stringByAppendingString:@"Closed\n"];
    }
    if (![model.thursdayEndTime isEqualToString:@""] && ![model.thursdayStartTime isEqualToString:@""])
    {
        if(([model.thursdayStartTime isEqualToString:@"00:00:00"] && [model.thursdayEndTime isEqualToString:@"00:00:00"]) || ([model.thursdayStartTime isEqualToString:@"12:00:00"] && [model.thursdayEndTime isEqualToString:@"00:00:00"]) || ([model.thursdayStartTime isEqualToString:@"00:00:00"] && [model.thursdayEndTime isEqualToString:@"12:00:00"]))
            time = [time stringByAppendingString:@"Open 24 Hours\n"];
        else
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%@    -  %@\n", [model getAMPMTimeFormat:model.thursdayStartTime], [model getAMPMTimeFormat:model.thursdayEndTime]]];
    }else {
        time = [time stringByAppendingString:@"Closed\n"];
    }
    if (![model.fridayEndTime isEqualToString:@""] && ![model.fridayStartTime isEqualToString:@""])
    {
        if(([model.fridayStartTime isEqualToString:@"00:00:00"] && [model.fridayEndTime isEqualToString:@"00:00:00"]) || ([model.fridayStartTime isEqualToString:@"12:00:00"] && [model.fridayEndTime isEqualToString:@"00:00:00"]) || ([model.fridayStartTime isEqualToString:@"00:00:00"] && [model.fridayEndTime isEqualToString:@"12:00:00"]))
            time = [time stringByAppendingString:@"Open 24 Hours\n"];
        else
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%@    -  %@\n", [model getAMPMTimeFormat:model.fridayStartTime], [model getAMPMTimeFormat:model.fridayEndTime]]];
    }else {
        time = [time stringByAppendingString:@"Closed\n"];
    }
    if (![model.saturdayEndTime isEqualToString:@""] && ![model.saturdayStartTime isEqualToString:@""])
    {
        if(([model.saturdayStartTime isEqualToString:@"00:00:00"] && [model.saturdayEndTime isEqualToString:@"00:00:00"]) || ([model.saturdayStartTime isEqualToString:@"12:00:00"] && [model.saturdayEndTime isEqualToString:@"00:00:00"]) || ([model.saturdayStartTime isEqualToString:@"00:00:00"] && [model.saturdayEndTime isEqualToString:@"12:00:00"]))
            time = [time stringByAppendingString:@"Open 24 Hours\n"];
        else
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%@    -  %@\n", [model getAMPMTimeFormat:model.saturdayStartTime], [model getAMPMTimeFormat:model.saturdayEndTime]]];
    }else {
        time = [time stringByAppendingString:@"Closed\n"];
    }
    if (![model.sundayEndTime isEqualToString:@""] && ![model.sundayStartTime isEqualToString:@""])
    {
        if(([model.sundayStartTime isEqualToString:@"00:00:00"] && [model.sundayEndTime isEqualToString:@"00:00:00"]) || ([model.sundayStartTime isEqualToString:@"12:00:00"] && [model.sundayEndTime isEqualToString:@"00:00:00"]) || ([model.sundayStartTime isEqualToString:@"00:00:00"] && [model.sundayEndTime isEqualToString:@"12:00:00"]))
            time = [time stringByAppendingString:@"Open 24 Hours\n"];
        else
            time = [time stringByAppendingString:[NSString stringWithFormat:@"%@    -  %@", [model getAMPMTimeFormat:model.sundayStartTime], [model getAMPMTimeFormat:model.sundayEndTime]]];
    }else {
        time = [time stringByAppendingString:@"Closed"];
    }
    
    
    return time;
}

//From 23:00:00 to:: 11:00 pm
-(NSString *)getAMPMTimeFormat:(NSString *)time
{
    BOOL isPM = NO;
    int hours = [[time substringToIndex:2] intValue];
    int minutes = [[time substringWithRange:NSMakeRange(3, 2)] intValue];
    
    if (hours >= 12)
    {
        hours = hours - 12;
        isPM = YES;
    }
    if(hours == 0)
        hours = 12;
    
    NSString *hoursString = hours < 10 ? [NSString stringWithFormat:@"  %d", hours] : [NSString stringWithFormat:@"%d", hours];

    NSString *minutesString = minutes < 10 ? [NSString stringWithFormat:@"0%d", minutes] : [NSString stringWithFormat:@"%d", minutes];
    
    NSString *timeString = [NSString stringWithFormat:@"%@:%@ %@", hoursString, minutesString, isPM ? @"pm" : @"am"];
    return timeString;
}

-(BOOL)isValueExist:(id)value
{
    if ([value isKindOfClass:[NSNull class]] || value == nil)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
