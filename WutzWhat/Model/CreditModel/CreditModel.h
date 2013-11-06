//
//  CreditModel.h
//  WutzWhat
//
//  Created by Rafay on 11/23/12.
//
//

#import <Foundation/Foundation.h>
#import "DataModel.h"

@interface CreditModel : NSObject
@property (nonatomic,retain) NSString  *credit;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *creditHistory;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString  *title;
@property (nonatomic,retain) NSString *summary;
@property (nonatomic, retain) NSString *transaction_money;
@property (nonatomic, retain) UIImageView * thumbnail;
@property (nonatomic,readwrite) BOOL isFavourited;
@property (nonatomic,retain) NSString *AWSAcessKeyId;
@property (nonatomic,retain) NSString *min_credits;
@property (nonatomic,retain) DataModel *dataInfo;
@property (nonatomic,retain) AuthorInfoModel *authorInfo;
@property (nonatomic,retain) LikeInfoModel *likeInfo;
@property (nonatomic,retain) LocationModel *locationInfo;
@end
