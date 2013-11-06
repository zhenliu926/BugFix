//
//  CreditCardInfoModel.h
//  WutzWhat
//
//  Created by iPhone Development on 2/25/13.
//
//

#import <Foundation/Foundation.h>

@interface CreditCardInfoModel : NSObject

@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cardType;
@property (strong, nonatomic) NSString *cardToken;
@property (assign, nonatomic) BOOL defaultCard;

-(id)initWithDictionary:(NSDictionary *)dict;
+(NSArray *)parseCreditCardInfoFromArray:(NSArray *)cardArray;
+(CreditCardInfoModel *)parseCreditCardInfoFromDictionary:(NSDictionary *)cardDictionary;

@end
