//
//  TaxInfoModel.m
//  WutzWhat
//
//  Created by iPhone Development on 3/13/13.
//
//

#import "TaxInfoModel.h"

@implementation TaxInfoModel

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
    self.calculatedPrice = [self isValueExist:[dict objectForKey:@"calculated_price"]] ? [dict objectForKey:@"calculated_price"] : @"";
    self.hst = [self isValueExist:[dict objectForKey:@"hst"]] ? [dict objectForKey:@"hst"] : @"";
    self.gst = [self isValueExist:[dict objectForKey:@"gst"]] ? [dict objectForKey:@"gst"] : @"";
    self.quantity = [self isValueExist:[dict objectForKey:@"quantity"]] ? [dict objectForKey:@"quantity"] : @"";
    self.shippingRateCanada = [self isValueExist:[dict objectForKey:@"ship_rate_can"]] ? [dict objectForKey:@"ship_rate_can"] : @"";
    self.shippingRateUSA = [self isValueExist:[dict objectForKey:@"ship_rate_us"]] ? [dict objectForKey:@"ship_rate_us"] : @"";
    self.shippingRateInternational = [self isValueExist:[dict objectForKey:@"ship_rate_intl"]] ? [dict objectForKey:@"ship_rate_intl"] : @"";
    self.creditCardModel = [CreditCardInfoModel parseCreditCardInfoFromDictionary:[dict objectForKey:@"card_data"]];
    
    return self;
}


+(TaxInfoModel *)parseTaxInfoFromDictionary:(NSDictionary *)shippingDict
{
    TaxInfoModel *model = [[TaxInfoModel alloc] initWithDictionary:shippingDict];
    
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
