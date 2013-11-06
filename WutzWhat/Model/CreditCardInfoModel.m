//
//  CreditCardInfoModel.m
//  WutzWhat
//
//  Created by iPhone Development on 2/25/13.
//
//

#import "CreditCardInfoModel.h"

@implementation CreditCardInfoModel

-(id)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    self.cardNumber = [self isValueExist:[dict objectForKey:@"Card_number"]] ? [dict objectForKey:@"Card_number"] : @"";
    self.cardToken = [self isValueExist:[dict objectForKey:@"card_token"]] ? [dict objectForKey:@"card_token"] : @"";
    self.cardType = [self isValueExist:[dict objectForKey:@"card_type"]] ? [dict objectForKey:@"card_type"] : @"";
    self.defaultCard = [self isValueExist:[dict objectForKey:@"isDefault"]] ? [[dict objectForKey:@"isDefault"] boolValue] : NO;
    
    return self;
}


+(NSArray *)parseCreditCardInfoFromArray:(NSArray *)cardArray;
{
    NSMutableArray *cards = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dict in cardArray)
    {
        CreditCardInfoModel *model = [[CreditCardInfoModel alloc] initWithDictionary:dict];
        [cards addObject:model];
    }
    
    return cards;
}

+(CreditCardInfoModel *)parseCreditCardInfoFromDictionary:(NSDictionary *)cardDictionary
{
    CreditCardInfoModel *model = [[CreditCardInfoModel alloc] initWithDictionary:cardDictionary];

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
