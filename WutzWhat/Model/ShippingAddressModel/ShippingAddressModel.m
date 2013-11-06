//
//  ShippingAddressModel.m
//  WutzWhat
//
//  Created by iPhone Development on 3/13/13.
//
//

#import "ShippingAddressModel.h"

@implementation ShippingAddressModel


-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.firstName = [self isValueExist:[dict objectForKey:@"first_name"]] ? [dict objectForKey:@"first_name"] : @"";
    self.lastName = [self isValueExist:[dict objectForKey:@"last_name"]] ? [dict objectForKey:@"last_name"] : @"";
    self.streetAddress = [self isValueExist:[dict objectForKey:@"street_address"]] ? [dict objectForKey:@"street_address"] : @"";
    self.postalCode = [self isValueExist:[dict objectForKey:@"postal_code"]] ? [dict objectForKey:@"postal_code"] : @"";
    self.city = [self isValueExist:[dict objectForKey:@"city"]] ? [dict objectForKey:@"city"] : @"";
    self.province = [self isValueExist:[dict objectForKey:@"province"]] ? [dict objectForKey:@"province"] : @"";
    self.country = [self isValueExist:[dict objectForKey:@"country"]] ? [dict objectForKey:@"country"] : @"";
    self.addressID = [self isValueExist:[dict objectForKey:@"addr_id"]] ? [dict objectForKey:@"addr_id"] : @"";
    
    return self;
}


+(ShippingAddressModel *)parseShippingAddressFromDictionary:(NSDictionary *)shippingDict
{
    ShippingAddressModel *model = [[ShippingAddressModel alloc] initWithDictionary:shippingDict];
    
    return model;
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
