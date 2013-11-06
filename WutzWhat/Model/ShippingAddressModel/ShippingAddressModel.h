//
//  ShippingAddressModel.h
//  WutzWhat
//
//  Created by iPhone Development on 3/13/13.
//
//

#import <Foundation/Foundation.h>

@interface ShippingAddressModel : NSObject
{
    
}

@property (strong, nonatomic) NSString *addressID;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *streetAddress;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *country;

-(id)initWithDictionary:(NSDictionary *)dict;
+(ShippingAddressModel *)parseShippingAddressFromDictionary:(NSDictionary *)shippingDict;


@end
