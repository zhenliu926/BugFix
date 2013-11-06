//
//  DataModel.h
//  WutzWhat
//
//  Created by Kashif on 12/08/12.
//
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property (nonatomic,retain) NSString  *title;
@property (nonatomic,retain) NSString  *description;
@property (nonatomic,retain) NSString  *info;
@property (nonatomic,retain) NSString  *price;
@property (nonatomic,retain) NSString  *distance;
@property (nonatomic,retain) NSString  *event_date;
@property (nonatomic,retain) NSString  *start_date;
@property (nonatomic,retain) NSString  *end_date;
@property (nonatomic,retain) NSString  *postId;
@property (nonatomic,retain) NSString  *postTime;
@property (nonatomic,retain) NSString  *thumbnailUrl;
@property (nonatomic,retain) NSString  *headline;
@property (nonatomic,retain) NSString  *time;
@property (nonatomic,retain) NSString  *reviews;
@property (nonatomic,retain) NSString  *tags;
@property (nonatomic,retain) NSString  *pdfID;
//Special For Perks
@property (nonatomic,retain) NSString *cat_id;
@property (nonatomic,assign) int min_credits;
@property (nonatomic,assign) int baseCityID;
@property (nonatomic,assign) int discount_price;
@property (nonatomic,assign) int originalPrice;
@property (nonatomic,assign) int userCredits;
@property (nonatomic,assign) BOOL isShipping;
@property (nonatomic,assign) BOOL isCreditsRequired;
@end
