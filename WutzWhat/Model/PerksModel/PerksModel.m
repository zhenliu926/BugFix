//
//  PerksModel.m
//  WutzWhat
//
//  Created by Rafay on 12/11/12.
//
//

#import "PerksModel.h"

@implementation PerksModel

@synthesize perkCount, categoryType, shortDescription, distance, eventEndDate, eventStartDate, info, isFavourited, isHotpick, isLiked, latitude, likeCount, longitude, postId, postTime, price, thumbnailURL, title, minCredits, baseCityID, catId, discountPrice, isCreditsRequired, isShipping, originalPrice, userCredits, hasVideo;


-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.shortDescription = [dict objectForKey:@"short_desc"];
    self.discountPrice = [[dict objectForKey:@"discount_price"] floatValue];
    self.minCredits = [[dict objectForKey:@"min_credits"] intValue];
    self.originalPrice = [[dict objectForKey:@"orig_price"] floatValue];
    self.categoryType = [[dict objectForKey:@"cat_id"] intValue];
    self.distance = [CommonFunctions isValueExist:[dict objectForKey:@"distance"]] ? [NSNumber numberWithInt:[[dict objectForKey:@"distance"] intValue]] : 0;
    
    self.isFavourited = [[dict objectForKey:@"isfav"] boolValue];
    self.info = [dict objectForKey:@"headline"];
    self.latitude = [dict objectForKey:@"latitude"];
    self.longitude = [dict objectForKey:@"longitude"];
    self.postId = [dict objectForKey:@"perk_id"];
    self.isLiked = [[dict objectForKey:@"islike"] boolValue];
    self.likeCount = [[dict objectForKey:@"likeCount"] intValue];
    self.postTime = [CommonFunctions getDateFromUnixTimeStamp:[dict objectForKey:@"post_time"]];
    self.thumbnailURL = [CommonFunctions isValueExist:[dict objectForKey:@"thumb_url"]] ? [dict objectForKey:@"thumb_url"] : @"";
    self.title = [dict objectForKey:@"title"];
    self.hasVideo = [[dict objectForKey:@"hasVideo"] boolValue];
    return self;
}


+(NSArray *)parsePerksResponse:(NSArray *)responseArray
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in responseArray)
    {
        PerksModel *model = [[PerksModel alloc] initWithDictionary:dict];
        
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
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postTime" ascending:YES];
    }
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSArray *sortedArray = [responseArray sortedArrayUsingDescriptors:sortDescriptors];
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < sortedArray.count; i++)
    {
        PerksModel *model = [sortedArray objectAtIndex:i];  
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
                filterKey = [NSNumber numberWithInt:100000];
            }
        }
        else if (filterBy == 3)
        {
            filterKey = model.postTime;
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


