//
//  TalksModel.m
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import "TalksModel.h"
#import "CommonFunctions.h"
@implementation TalksModel

@synthesize startDate, endDate, description, categoryType, distance, info, latitude, longitude, postId, postTime, price, thumbnailURL, title;


-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.distance = [CommonFunctions isValueExist:[dict objectForKey:@"distance"]] ? [[dict objectForKey:@"distance"] intValue] : -1;
    self.info = [CommonFunctions isValueExist:[dict objectForKey:@"info"]] ? [dict objectForKey:@"info"] : @"";
    self.endDate = [CommonFunctions isValueExist:[dict objectForKey:@"event_date"]] ? [dict objectForKey:@"event_date"] : @"";
    self.categoryType = [[dict objectForKey:@"postType"] intValue];
    self.latitude = [[dict objectForKey:@"location"] objectForKey:@"latitude"];
    self.longitude = [[dict objectForKey:@"location"] objectForKey:@"longitude"];
    self.postId = [dict objectForKey:@"postId"];
    self.postTime = [CommonFunctions getDateFromUnixTimeStamp:[dict objectForKey:@"postTime"]];
    self.thumbnailURL = [CommonFunctions isValueExist:[dict objectForKey:@"thumb_url"]] ? [dict objectForKey:@"thumb_url"] : @"";
    self.price = [CommonFunctions isValueExist:[dict objectForKey:@"price"]] ? [[dict objectForKey:@"price"] intValue] : 0;
    self.title = [dict objectForKey:@"title"];
    return self;
}


+(NSArray *)parseTalksResponse:(NSArray *)responseArray
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in responseArray)
    {
        TalksModel *model = [[TalksModel alloc] initWithDictionary:dict];
        
        [modelArray addObject:model];
    }
    
    return modelArray;
}


+(NSDictionary *)sortResponseArrayByFilterApplied:(int)filterBy responseArray:(NSArray *)responseArray
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postTime" ascending:NO];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    responseArray = [responseArray sortedArrayUsingDescriptors:sortDescriptors];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < responseArray.count; i++)
    {
        TalksModel *model = [responseArray objectAtIndex:i];
        id filterKey = model.postTime;
        
        NSMutableArray * specificRows = [dict objectForKey:filterKey];
        
        if (!specificRows)
        {
            specificRows = [[NSMutableArray alloc] init];
        }
        
        [specificRows addObject:model];
        
        [dict setObject:specificRows forKey:filterKey];
    }
    
    return dict;
}

@end
