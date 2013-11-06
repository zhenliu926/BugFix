//
//  HotPicksModel.h
//  WutzWhat
//
//  Created by Rafay on 11/22/12.
//
//

#import <Foundation/Foundation.h>
#import "DataModel.h"
#import "AuthorInfoModel.h"
#import "LikeInfoModel.h"
#import "LocationModel.h"

@interface HotPicksModel : NSObject

@property (nonatomic,retain) UIImage *thumbnail;
@property (nonatomic,readwrite) int perkCount;
@property (nonatomic,readwrite) int type;

@property (nonatomic,readwrite) BOOL isFavourited;
@property (nonatomic,readwrite) BOOL isHotpick;

@property (nonatomic,retain) NSString *AWSAcessKeyId;

@property (nonatomic,retain) DataModel *dataInfo;
@property (nonatomic,retain) AuthorInfoModel *authorInfo;
@property (nonatomic,retain) LikeInfoModel *likeInfo;
@property (nonatomic,retain) LocationModel *locationInfo;

@end