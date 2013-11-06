//
//  TalksModel.h
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import <Foundation/Foundation.h>

@interface TalksModel : NSObject

@property (nonatomic) int categoryType;
@property (nonatomic) int distance;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSDate *postTime;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *description;
@property (nonatomic) int price;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnailURL;

-(id)initWithDictionary:(NSDictionary *)dict;

+(NSArray *)parseTalksResponse:(NSArray *)responseArray;

+(NSDictionary *)sortResponseArrayByFilterApplied:(int)filterBy responseArray:(NSArray *)responseArray;


@end
