//
//  GoogleLocationAPIModel.h
//  WutzWhat
//
//  Created by iPhone Development on 3/21/13.
//
//

#import <Foundation/Foundation.h>

@interface GoogleLocationAPIModel : NSObject
{
    
}

@property (strong, nonatomic) NSString *formattedAddress;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;


-(id)initWithDictionary:(NSDictionary *)dict;

+(NSArray *)parseAddressFromArray:(NSDictionary *)addressDict;

@end
