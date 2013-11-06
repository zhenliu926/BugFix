//
//  EventDateModel.h
//  WutzWhat
//
//  Created by iPhone Development on 3/16/13.
//
//

#import <Foundation/Foundation.h>

@interface EventDateModel : NSObject
{
    
}

@property (strong, nonatomic) NSString *mondayStartTime;
@property (strong, nonatomic) NSString *tuesdayStartTime;
@property (strong, nonatomic) NSString *wednesdayStartTime;
@property (strong, nonatomic) NSString *thursdayStartTime;
@property (strong, nonatomic) NSString *fridayStartTime;
@property (strong, nonatomic) NSString *saturdayStartTime;
@property (strong, nonatomic) NSString *sundayStartTime;
@property (strong, nonatomic) NSString *mondayEndTime;
@property (strong, nonatomic) NSString *tuesdayEndTime;
@property (strong, nonatomic) NSString *wednesdayEndTime;
@property (strong, nonatomic) NSString *thursdayEndTime;
@property (strong, nonatomic) NSString *fridayEndTime;
@property (strong, nonatomic) NSString *saturdayEndTime;
@property (strong, nonatomic) NSString *sundayEndTime;

-(id)initWithDictionary:(NSDictionary *)dict;
+(NSString *)getEventTimeFromDictionary:(NSDictionary *)eventTime;

@end
