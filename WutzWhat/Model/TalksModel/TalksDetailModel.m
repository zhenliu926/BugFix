//
//  TalksDetailModel.m
//  WutzWhat
//
//  Created by iPhone Development on 4/25/13.
//
//

#import "TalksDetailModel.h"

@implementation TalksDetailModel

@synthesize startDate, endDate, description, info, postId, postTime, price, thumbnailURL, title;

-(id)initWithDetailsDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.address = [CommonFunctions isValueExist:[dict objectForKey:@"address"]] ? [dict objectForKey:@"address"] : @"";
    self.description = [CommonFunctions isValueExist:[dict objectForKey:@"description"]] ? [dict objectForKey:@"description"] : @"";
    self.endDate = [CommonFunctions isValueExist:[dict objectForKey:@"end_date"]] ? [dict objectForKey:@"end_date"] : @"";
    self.info = [CommonFunctions isValueExist:[dict objectForKey:@"info"]] ? [dict objectForKey:@"info"] : @"";
    self.pnumber = [CommonFunctions isValueExist:[dict objectForKey:@"pnumber"]] ? [dict objectForKey:@"pnumber"] : @"";
    self.postTime = [CommonFunctions getDateFromUnixTimeStamp:[dict objectForKey:@"postTime"]];
    self.startDate = [CommonFunctions isValueExist:[dict objectForKey:@"start_date"]] ? [dict objectForKey:@"start_date"] : @"";
    self.webLink = [CommonFunctions isValueExist:[dict objectForKey:@"webLink"]] ? [dict objectForKey:@"webLink"] : @"";
    self.postalCode = [CommonFunctions isValueExist:[dict objectForKey:@"postalCode"]] ? [dict objectForKey:@"postalCode"] : @"";
    self.price = [CommonFunctions isValueExist:[dict objectForKey:@"price"]] ? [dict objectForKey:@"price"] : @"";
    self.title = [CommonFunctions isValueExist:[dict objectForKey:@"title"]] ? [dict objectForKey:@"title"] : @"";
    
    self.imagesArray = [ImagesURLModel parseImagesURL:[dict objectForKey:@"images"]];
    return self;
}


+(TalksDetailModel *)parseTalksDetailResponse:(NSDictionary *)responseDict
{
    TalksDetailModel *model = [[TalksDetailModel alloc] initWithDetailsDictionary:responseDict];
    
    return model;
}


@end
