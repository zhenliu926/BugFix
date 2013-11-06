//
//  FilterModel.h
//  WutzWhat
//
//  Created by iPhone Development on 1/23/13.
//
//

#import <Foundation/Foundation.h>
#import "CoreLocation/CoreLocation.h"

@interface FilterModel : NSObject

@property (nonatomic,assign) NSInteger filterBy;
@property (nonatomic,assign) NSInteger categoryType;
@property (nonatomic,assign) float  priceMax;
@property (nonatomic,assign) float  priceMin;
@property (nonatomic, readwrite) BOOL  openNowOnly;
@property (nonatomic,assign) float longitude;
@property (nonatomic,assign) float latitude;
@property (nonatomic,retain) NSString  *startDate;
@property (nonatomic,retain) NSString  *endDate;

@end
