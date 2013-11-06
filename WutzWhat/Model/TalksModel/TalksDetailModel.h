//
//  TalksDetailModel.h
//  WutzWhat
//
//  Created by iPhone Development on 4/25/13.
//
//

#import <Foundation/Foundation.h>
#import "ImagesURLModel.h"

@interface TalksDetailModel : NSObject

@property (nonatomic, strong) NSString *webLink;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *pnumber;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSDate *postTime;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic, strong) NSArray *imagesArray;


-(id)initWithDetailsDictionary:(NSDictionary *)dict;

+(TalksDetailModel *)parseTalksDetailResponse:(NSDictionary *)responseDict;

@end
