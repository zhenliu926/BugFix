//
//  TaxInfoModel.h
//  WutzWhat
//
//  Created by iPhone Development on 3/13/13.
//
//

#import <Foundation/Foundation.h>
#import "CreditCardInfoModel.h"

@interface TaxInfoModel : NSObject
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
@property (strong, nonatomic) NSString *calculatedPrice;
@property (strong, nonatomic) NSString *quantity;
@property (strong, nonatomic) NSString *hst;
@property (strong, nonatomic) NSString *gst;
@property (strong, nonatomic) NSString *shippingRateCanada;
@property (strong, nonatomic) NSString *shippingRateUSA;
@property (strong, nonatomic) NSString *shippingRateInternational;

@property (strong, nonatomic) CreditCardInfoModel *creditCardModel;


-(id)initWithDictionary:(NSDictionary *)dict;
+(TaxInfoModel *)parseTaxInfoFromDictionary:(NSDictionary *)shippingDict;



@end
