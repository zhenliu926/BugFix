//
//  WutzWhatModel.h
//  WutzWhat
//
//  Created by Asad Ali on 04/10/13.
//
//

#import "WutzWhatModel.h"

@implementation WutzWhatModel

@synthesize perkCount, categoryType, description, distance, eventEndDate, eventStartDate, info, isFavourited, isHotpick, isLiked, latitude, likeCount, longitude, postId, postTime, price, thumbnailURL, title, hasVideo, address;


-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.description = [dict objectForKey:@"description"];
    self.distance = [CommonFunctions isValueExist:[dict objectForKey:@"distance"]] ? [NSNumber numberWithInt:[[dict objectForKey:@"distance"] intValue]] : 0;
    
    self.eventEndDate = [dict objectForKey:@"event_end_date"];
    self.eventStartDate = [dict objectForKey:@"event_start_date"];
    self.isFavourited = [[dict objectForKey:@"favourited"] boolValue];
    self.isHotpick = [[dict objectForKey:@"hotpick"] boolValue];
    self.info = [dict objectForKey:@"info"];
    self.latitude = [dict objectForKey:@"latitude"];
    self.longitude = [dict objectForKey:@"longitude"];
    self.postId = [dict objectForKey:@"postId"];
    self.perkCount = [[dict objectForKey:@"perk_count"] intValue];
    self.isLiked = [[dict objectForKey:@"liked"] boolValue];
    self.likeCount = [[dict objectForKey:@"likeCount"] intValue];
    self.postTime = [CommonFunctions getDateFromUnixTimeStamp:[dict objectForKey:@"postTime"]];
    self.thumbnailURL = [CommonFunctions isValueExist:[dict objectForKey:@"thumb_url"]] ? [dict objectForKey:@"thumb_url"] : @"";
    self.address = @"";
    self.price = [[dict objectForKey:@"price"] intValue];
    self.title = [dict objectForKey:@"title"]; 
    self.hasVideo = [[dict objectForKey:@"hasVideo"] boolValue];
    return self;
}


+(NSArray *)parseWutzWhatResponse:(NSArray *)responseArray
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in responseArray)
    {
        WutzWhatModel *model = [[WutzWhatModel alloc] initWithDictionary:dict];
        
        [modelArray addObject:model];
    }
    
    return modelArray;
}


+(NSDictionary *)sortResponseArrayByFilterApplied:(int)filterBy responseArray:(NSArray *)responseArray
{
    NSSortDescriptor *sortDescriptor;
    
    if (filterBy == 1)
    {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postTime" ascending:NO];
    }
    else if (filterBy == 2)
    {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
    }
    else if (filterBy == 3)
    {
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postTime" ascending:NO];
    }
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSArray *sortedArray = [responseArray sortedArrayUsingDescriptors:sortDescriptors];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < sortedArray.count; i++)
    {
        WutzWhatModel *model = [sortedArray objectAtIndex:i];
        id filterKey;
        
        if (filterBy == 1)
        {
            filterKey = model.postTime;
        }
        else if (filterBy == 2)
        {
            int distance = [model.distance intValue];
            
            
            if (distance < 100)
            {
                filterKey = [NSNumber numberWithInt:100];
            }
            else if(distance < 300)
            {
                filterKey = [NSNumber numberWithInt:300];
            }
            else if(distance < 500)
            {
                filterKey = [NSNumber numberWithInt:500];
            }
            else if(distance < 1000)
            {
                filterKey = [NSNumber numberWithInt:1000];
            }
            else if(distance < 3000)
            {
                filterKey = [NSNumber numberWithInt:3000];
            }
            else if(distance < 5000)
            {
                filterKey = [NSNumber numberWithInt:5000];
            }
            else if(distance < 10000)
            {
                filterKey = [NSNumber numberWithInt:10000];
            }
            else if (distance >= 10000)
            {
                filterKey = [NSNumber numberWithInt:10001];
            }
            if (distance >= 321869 || distance >= 100000)
            {
                filterKey = [NSNumber numberWithInt:100000];
            }
        }
        else if (filterBy == 3)
        {
            filterKey = model.postTime;//[NSString stringWithFormat:@"%@ - %@", model.eventStartDate, model.eventEndDate];
        }
        
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


