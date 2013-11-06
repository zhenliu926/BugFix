//
//  GoogleLocationAPIModel.m
//  WutzWhat
//
//  Created by iPhone Development on 3/21/13.
//
//

#import "GoogleLocationAPIModel.h"

@implementation GoogleLocationAPIModel


-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.formattedAddress = [dict objectForKey:@"formatted_address"];
    self.latitude = [[[dict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
    self.longitude = [[[dict objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        
    return self;
}


+(NSArray *)parseAddressFromArray:(NSArray *)addressArray;
{
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *addressDict in addressArray)
    {
        GoogleLocationAPIModel *model = [[GoogleLocationAPIModel alloc] initWithDictionary:addressDict];
        [modelArray addObject:model];
    }
    
    return modelArray;
}

@end
