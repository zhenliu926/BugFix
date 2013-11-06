//
//  WutzWhatModel.h
//  WutzWhat
//
//  Created by Asad Ali on 04/10/13.
//
//

#import <Foundation/Foundation.h>

@interface WutzWhatModel : NSObject

@property (nonatomic) int categoryType;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *eventEndDate;
@property (nonatomic, strong) NSString *eventStartDate;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSDate *postTime;
@property (nonatomic) int price;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *thumbnailURL;
@property (nonatomic,readwrite) int perkCount;
@property (nonatomic,readwrite) BOOL isFavourited;
@property (nonatomic,readwrite) BOOL isHotpick;
@property (nonatomic,readwrite) int likeCount;
@property (nonatomic,readwrite) BOOL isLiked;
@property (nonatomic, readwrite) BOOL hasVideo;
@property (nonatomic, readwrite) NSString *address;
-(id)initWithDictionary:(NSDictionary *)dict;

+(NSArray *)parseWutzWhatResponse:(NSArray *)responseArray;

+(NSDictionary *)sortResponseArrayByFilterApplied:(int)filterBy responseArray:(NSArray *)responseArray;

@end
