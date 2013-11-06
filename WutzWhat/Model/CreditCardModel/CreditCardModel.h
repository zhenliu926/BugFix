//
//  CreditCardModel.h
//  WutzWhat
//
//  Created by iPhone Development on 2/25/13.
//
//

#import <Foundation/Foundation.h>

@interface CreditCardModel : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *cardHolderName;
@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cardExpiryDate;
@property (strong, nonatomic) NSString *cardCVVNumber;
@property (strong, nonatomic) NSString *address1;
@property (strong, nonatomic) NSString *address2;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;

@end
