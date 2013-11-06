//
//  RelatedPerksModel.h
//  WutzWhat
//
//  Created by Zeeshan on 1/30/13.
//
//

#import <Foundation/Foundation.h>

@interface RelatedPerksModel : NSObject
@property (nonatomic,retain) NSString  *id;
@property (nonatomic,retain) NSString  *discount_price;
@property (nonatomic,retain) NSString  *distance;
@property (nonatomic,retain) NSString *headline;
@property (nonatomic,readwrite) int likeCount;
@property (nonatomic,retain) NSString *min_credits;
@property (nonatomic,retain) NSString *orig_price;
@property (nonatomic,retain) NSString *perk_id;
@property (nonatomic,retain) NSString *short_desc;
@property (nonatomic,retain) NSString *thumb_url;
@property (nonatomic,retain) NSString  *title;
@end
