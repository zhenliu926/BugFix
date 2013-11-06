//
//  PerksModel.h
//  WutzWhat
//
//  Created by Rafay on 12/11/12.
//
//

#import <Foundation/Foundation.h>

@interface PerksModel : NSObject

@property (nonatomic) int categoryType;
@property (nonatomic, strong) NSString *shortDescription;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *eventEndDate;
@property (nonatomic, strong) NSString *eventStartDate;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSDate *postTime;
@property (nonatomic) int price;
@property (nonatomic,assign) int minCredits;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic,readwrite) int perkCount;
@property (nonatomic,readwrite) BOOL isFavourited;
@property (nonatomic,readwrite) BOOL isHotpick;
@property (nonatomic,readwrite) int likeCount;
@property (nonatomic,readwrite) BOOL isLiked;

//Special For Perks Details
@property (nonatomic,retain) NSString *catId;
@property (nonatomic,assign) int baseCityID;
@property (nonatomic,assign) float discountPrice;
@property (nonatomic,assign) float originalPrice;
@property (nonatomic,assign) int userCredits;
@property (nonatomic,assign) BOOL isShipping;
@property (nonatomic,assign) BOOL isCreditsRequired;
@property (nonatomic,assign) BOOL hasVideo;
@property (nonatomic, retain) NSString *address;
-(id)initWithDictionary:(NSDictionary *)dict;

+(NSArray *)parsePerksResponse:(NSArray *)responseArray;

+(NSDictionary *)sortResponseArrayByFilterApplied:(int)filterBy responseArray:(NSArray *)responseArray;

@end
