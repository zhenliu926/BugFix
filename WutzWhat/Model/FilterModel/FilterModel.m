//
//  FilterModel.m
//  WutzWhat
//
//  Created by iPhone Development on 1/23/13.
//
//

#import "FilterModel.h"

@implementation FilterModel

@synthesize filterBy = _filterBy;
@synthesize categoryType = _categoryType;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize openNowOnly = _openNowOnly;
@synthesize priceMax = _priceMax;
@synthesize priceMin = _priceMin;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:self.filterBy forKey:@"filterBy"];
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
    [encoder encodeFloat:self.latitude forKey:@"latitude"];
    [encoder encodeFloat:self.longitude forKey:@"longitude"];
    [encoder encodeBool:self.openNowOnly forKey:@"openNowOnly"];
    [encoder encodeFloat:self.priceMax forKey:@"priceMax"];
    [encoder encodeFloat:self.priceMin forKey:@"priceMin"];
    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if( self != nil )
    {
        self.filterBy = [decoder decodeIntegerForKey:@"filterBy"];
        self.startDate = [decoder decodeObjectForKey:@"startDate"];
        self.endDate = [decoder decodeObjectForKey:@"endDate"];
        self.latitude = [decoder decodeFloatForKey:@"latitude"];
        self.longitude = [decoder decodeFloatForKey:@"longitude"];
        self.openNowOnly = [decoder decodeBoolForKey:@"openNowOnly"];
        self.priceMax = [decoder decodeFloatForKey:@"priceMax"];
        self.priceMin = [decoder decodeFloatForKey:@"priceMin"];
    }
    return self;
}

@end
