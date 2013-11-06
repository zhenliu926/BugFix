//
//  PerksFavouritesModel.h
//  WutzWhat
//
//  Created by Zeeshan on 2/5/13.
//
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import "AuthorInfoModel.h"
#import "LikeInfoModel.h"
#import "LocationModel.h"
@interface PerksFavouritesModel : NSObject

@property (nonatomic) int type;
@property (nonatomic,readwrite) BOOL isFavourited;
@property (nonatomic,retain) NSString *AWSAcessKeyId;
@property (nonatomic,retain) NSString *min_credits;
@property (nonatomic,retain) DataModel *dataInfo;
@property (nonatomic,retain) AuthorInfoModel *authorInfo;
@property (nonatomic,retain) LikeInfoModel *likeInfo;
@property (nonatomic,retain) LocationModel *locationInfo;

@end
